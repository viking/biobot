require 'rubygems'
require 'rubygems'
require 'xmpp4r'

class Biobot
  def initialize(config)
    @username, @password, @server = config['xmpp'].values_at('username', 'password', 'server')
    @jid = @username + "@" + @server

    @client = Jabber::Client.new(@jid)
    @presence = Jabber::Presence.new
    @client.connect(@server)
    @client.auth(@password)
    @client.send(@presence)
    @client.add_message_callback { |message| process(message) }
  end

  def process(message)
  end
end
