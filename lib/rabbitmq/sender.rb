require 'rabbitmq/sender/version'
require 'rabbitmq/sender/config'
require 'rabbitmq/sender/sender'

require 'connection_pool'

module Rabbitmq
  class Sender
    def self.send_to(queue, msg, reply_queue = nil)
      Rabbitmq::Sender.config.connection ||= ConnectionPool::Wrapper.new(:size => Rabbitmq::Sender.config.pool, :timeout => Rabbitmq::Sender.config.timeout) { Rabbitmq::Sender.send(:new) }
      Rabbitmq::Sender.config.connection.send_to(queue, msg, reply_queue)
    end
  end
end
