class Router

  def initialize
    @routes = {}
  end

  def route(route, response)
    @routes[route] = response
  end

  def get(route)
    return @routes[route]
  end
end