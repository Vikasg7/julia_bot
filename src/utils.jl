module Utils

function some(pred::Function, A::AbstractArray)
   for a in A
      v = pred(a)
      if v !== nothing 
         return v
      end
   end
end

partial(f, xs...) = (ys...) -> f(xs..., ys...)

end
