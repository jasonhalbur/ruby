require 'sinatra'
require 'bunny'

get '/emit/:phrase' do |path_params|
  conn = Bunny.new
  conn.start

  channel = conn.create_channel
  exchange = channel.fanout("logs")

  exchange.publish(path_params)
  puts " [x] Sent #{path_params}"

  conn.close
end

get '/hello/:name' do |n|
  # matches "GET /hello/foo" and "GET /hello/bar"
  # params['name'] is 'foo' or 'bar'
  # n stores params['name']
  "Hello #{n}!"
end
