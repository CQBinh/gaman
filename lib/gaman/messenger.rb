module Gaman
  module Messenger
    def notice_message(message)
      puts Rainbow(message).green
    end

    def error_message(message)
      puts Rainbow(message).red
    end
  end
end
