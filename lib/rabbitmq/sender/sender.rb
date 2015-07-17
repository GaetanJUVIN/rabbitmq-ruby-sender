require 'bunny'

module Rabbitmq
	class Sender
		def initialize
		  @state = :not_connected
		end

		def server_info
		  "#{Rabbitmq::Sender.config.host}:#{Rabbitmq::Sender.config.port}"
		end

		def _connect
		  @state          = :not_connected

		  options = {host: Rabbitmq::Sender.config.host, port: Rabbitmq::Sender.config.port}
		  options = options.merge(user: Rabbitmq::Sender.config.user) if Rabbitmq::Sender.config.user
		  options = options.merge(password: Rabbitmq::Sender.config.password) if Rabbitmq::Sender.config.password
		  options = options.merge(vhost: Rabbitmq::Sender.config.vhost) if Rabbitmq::Sender.config.vhost
		  begin
		    @rmq_connection = Bunny.new(options)
		    @rmq_connection.start

		    @rmq_channel       = @rmq_connection.create_channel
		    @rmq_channel.prefetch(Rabbitmq::Sender.config.prefetch)
		    @state             = :connected
		    Rabbitmq::Sender.config.logger.info "------- Rabbit::Sender on #{self.server_info} connected.".white if Rabbitmq::Sender.config.verbose
		  rescue Exception => e
		    Rabbitmq::Sender.config.logger.error e if Rabbitmq::Sender.config.verbose
		    Rabbitmq::Sender.config.logger.error "------- Rabbit::Sender on #{self.server_info} can't connect.".red if Rabbitmq::Sender.config.verbose
		    @state = :not_connected
		    exit(1)
		  end
		end

		def connection
		  self._do_connection
		  if @state == :connected
		    return @rmq_connection
		  end
		  nil
		end

		def state= _state
		  @state = _state
		end

		def _disconnect
		  @rmq_channel.close if @rmq_channel
		  @rmq_connection.close if @rmq_connection
		  Rabbitmq::Sender.config.logger.info "------- Rabbit::Sender on #{self.server_info} disconnected.".white if Rabbitmq::Sender.config.verbose
		end

		def _do_connection
		  if @state != :connected
		    tries = Rabbitmq::Sender.config.retry_time
		    begin
		      self._connect
		    rescue Exception => e
		      Rabbitmq::Sender.config.logger.error "------- Rabbit::Sender on #{self.server_info} retrying... (##{Rabbitmq::Sender.config.retry_time - tries})".white if Rabbitmq::Sender.config.verbose
		      if (tries -= 1).zero? == false
		        sleep 1
		        retry
		      else
		        raise
		      end
		    end
		  end
		end

		def send_to(queue, msg, reply_queue = nil)
		  self._do_connection
		  if @state == :connected
		    @rmq_queue = @rmq_channel.queue(queue, :durable => true, :exlusive => false)
		    @rmq_channel.default_exchange.publish(msg, :routing_key => @rmq_queue.name, :reply_to => reply_queue)
		  end
		end
	end
end
