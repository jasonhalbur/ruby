require 'sinatra'
require 'bunny'

post '/emit' do
  conn = Bunny.new
  conn.start

  channel = conn.create_channel
  exchange = channel.fanout("logs")

  message = request.body.read

  exchange.publish(message)
  response.body = " [x] Sent: " + message

  conn.close
end

get '/hello/:name' do |n|
  # matches "GET /hello/foo" and "GET /hello/bar"
  # params['name'] is 'foo' or 'bar'
  # n stores params['name']
  "Hello #{n}!"
end

