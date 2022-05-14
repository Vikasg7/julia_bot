module Msg

# include("./data.jl")
# include("./utils.jl")

# PING :tmi.twitch.tv
# :tmi.twitch.tv NOTICE * :Improperly formatted auth
# :foo!foo@foo.tmi.twitch.tv PRIVMSG #bar :bleedPurple
function parse(raw::String)::Data.Msg
   rs = [
      r"(?<type>PING) (?<text>.+)",
      r"(?<type>NOTICE) \* :(?<text>.+)",
      r"\!(?<sndr>.+)\@.+ (?<type>PRIVMSG) #(?<chnl>\w+) :(?<text>.+)"
   ]
   m = Utils.some(rs) do r
      match(r, raw)
   end
   if m !== nothing 
      m[:type] == "PING"    ? Data.Ping(m[:text]) :
      m[:type] == "NOTICE"  ? Data.Notice(m[:text]) :
      m[:type] == "PRIVMSG" ? Data.PrivMsg(m[:sndr], m[:chnl], m[:text]) :
                              nothing
   end
end

end