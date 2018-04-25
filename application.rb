require 'json'
require_relative 'dependencies'
require_relative 'application_helpers'

class Application
  include ApplicationHelpers

  DB = Sequel.sqlite('rack_app.db')


  def call(env)
    request  = Rack::Request.new(env)
    response = Rack::Response.new
    response.headers["Content-Type"] = "application/json"
    none_match_etag = request.env["HTTP_IF_NONE_MATCH"]
    case request.env["REQUEST_PATH"]
    when "/"
      index_page(request, response)
    when '/users'
      search_from_db(request, response,none_match_etag)
    else
      missing(response)
    end

    response.finish
  end

  def get_all_users
    users = DB["select * from users"]
    hsh = {}
    users.to_a
  end

  def search_from_db(request, response,none_match_etag)
    query_string = Rack::Utils.parse_nested_query(request.env["QUERY_STRING"])
    query_string = query_string["name"]
    hsh = {}
    if query_string
      name_to_be_searched = query_string.split(" ")
      clause = name_to_be_searched.map{|x| "lower(name) like '%#{x}%'"}.join(" or ")
      users = DB["select * from users WHERE #{clause}"]
      hsh["user"] = users.to_a
    else
      hsh["user"] = get_all_users
    end
    respond_with_object(response, {user: hsh["user"]},none_match_etag)
  end

  def index_page(request, response)
    response.status = 404
    response.write("Welcome to rack app go to /users page to find users \nGo to /users?name=arvind to search user by name")
  end

end


