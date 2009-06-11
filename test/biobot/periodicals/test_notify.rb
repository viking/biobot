require File.dirname(__FILE__) + "/../../helper"

class TestNotify < Test::Unit::TestCase
  include Biobot::Periodicals::Notify

  def setup
    @model = Biobot::Periodicals::Notify::Notification
    @model.stubs(:inspect).returns('Notification')
    @client = stub('Jabber::Client')
  end

  def test_handling_notifications
    notification = mock("notification", :to => 'foo@localhost', :body => 'huge')
    @model.expects(:count).returns(1)
    @model.expects(:all).returns([notification])
    outgoing = mock_message('biobot@localhost', 'huge')
    Jabber::Message.expects(:new).with('foo@localhost', 'huge').returns(outgoing)
    @client.expects(:send).with(outgoing)
    @model.expects(:delete_all)

    handle_notifications
  end
end
