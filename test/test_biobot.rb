require File.dirname(__FILE__) + "/helper"

class TestBiobot < Test::Unit::TestCase
  def setup
    @client = stub('jabber client', {
      :connect => @client, :auth => nil, :send => nil,
      :add_message_callback => nil
    })
    Jabber::Client.stubs(:new).returns(@client)

    @presence = stub('jabber presence')
    Jabber::Presence.stubs(:new).returns(@presence)

    @config = YAML.load(<<-EOF)
      xmpp:
        server: localhost
        username: biobot
        password: secret
    EOF
  end

  def test_creates_client
    Jabber::Client.expects(:new).with('biobot@localhost').returns(@client)
    Biobot.new(@config)
  end

  def test_connects_and_authenticates
    @client.expects(:connect).with('localhost').returns(@client)
    @client.expects(:auth).with('secret')
    Biobot.new(@config)
  end

  def test_sends_presence
    Jabber::Presence.expects(:new).returns(@presence)
    @client.expects(:send).with(@presence)
    Biobot.new(@config)
  end

  def test_registers_callback
    @client.expects(:add_message_callback)
    Biobot.new(@config)
  end
end
