module julia_bot

using Sockets:TCPSocket

include("./utils.jl")
include("./data.jl")
include("./msg.jl")
include("./bot.jl")
include("./irc.jl")
include("./config.jl")

function main()
   cfg = Config.read("./config.json")
   sock = TCPSocket()
   try
      Irc.connect(sock, cfg.host, cfg.port)
      Irc.auth(sock, cfg.tokn, cfg.user)
      Irc.join(sock, cfg.chnl)
      println("julia_bot is connected!")
      Threads.foreach(Irc.msgs(sock)) do msg
         Irc.send(sock, Irc.reply(cfg.user, msg))
      end
   catch ex
      showerror(stderr, ex, catch_backtrace())
   finally
      close(sock)
   end
end

end

if abspath(PROGRAM_FILE) == @__FILE__
   julia_bot.main()
end