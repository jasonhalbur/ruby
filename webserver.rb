require 'sinatra'
require 'bunny'
require 'json'

before do
  @conn = Bunny.new
  @conn.start
  channel = @conn.create_channel
  @exchange = channel.topic('/', :durable => true)
end

after do
  @conn.close
end

post '/event' do
  message = request.body.read
  parsed_message = JSON.parse(message)
  sensor_type = parsed_message['sensor_type']

  puts ' [x] Received a message from ' + sensor_type + ': ' + message

  parsed_message.each do |data_name, value|
    next if data_name == 'sensor_type'
    @exchange.publish(value, :headers => {'type' => 'event'}, :routing_key => 'event.DHT11.' + data_name)
  end

  status 201
end








