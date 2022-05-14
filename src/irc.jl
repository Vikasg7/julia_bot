module Irc

using Sockets
using Sockets:TCPSocket

# include("./data.jl")
# include("./msg.jl")
# include("./utils.jl")

function connect(sock::TCPSocket, host::String, port::Integer)
   Sockets.connect!(sock, host, port)
   # Waiting for the connection is open and avoid 
   # Base.IOError("write: broken pipe (EPIPE)", -4047)
   while sock.status != Base.StatusOpen 
      sleep(0.1)
   end
end

function auth(sock::TCPSocket, tokn::String, user::String)
   sendline(sock, "PASS " * tokn)
   sendline(sock, "NICK " * user)
   message = sock |> readline |> Msg.parse
   if message isa Data.Notice
      error("AUTH: " * message.text)
   end
end

function join(sock::TCPSocket, chnl::String)
   sendline(sock, "JOIN #" * chnl)
   message = sock |> readline |> Msg.parse
   if message isa Data.Notice
      error("JOIN: " * message.text)
   end
end

function sendline(sock::TCPSocket, buffer::String)
   write(sock, buffer * "\r\n")
end

function msgs(sock)
   Iterators.filter(!isnothing, Iterators.map(Msg.parse, eachline(sock)))   
   # eachline(sock) |>
   # Utils.partial(Iterators.map, Msg.parse) |>
   # Utils.partial(Iterators.filter, !isnothing)
end

function send(sock::TCPSocket, reply::Data.Pong)
   sendline(sock, "PONG " * reply.text)
end

function send(sock::TCPSocket, reply::Data.PrivMsg)
   sendline(sock, "PRIVMSG #" * reply.chnl * " :" * reply.text)
end

function send(sock::TCPSocket, reply::Nothing)
   nothing
end

end