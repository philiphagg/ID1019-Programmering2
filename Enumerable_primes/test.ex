defmodule Primes do

  def z(n) do
    fn() -> { n, z(n+1) } end
  end

  def filter(fun, f) do
    { n, fun } = fun.()
    if rem(n,f) == 0,
      do: filter(fun,f),
      else: { n, fn -> filter(fun, f) end }
  end

  def sieve(n, p) do
    {n,fun} = n.()
    {hej,nextPrime} = filter(fun,p)
      if rem(n, hej) == 0,
        do: sieve(fun, hej),
        else: {hej, fn -> sieve(fun, p) end}


  end

  def primes() do
    fn() -> {2, fn() -> end} end
  end
end
