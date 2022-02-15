#Recurssion

defmodule Intro3 do
  def prod(a,b) do
    if a == 0 or b == 0 do
      0
    else
      prod(a-1, b) + b
    end
  end

  def fib(n) do
    if n == 0 do
      0
    else
      if n == 1 do
        1
      else
        fib(n-1) + fib(n-2)
      end
    end
  end

  def fibo(n) do
    case n do
      0 -> 0
      1 -> 0
      _ -> fib(n-1) + fib(n-2)
    end
  end

end
