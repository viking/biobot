require File.dirname(__FILE__) + "/../../helper"

class TestGreeting < Test::Unit::TestCase
  include Biobot::Commands::Greeting

  def test_handle_message
    %w{hello hi hey sup greetings}.each do |msg|
      incoming = mock_message('dude@localhost', msg)
      assert_equal 'Hello there!', handle_greeting(incoming)
    end

    incoming = mock_message('dude@localhost', 'unmatching')
    assert_equal false, handle_greeting(incoming)
  end
end
