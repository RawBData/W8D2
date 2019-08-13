require 'rack'
require_relative '../lib/controller_base'

class ControllerBase

  attr_accessor :req, :res

  def initialize(req, res)
    @req, @res = req, res
  end

  def render_content(content, content_type)
    @res['content_type'] = content_type
    @res.write(content)
    @already_built_response = true
  end

  def redirect_to(url)
    @res.headers['Location'] = url
    @res.status = '302'
  end
end

class MyController < ControllerBase
  def go
    if req.path == "/cats"
      render_content("hello cats!", "text/html")
    else
      redirect_to("/cats")
    end
  end

end


app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  MyController.new(req, res).go
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)

