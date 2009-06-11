require File.dirname(__FILE__) + "/../../helper"

class TestNotify < Test::Unit::TestCase
  include Biobot::Periodicals::Notify

  def setup
    @model = Biobot::Periodicals::Notify::Notification
    @model.stubs(:inspect).returns('Notification')
    @client = stub('Jabber::Client')
    @server = 'localhost'
  end

  def test_handling_notifications
    notification_1 = mock("notification", :to => 'foo@localhost', :body => 'huge')
    notification_2 = mock("notification", :to => 'bar', :body => 'small')
    @model.expects(:count).returns(2)
    @model.expects(:all).returns([notification_1, notification_2])
    outgoing_1 = mock_message('biobot@localhost', 'huge')
    outgoing_2 = mock_message('biobot@localhost', 'small')
    Jabber::Message.expects(:new).with('foo@localhost', 'huge').returns(outgoing_1)
    Jabber::Message.expects(:new).with('bar@localhost', 'small').returns(outgoing_2)
    @client.expects(:send).with(outgoing_1)
    @client.expects(:send).with(outgoing_2)
    @model.expects(:delete_all)

    handle_notifications
  end
end
