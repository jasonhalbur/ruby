require 'sinatra'
require 'bunny'

post '/emit' do
  conn = Bunny.new
  conn.start

  channel = conn.create_channel
  exchange = channel.fanout("logs")

  exchange.publish(request.body.read)
  response.body = " [x] Sent " + request.body.read.to_s

  conn.close
end

get '/hello/:name' do |n|
  # matches "GET /hello/foo" and "GET /hello/bar"
  # params['name'] is 'foo' or 'bar'
  # n stores params['name']
  "Hello #{n}!"
end
