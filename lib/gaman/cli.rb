require 'thor'
require 'rainbow'
require_relative 'messenger'
require_relative 'file_helper'

module Gaman
  class GithubAccountManager < Thor
    include Gaman::Messenger
    include Gaman::FileHelper

    desc 'current_user', 'Show current github account that ssh connects to'
    long_desc <<-current_user

    Params: --server (or -s): github/bitbucket

    If there is no param passed, github will be used as default

    current_user
    method_option :server, aliases: '-s'
    def current_user
      server = options[:server]
      case server
      when 'github'
        check_current_user_github
      when 'bitbucket'
        check_current_user_bitbucket
      else
        check_current_user_github
      end
    end

    desc 'show', 'Show public key so you can copy to clipboard'
    def show
      system('eval "$(ssh-agent -s)"')
      ssh_keys = all_public_ssh_file
      if ssh_keys.nil?
        error_message('There is no ssh key to show. Exiting...')
      else
        get_user_input_number_and_then_show(ssh_keys)
      end
    end

    desc 'list', 'Check list ssh keys on machine'
    def list
      notice_message('Checking ssh keys in your machine...')
      ssh_keys = all_public_ssh_file
      display_ssh_keys(ssh_keys)
    end

    desc 'new', 'Generate new ssh key'
    method_option :email, required: true, aliases: '-e'
    def new
      system("ssh-keygen -t rsa -b 4096 -C #{options[:email]}")
    end

    desc 'switch', 'Switch to another ssh key'
    def switch
      system('eval "$(ssh-agent -s)"')
      ssh_keys = all_public_ssh_file
      if ssh_keys.nil?
        error_message('There is no ssh key to switch. Exiting...')
      else
        get_user_input_number_and_then_check_switch(ssh_keys)
      end
    end

    private

    def all_public_ssh_file
      if File.exist?(ssh_path)
        files = Dir.entries(ssh_path)
        files = files.select { |f| f.include?('.pub') && files.include?(f[0..-5]) }
        files
      else
        notice_message('You have no ssh key. To create new one, run this command:')
        puts Rainbow('$ gaman new -e your_email@domain.com').blue
        nil
      end
    end

    def get_user_input_number_and_then_check_switch(ssh_keys)
      notice_message('Current ssh keyson your system:')
      message = 'Which key do you want to switch? [Input number]'
      number = input_number(ssh_keys, message)
      if number_valid?(number, ssh_keys)
        perform_switch_ssh_key(number, ssh_keys)
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

    def perform_switch_ssh_key(number, ssh_keys)
      key = ssh_keys[number]
      key_path = "#{ssh_path}/#{key[0..-5]}"
      system('ssh-add -D')
      notice_message("Adding #{key_path}")
      system("ssh-add #{key_path}")
      current_user
    end

    def check_current_user_github
      notice_message('Checking ssh conection to github...')
      check_ssh_github = 'ssh -T git@github.com'
      system(check_ssh_github)
    end

    def check_current_user_bitbucket
      notice_message('Checking ssh conection to bitbucket...')
      check_ssh_github = 'ssh -T git@bitbucket.org'
      system(check_ssh_github)
    end

    def get_user_input_number_and_then_show(ssh_keys)
      notice_message('Current ssh keyson your system:')
      message = 'Which key do you want to show? [Input number]'
      number = input_number(ssh_keys, message)
      if number_valid?(number, ssh_keys)
        perform_show_ssh_key(number, ssh_keys)
      else
        error_message('Wrong value. Exiting...')
      end
    end

    def perform_show_ssh_key(number, ssh_keys)
      key = ssh_keys[number]
      key_path = "#{ssh_path}/#{key}"
      system("cat #{key_path}")
    end
  end
end
