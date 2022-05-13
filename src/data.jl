module Data

struct Config
   host::String
   port::Int16
   user::String
   prfx::String
   chnl::String
   tokn::String
end

struct Ping 
   text::String
end

struct Notice
   text::String
end

struct PrivMsg
   sndr::String
   chnl::String
   text::String
end

struct Pong
   text::String
end

const Msg = Union{Ping, Notice, PrivMsg, Nothing}

const Reply = Union{Pong, PrivMsg, Nothing}

end