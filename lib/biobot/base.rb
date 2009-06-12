module Biobot
  class Base
    @@command_chain = []
    def self.register_command(method)
      @@command_chain << method
    end

    @@periodicals = []
    def self.register_periodical(method, delay)
      @@periodicals << {
        :method => method,
        :delay  => delay,
        :last_run => nil
      }
    end

    def initialize(config)
      @username, @password, @server = config['xmpp'].values_at('username', 'password', 'server')
      @jid = @username + "@" + @server

      # setup active record if database is specified
      if config['database']
        ActiveRecord::Base.establish_connection(config['database'])
      end

      @log = config['logfile'] ? Logger.new(config['logfile']) : nil

      @client = Jabber::Client.new(@jid)
      @presence = Jabber::Presence.new

      @message_buffer = []
    end

    def process(message)
      result = nil
      @@command_chain.each do |method|
        result = send(method, message)
        break if result
      end
      result ||= "Huh?"
      message  = Jabber::Message.new(message.from, result)
      @client.send(message)
    end

    def start
      @client.connect(@server)
      @client.auth(@password)
      @client.send(@presence)

      @client.add_message_callback do |message|
        @message_buffer << message  if message.body
      end
      main_loop
    end

    def main_loop
      @main = Thread.new do
        loop do
          while !@message_buffer.empty?
            process(@message_buffer.shift)
          end
          @@periodicals.size.times do |i|
            last_run = @@periodicals[i][:last_run]
            if last_run.nil? || (Time.now - last_run) >= @@periodicals[i][:delay]
              @log.info "Running #{@@periodicals[i][:method]}"      if @log

              self.send(@@periodicals[i][:method])
              @@periodicals[i][:last_run] = Time.now

              @log.info "Done running #{@@periodicals[i][:method]}" if @log
            end
          end
          sleep 1
        end
      end
    end

    def join
      @main.join
    end

    def stop
      @client.close!
      @main.kill
    end
  end
end
