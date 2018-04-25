require_relative 'application.rb'
# require_relative 'database.rb'
use Rack::Auth::Basic, "Authentication" do |username, password|
  [username, password] == ['admin', 'admin']
end

map("/") do
  run Application.new
end
# Rack::Server.start :app => Application