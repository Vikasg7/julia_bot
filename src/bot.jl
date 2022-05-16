module Bot

using HTTP
using URIs

function hi(self, sndr, args...)::String
   "Hello @$(sndr)"
end

function weather(self, sndr, args...)::String
   try
      loc = URIs.escapeuri(join(args, " "))
      resp = HTTP.get("https://wttr.in/$(loc)?format=4")
      return "@$(sndr) " * String(resp.body)      
   catch
      "Oops! Error fetching weather."
   end
end

fnTbl = Dict(
   "!weather" => weather,
   "!hi"      => hi
)

end