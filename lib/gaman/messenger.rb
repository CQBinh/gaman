module Gaman
  module Messenger
    def notice_message(message)
      puts Rainbow(message).green
    end

    def error_message(message)
      puts Rainbow(message).red
    end

    def display_ssh_keys(ssh_keys)
      if ssh_keys.nil?
        notice_message('You have no ssh key.')
      else
        ssh_keys.each_with_index do |key, index|
          puts "[#{Rainbow(index).underline.bright.cyan}] - #{key}"
        end
      end
    end
  end
end
