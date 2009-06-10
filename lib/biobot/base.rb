module Biobot
  class Base
    @@command_chain = []
    def self.register_command(method)
      @@command_chain << method
    end

    def initialize(config)
      @username, @password, @server = config['xmpp'].values_at('username', 'password', 'server')
      @jid = @username + "@" + @server

      @client = Jabber::Client.new(@jid)
      @presence = Jabber::Presence.new
      @client.connect(@server)
      @client.auth(@password)
      @client.send(@presence)

      @client.add_message_callback do |message|
        process(message) if message.body
      end
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
  end
end
