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

struct TaskTimeoutException <: Exception end

function timeout(fn::Function, seconds::Real)
   t = @async fn()
   Timer(seconds) do timer
      istaskdone(t) || Base.throwto(t, TaskTimeoutException())
   end
   try
      fetch(t)
   catch e
      if e        isa TaskFailedException &&
         t.result isa TaskTimeoutException
         return :timeout
      end
      rethrow()
   end
end

end
