module Irc

using Sockets
using Sockets: TCPSocket
using ..Data
using ..Msg
using ..Utils
using ..Bot

function connect(sock::TCPSocket, host::String, port::Integer)
   Sockets.connect!(sock, host, port)
   # Waiting for the connection is open and avoid 
   # Base.IOError("write: broken pipe (EPIPE)", -4047)
   while sock.status != Base.StatusOpen
      sleep(0.1)
   end
end

function auth(sock::TCPSocket, tokn::String, user::String)
   sendline(sock, "PASS $(tokn)")
   sendline(sock, "NICK $(user)")
   message = readavailable(sock) |> String |> Msg.parse
   message isa Data.Notice &&
      error("AUTH: $(message.text)")
end

function join(sock::TCPSocket, chnl::String)
   sendline(sock, "JOIN #$(chnl)")
   message = Utils.timeout(1.0) do
      readavailable(sock) |> String |> Msg.parse
   end
   message == :timeout &&
      error("JOIN: channel $(chnl) doesn't exist.")
   message isa Data.Notice &&
      error("JOIN: $(message.text)")
end

function sendline(sock::TCPSocket, buffer::String)
   write(sock, "$(buffer)\r\n")
end

function msgs(sock)::Channel{Data.Msg}
   Channel{Data.Msg}(1000) do ch
      for line in eachline(sock)
         msg = Msg.parse(line)
         msg === nothing && continue
         put!(ch, msg)         
      end
   end
end

function send(sock::TCPSocket, reply::Data.Pong)
   sendline(sock, "PONG $(reply.text)")
end

function send(sock::TCPSocket, reply::Data.PrivMsg)
   sendline(sock, "PRIVMSG #$(reply.chnl) :$(reply.text)")
end

function send(sock::TCPSocket, reply::Nothing)
   return nothing
end

function reply(user::String, msg::Data.Ping)::Data.Reply
   Data.Pong(msg.text)
end

function reply(user::String, msg::Data.PrivMsg)::Union{Data.Reply, Nothing}
   if msg.sndr == user return end
   cmd, args... = split(lowercase(msg.text), " ")
   botFn = get(Bot.botFnTbl, cmd, nothing)
   if botFn !== nothing
      text = botFn(msg.chnl, msg.sndr, args...)
      return Data.PrivMsg(user, msg.chnl, text)
   end
end

function reply(user::String, msg::Nothing)::Nothing
   return nothing
end

end