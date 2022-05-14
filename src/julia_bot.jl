module julia_bot

using Sockets:TCPSocket

include("./utils.jl")
include("./data.jl")
include("./msg.jl")
include("./irc.jl")
include("./config.jl")
include("./bot.jl")

function reply(user::String, msg::Data.Ping)::Data.Reply
   Data.Reply(msg.text)
end

function reply(user::String, msg::Data.PrivMsg)::Data.Reply
   self = msg.sndr == user
   if self return end
   cmd, args... = lowercase.(split(msg.text, " "))
   if cmd == "!weather"
      text = Bot.weather(self, msg.sndr, args...)
      return Data.PrivMsg(user, msg.chnl, text)
   end
   if cmd == "!hi"
      return Data.PrivMsg(user, msg.chnl, "Hello")
   end
end

function reply(user::String, msg::Nothing)::Data.Reply
   nothing
end

function main()
   cfg = Config.read("./config.json")
   sock = TCPSocket()
   try
      Irc.connect(sock, cfg.host, cfg.port)
      Irc.auth(sock, cfg.tokn, cfg.user)
      Irc.join(sock, cfg.chnl)
      println("julia_bot is connected!")
      for msg in Irc.msgs(sock)
         println(msg)
         Irc.send(sock, reply(cfg.user, msg))
      end
   finally
      close(sock)
   end
end

end