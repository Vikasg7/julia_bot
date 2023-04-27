module Msg

using ..Data
using ..Utils

rs = [
   r"(?<type>PING) (?<text>.+)",
   r"(?<type>NOTICE) \* :(?<text>.+?)\r\n",
   r"\!(?<sndr>.+)\@.+ (?<type>PRIVMSG) #(?<chnl>\w+) :(?<text>.+)"
]

function parse(raw::String)::Union{Data.Msg, Nothing}
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