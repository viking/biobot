module Biobot
  class Base
    @@command_chain = []
    def self.register_command(method)
      @@command_chain << method
    end

    @@periodicals = []
    def self.register_periodical(method, delay)
      @@periodicals << [method, delay]
    end

    def initialize(config)
      @username, @password, @server = config['xmpp'].values_at('username', 'password', 'server')
      @jid = @username + "@" + @server

      # setup active record if database is specified
      if config['database']
        ActiveRecord::Base.establish_connection(config['database'])
      end

      @client = Jabber::Client.new(@jid)
      @presence = Jabber::Presence.new

      @client.add_message_callback do |message|
        process(message) if message.body
      end

      @threads = []
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

      @@periodicals.each do |(method, delay)|
        thread = Thread.new { loop { self.send(method); sleep(delay) } }
        @threads << thread
      end
    end

    def stop
      @threads.each { |t| t.exit }
      @threads.clear
      @client.close!
    end
  end
end
