require 'erubis'
require 'rack'

class CardServer::Application

  ALLOWED_METHODS = %w( OPTIONS GET HEAD POST PUT DELETE TRACE COPY MOVE MKCOL
                        PROPFIND PROPPATCH LOCK UNLOCK REPORT ACL )

  DAV_PROPERTIES = %w( 1 2 3 access-control addressbook extended-mkcol )

  attr_reader :request, :response

  def call(env)
    @request  = Rack::Request.new(env)
    @response = Rack::Response.new

    reset_locals!

    if ALLOWED_METHODS.include?(request.request_method)
      send request.request_method
    end

    response.finish
  end

## methods ###################################################################

  def OPTIONS
    response.header['Allow'] = ALLOWED_METHODS.join(', ')
    response.header['DAV']   = DAV_PROPERTIES.join(', ')
  end

  def PROPFIND
    locals[:depth] = '0'
    locals[:path] = request.path_info
    template 'PROPFIND.xml'
  end

## template ##################################################################

  def reset_locals!
    @locals = {}
  end

  def locals
    @locals ||= {}
  end

  def template(name)
    template = File.read(File.join(File.dirname(__FILE__), 'templates', "#{name}.erb"))
    response.write Erubis::Eruby.new(template).result(binding)
  end

end
