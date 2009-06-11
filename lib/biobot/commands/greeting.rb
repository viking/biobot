module Biobot
  module Commands
    module Greeting
      def self.included(base)
        base.register_command(:handle_greeting)
      end

      def handle_greeting(message)
        case message.body.downcase
        when /^hello/, /^hey/, /^hi/, /^sup/, /^greetings/
          'Hello there!'
        else
          false
        end
      end
    end
  end
end
