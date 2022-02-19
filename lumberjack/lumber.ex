defmodule Lumber do
  def bench(n) do
    for i <- 1..n do
      {t,_} = :timer.tc(fn() -> cost(Enum.to_list(1..i)) end)
      IO.puts(" n = #{i}\t t = #{t} us")
    end
  end

  def split(seq) do
    split(seq, Enum.sum(seq),[] ,[])
  end

  def split([], l , left, right) do
    [{left,right,l}]
  end
  def split([s|rest], l, left, right) do
    split(rest, l , [s] ++ left, right) ++ split(rest, l, left, [s] ++ right)
  end



  def cost([])do [] end
  def cost([_]) do 0 end
  def cost(seq) do
    cost(seq, 0, [], [])
  end

  def cost([],l,left,right)do
    l + cost(left) + cost(right)
  end
  def cost([s],l,[],right) do
    s + l + cost(right)
  end
  def cost([s],l,left,[]) do
    s + l + cost(left)
  end
  def cost([s|rest], l, left, right) do
    a = cost(rest, l+s, [s|left], right)
    b = cost(rest, l+s, left, [s|right])
    if a<b do
      a
    else
      b
    end
  end
end
