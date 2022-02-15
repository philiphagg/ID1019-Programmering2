defmodule Prime1 do
  #c("prime1.ex") && Prime.task1(100)
  def prime(n) do
    [h|t] = Enum.to_list(2..n)
    [h|prime(h,t)]
  end

  def prime(x,[]) do []  end
  def prime(x,[h|t]) do
    IO.inspect([h|t])
      [h|prime(h,Enum.filter(t, fn mums -> rem(mums,x) != 0 end))]
  end

end