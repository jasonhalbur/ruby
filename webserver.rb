require 'sinatra'
require 'bunny'

before do
  @conn = Bunny.new
  @conn.start
end

after do
  @conn.close
end

post '/emit' do
  channel = @conn.create_channel
  exchange = channel.fanout("logs")

  message = request.body.read

  exchange.publish(message)
  response.body = " [x] Sent: " + message

end

get '/hello/:name' do |n|
  # matches "GET /hello/foo" and "GET /hello/bar"
  # params['name'] is 'foo' or 'bar'
  # n stores params['name']
  "Hello #{n}!"
end






