require 'socket'

port = 3000
server = TCPServer.new('localhost', port)
STDERR.puts "Serving up application at port #{port}"

def serve_file(file_path)
  file = ""
  File.open(file_path, 'r') do |f|
    f.each_line do |line|
      file += "#{line}\r\n"
    end
  end
  return file
end

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

router = Router.new
router.route('/', 'index.html')

loop do
  socket = server.accept
  request = socket.gets
  method, route = request.split(' ')[0..1]

  STDERR.puts request

  response_file = router.get(route)
  response = serve_file(response_file)

  socket.print "HTTP/1.1 200 OK\r\n" +
               #"Content-Type: text/plain\r\n" +
               "Content-Type: text/html\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n"

  socket.print "\r\n"

  socket.print response

  socket.close
end