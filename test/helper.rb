require 'test/unit'
require 'rubygems'
require 'mocha'
require 'ruby-debug'
require 'activerecord'
require File.dirname(__FILE__) + '/../lib/biobot'

module TestHelpers
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def register_command(*args); end
    def register_periodical(*args); end
  end

  def mock_message(from, body)
    stub('jabber message', :from => from, :body => body)
  end

  def clear_commands
    Biobot::Base.send(:class_variable_get, '@@command_chain').clear
  end

  def clear_periodicals
    Biobot::Base.send(:class_variable_get, '@@periodicals').clear
  end
end

Test::Unit::TestCase.send(:include, TestHelpers)
