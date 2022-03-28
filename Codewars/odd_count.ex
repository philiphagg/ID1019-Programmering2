defmodule OddCount do
  require Integer
  def num(n) do
  num = Enum.to_list(1..n-1)
  end


  def odd_count(n) do
    count_odd(Enum.to_list(1..n-1),0)
  end
  def count_odd([a|rest], count) do
    new_count = if rem(a,2) != 0, do: count+1, else: count
    count_odd(rest,new_count)
  end
  def count_odd(_,count) do count end

end
