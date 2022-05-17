module Bot

using HTTP
using URIs

function hi(sndr, args...)::String
   "Hello @$(sndr)"
end

function weather(sndr, args...)::String
   try
      loc = URIs.escapeuri(join(args, " "))
      resp = HTTP.get("https://wttr.in/$(loc)?format=4")
      return "@$(sndr) " * String(resp.body)      
   catch
      "Oops! Error fetching weather."
   end
end

# Add the mapping for the !cmd and function here.
botFnTbl = Dict(
   "!weather" => weather,
   "!hi"      => hi
)

end