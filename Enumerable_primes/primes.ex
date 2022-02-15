defmodule Primes do

  defstruct [:next]

  defimpl Enumerable do
    def count(_) do {:error, __MODULE__} end
    def member?(_,_) do {:error, __MODULE__} end
    def slice(_) do {:error, __MODULE__} end

    def reduce(_, {:halt, acc}, _) do
      {:halted, acc}
    end
    def reduce(primes, {:suspend, acc}, fun) do
      {:suspended, acc, fn(cmd) -> reduce(primes, cmd, fun) end}
    end

    def reduce(primes, {:cont, acc}, fun) do
      {p, next} = Primes.next(primes)
      reduce(next, fun.(p,acc), fun)
    end
  end

  def z(n) do
    fn() -> {n, z(n+1)} end
  end


  def filter(fun, divisor) do
    { n, fun } = fun.()
    if rem(n,divisor) == 0,
       do: filter(fun,divisor),
       else: { n, fn -> filter(fun, divisor) end }
  end


  def sieve(fun, p) do
    {n, inner} = filter(fun, p)
    {n, fn() -> sieve(inner, n) end}
  end

  def next(%Primes{next: fun}) do
    {next, nextFun} = fun.()
    {next, %Primes{next: nextFun}}
  end

  def primes() do
    %Primes{next: fn() -> {2, fn() -> sieve(z(3), 2) end} end}
  end

  def primesOld() do
    fn() -> {2, fn() -> sieve(z(3), 2) end} end
  end
end