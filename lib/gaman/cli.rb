require 'thor'
require 'rainbow'
require_relative 'messenger'
require_relative 'file_helper'

module Gaman
  class GitAccountManager < Thor
    include Gaman::Messenger
    include Gaman::FileHelper

    desc 'version', 'Show the Gaman version'
    map %w(-v --version) => :version

    def version
      puts "Gaman version #{::Gaman::VERSION} on Ruby #{RUBY_VERSION}"
    end

    desc 'current_user', 'Show current github account that ssh connects to'
    long_desc <<-current_user

    Params: --server (or -s): github/bitbucket

    If there is no param passed, github will be used as default

    current_user
    method_option :server, aliases: '-s'
    def current_user
      check_current_user options.fetch('server', 'github')
    end

    desc 'show', 'Show public key so you can copy to clipboard'
    def show
      eval_ssh_agent_s

      get_user_input_number(all_public_ssh_file) do |number, ssh_keys|
        show_ssh_key(number, ssh_keys)
      end
    end

    desc 'list', 'Check list ssh keys on machine'
    def list
      notice_message('Checking ssh keys in your machine...')
      display_ssh_keys(all_public_ssh_file)
    end

    desc 'new', 'Generate new ssh key'
    method_option :email, required: true, aliases: '-e'
    def new
      system("ssh-keygen -t rsa -b 4096 -C #{options[:email]}")
    end

    desc 'switch', 'Switch to another ssh key (pass key_index to directly switch)'
    long_desc <<-switch

    Params: key_index: key index from "list" method

    switch
    def switch(key_index = nil)
      if key_index.nil?
        switch_by_showing_list_keys
      else
        switch_by_key_index(key_index.to_i)
      end
    end

    def display_ssh_keys(ssh_keys)
      fail ArgumentError, 'ssh_keys must be an Array' unless ssh_keys.is_a? Array

      notice_message('You have no ssh key.') if ssh_keys.empty?

      ssh_keys.each_with_index do |key, index|
        puts "[#{Rainbow(index).underline.bright.cyan}] - #{key}"
      end
    end

    private

    def switch_by_key_index(key_index)
      ssh_keys = all_public_ssh_file
      return error_message('There are no ssh keys. Exiting...') if ssh_keys.empty?
      check_number_and_yield_if_valid(key_index, ssh_keys) do |number, ssh_keys|
        switch_ssh_key(number, ssh_keys)
      end
    end

    def switch_by_showing_list_keys
      eval_ssh_agent_s

      get_user_input_number(all_public_ssh_file) do |number, ssh_keys|
        switch_ssh_key(number, ssh_keys)
      end
    end

    def eval_ssh_agent_s
      system('eval "$(ssh-agent -s)"')
    end

    def all_public_ssh_file
      if File.exist?(ssh_path)
        Dir["#{ssh_path}/*.pub"]
      else
        notice_message('You have no ssh key. To create new one, run this command:')
        puts Rainbow('$ gaman new -e your_email@domain.com').blue
        []
      end
    end

    def get_user_input_number(ssh_keys)
      return error_message('There are no ssh keys. Exiting...') if ssh_keys.empty?

      notice_message('Current ssh keys on your system:')
      message = 'Which key do you want to switch? [Input number]'
      number = input_number(ssh_keys, message)
      if number_valid?(number, ssh_keys)
        block_given? ? yield(number, ssh_keys) : [number, ssh_keys]
      else
        error_message('Wrong value. Exiting...')
      end
      # check_number_and_yield_if_valid(number, ssh_keys)
    end

    def check_number_and_yield_if_valid(number, ssh_keys)
      if number_valid?(number, ssh_keys)
        block_given? ? yield(number, ssh_keys) : [number, ssh_keys]
      else
        error_message('Wrong value. Exiting...')
      end
    end

    def input_number(ssh_keys, message)
      display_ssh_keys(ssh_keys)
      number = ask(notice_message(message))
      begin
        Integer(number)
      rescue
        nil
      end
    end

    def number_valid?(number, ssh_keys)
      !number.nil? && number >= 0 && number <= ssh_keys.size - 1
    end

    def switch_ssh_key(number, ssh_keys)
      key = ssh_keys[number][0..-5]
      system('ssh-add -D')
      notice_message("Adding #{key}")
      system("ssh-add #{key}")
      current_user
    end

    def check_current_user(server)
      servers = { 'github' => 'github.com', 'bitbucket' => 'bitbucket.org' }
      notice_message("Checking ssh conection to #{server}...")
      system("ssh -T git@#{servers[server]}")
    end

    def show_ssh_key(number, ssh_keys)
      key = ssh_keys[number]
      system("cat #{key}")
    end
  end
end
