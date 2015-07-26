#encoding: utf-8

##
## config.rb
## Gaetan JUVIN 08/07/2015
##

require 'gconfig'

module Rabbitmq
	class Sender
		extend GConfig
		default logger:     Logger.new(STDOUT)
		default connection: nil
		default host:       '8.8.8.8'
		default port:       5672
		default pool:       20
		default timeout:    5
		default user:       nil
		default password:   nil
		default vhost:      nil
		default prefetch:   10
		default verbose:    false
		default retry_time: 5
	end
end
