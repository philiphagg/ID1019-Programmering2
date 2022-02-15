defmodule Bench do
  #c("bench.ex") && Bench.bench(10_000)
  def bench(n) do
  {uSecs1, _} = :timer.tc(fn -> Prime1.prime(n) end)
  {uSecs2, _} = :timer.tc(fn -> Prime2.prime(n) end)
  {uSecs3, _} = :timer.tc(fn -> Prime3.prime(n) end)
  {uSecs1,uSecs2,uSecs3}
  end

  def bench_reverse(n) do
    {uSecs1, _} = :timer.tc(fn -> Enum.reverse(Enum.to_list(2..n)) end)

  end
end