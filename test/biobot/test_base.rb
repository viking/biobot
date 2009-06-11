require File.dirname(__FILE__) + "/../helper"

class TestBase < Test::Unit::TestCase
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
    Biobot::Base.new(@config)
  end

  def test_connects_and_authenticates_on_start
    @client.expects(:connect).with('localhost').returns(@client)
    @client.expects(:auth).with('secret')
    Biobot::Base.new(@config).start
  end

  def test_sends_presence_on_start
    Jabber::Presence.expects(:new).returns(@presence)
    @client.expects(:send).with(@presence)
    Biobot::Base.new(@config).start
  end

  def test_registers_callback_on_start
    @client.expects(:add_message_callback)
    Biobot::Base.new(@config).start
  end

  def test_message_processing_chain
    clear_commands
    Biobot::Base.register_command(:leetsaurus)
    Biobot::Base.register_command(:leetceritops)
    biobot = Biobot::Base.new(@config)
    incoming = mock_message('dude@localhost', 'leetsaurus')
    outgoing = mock_message('biobot@localhost', 'foo')
    biobot.expects(:leetsaurus).with(incoming).returns('foo')
    biobot.expects(:leetceritops).never
    Jabber::Message.expects(:new).with('dude@localhost', 'foo').returns(outgoing)
    @client.expects(:send).with(outgoing)
    biobot.process(incoming)
    clear_commands
  end

  def test_default_message
    clear_commands
    biobot = Biobot::Base.new(@config)
    incoming = mock_message('dude@localhost', 'leetsaurus')
    outgoing = mock_message('biobot@localhost', 'Huh?')
    Jabber::Message.expects(:new).with('dude@localhost', "Huh?").returns(outgoing)
    @client.expects(:send).with(outgoing)
    biobot.process(incoming)
    clear_commands
  end

  # can't unstub
#  def test_ignore_composing
#    biobot = Biobot::Base.new(@config)
#    incoming = mock_message('dude@localhost', nil)
#    biobot.expects(:send).never
#    biobot.process(incoming)
#  end

  def test_timers_for_periodicals_on_start
    clear_periodicals
    Biobot::Base.register_periodical(:leetsaurus, 0.3)
    Thread.expects(:new).once
    Biobot::Base.new(@config).start
  end

  def test_active_record_usage
    @config['database'] = {
      "adapter" => "sqlite3",
      "database" => "foo.sqlite3"
    }
    assert ActiveRecord::Base
    ActiveRecord::Base.expects(:establish_connection).with(@config['database'])
    Biobot::Base.new(@config)
  end

  def test_stop
    @client.expects(:close!)
    biobot = Biobot::Base.new(@config)
    biobot.stop
  end
end
