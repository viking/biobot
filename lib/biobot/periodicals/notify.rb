module Biobot
  module Periodicals
    module Notify
      class Notification < ActiveRecord::Base
        set_table_name 'notifications'
      end

      def self.included(base)
        base.register_periodical(:handle_notifications, 60)
      end

      def handle_notifications
        if Notification.count > 0
          Notification.all.each do |notification|
            to   = notification.to
            body = notification.body
            message = Jabber::Message.new(
              to =~ /@/ ? to : "#{to}@#{@server}",
              body
            )
            @client.send(message)
          end
          Notification.delete_all
        end
      end
    end
  end
end
