module Config

using JSON3
using JSON3:StructTypes
using ..Data

StructTypes.StructType(::Type{Data.Config}) = StructTypes.Struct()

function read(fPath::String)::Data.Config
   open(fPath) do f
      content = Base.read(f, String)
      JSON3.read(content, Data.Config)
   end
end

end