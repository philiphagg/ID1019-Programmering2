defmodule Prime2 do
  #c("prime2.ex") && Prime2.prime(100)
  def prime(n) do
    prime(Enum.to_list(2..n), [])
  end
  def prime([], p) do p end
  def prime([h | t], p) do
    if Enum.filter(p, fn mums -> rem(h, mums) == 0 end) == [] do
      prime(t, p ++ [h])
    else
      prime(t,p)
    end
  end
end
