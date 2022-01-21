defmodule List6 do

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
  def duplicate([]) do [] end
  def duplicate([head | tail]) do
    [head, head | duplicate(tail)]
  end
  def add(x,l) do
    cond do
      len(l) == len(l -- [x]) -> [x|l]
      true ->
      l
    end
  end
  def remove(x,l) do
    list = l
    cond do
      len(list) == len(list--[x]) -> list
      true ->
      remove(x,list--[x])
    end
  end


end