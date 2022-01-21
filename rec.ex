defmodule Rec do
  @moduledoc false

  def prod(a,b) do
    if a == 0 or b == 0 do
      0
    else
      prod(a-1, b) + b
    end
  end

  def exp(x,n) do
    case n do
      1 -> x
      _ -> prod(x,exp(x,n-1))
    end
  end

  def expMul(x,n) do
    case n do
      1 -> x
      _ -> x * exp(x,n-1)
    end
  end

  def quickExp(x,n) do
    cond do
      n == 0 -> 1
      n == 1 -> x
      rem(n,2) == 0 ->
        first = exp(x,div(n,2))
        first * first
      rem(n,2) != 0 ->
        first = exp(x,div(n-1,2))
        first*first*x
    end
  end

  def quickExp2(x,n) do
    cond do
      n == 0 -> 1
      n == 1 -> x
      rem(n,2) == 0 ->
        first = exp(x,div(n,2))
        first * first
      rem(n,2) != 0 -> x * exp(x,n-1)
    end
  end

end
