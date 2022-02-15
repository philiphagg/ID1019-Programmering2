defmodule Prime3 do
  #c("prime3.ex") && Prime3.prime(100)
  def prime(n) do
    Enum.reverse(prime(Enum.to_list(2..n), []))
  end
  def prime([], p) do p end
  def prime([h|t], p) do
    #IO.inspect([h|t])
    IO.inspect([p])
    if Enum.filter(p, fn mums -> rem(h, mums) == 0 end) == [] do
      prime(t,[h|p])
    else
      prime(t,p)
    end
  end

end
