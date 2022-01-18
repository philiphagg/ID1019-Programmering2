defmodule List2 do
  def nth(n, l) do
    [head | tail] = l
    case n do
      1 -> head
      _ -> nth(n - 1, tail)
    end
  end
  def len(l) do
    cond do
      l == [] -> 0
      true ->
        [head | tail] = l
        len(tail) + 1
    end
  end

  def sum([])do
    0
  end
  def sum([head|tail]) do
        sum(tail) + head
  end


end