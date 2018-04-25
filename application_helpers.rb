module ApplicationHelpers
  def respond_with_object(response, object,none_match_etag=nil)
    etag = Digest::MD5.hexdigest(object[:user].to_s)
    response.headers["Etag"] = etag
    response.headers["Cache-Control"] = "max-age=0, private, must-revalidate"
    if none_match_etag && none_match_etag == etag
      cache_response(response)
    else
      response.write(object)
    end
  end

  def error(response, message, status = 400)
    response.status = status
    response.write("ERROR: #{message}")
  end

  def missing(response)
    response.status = 404
    response.write("Nothing Here!")
  end

  def cache_response(response)
    response.status = 304
  end
end
