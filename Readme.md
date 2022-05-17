# Julia Bot
A basic twitch bot in Julia Programming Language.  

## How to use
* Add your bot function in the `src/Bot.jl` like below:-  
``` julia
   function mybot(sndr, args...)
      # process the args for the reply
      "$(sndr) Reply from mybot"
   end
```
* Add entry to the `botFnTbl` in the `src/Bot.jl`
``` julia
   botFnTbl = Dict(
      "!weather" => weather,
      "!hi"      => hi,
      "!mybot"   => mybot
   )
```
