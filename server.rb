require 'socket'
require_relative 'router'

port = 3000
server = TCPServer.new('localhost', port)
STDERR.puts "Serving up application at port #{port}"

def serve_file(file_path)
  file = ""
  f = File.open(file_path, 'r')
  f.each_line { |line| file += "#{line}\r\n" }
  f.close
  return file
end

router = Router.new
router.route('/', 'index.html')
router.route('/contact', 'contact.html')

loop do
  socket = server.accept
  request = socket.gets
  method, route = request.split(' ')[0..1]

  STDERR.puts request
  if (route == '/favicon.ico')
  else
    response_file_path = router.get(route)
    response = serve_file(response_file_path)

    socket.print "HTTP/1.1 200 OK\r\n" +
                 #"Content-Type: text/plain\r\n" +
                 "Content-Type: text/html\r\n" +
                 "Content-Length: #{response.bytesize}\r\n" +
                 "Connection: close\r\n"
    socket.print "\r\n"

    socket.print response
  end

  socket.close
end