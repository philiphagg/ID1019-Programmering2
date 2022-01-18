defmodule Test do
  def double(n) do
    n*2
  end
  def convert(n) do
    ((n-32)/1.8)
  end
  def rectangle(m,n) do
    m*n
  end
  def square(n) do
    rectangle(n,n)
  end
  def circle(r) do
   :math.pi() * :math.pow(r,2)
  end
end
