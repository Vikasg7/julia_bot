module Msg

using ..Data
using ..Utils

function parse(raw::String)::Data.Msg
   rs = [
      r"(?<type>PING) (?<text>.+)",
      r"(?<type>NOTICE) \* :(?<text>.+?)\r\n",
      r"\!(?<sndr>.+)\@.+ (?<type>PRIVMSG) #(?<chnl>\w+) :(?<text>.+)"
   ]
   m = Utils.some(rs) do r
      match(r, raw)
   end
   if m !== nothing
      m[:type] == "PING" ? Data.Ping(m[:text]) :
      m[:type] == "NOTICE" ? Data.Notice(m[:text]) :
      m[:type] == "PRIVMSG" ? Data.PrivMsg(m[:sndr], m[:chnl], m[:text]) :
      nothing
   end
end

end