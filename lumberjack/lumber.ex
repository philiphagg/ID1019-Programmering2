defmodule Lumber do
  def bench(n) do
    for i <- 1..n do
      {t,_} = :timer.tc(fn() -> cost(Enum.to_list(1..i)) end)
      IO.puts(" n = #{i}\t t = #{t} us")
    end
  end
  def mem_bench(n) do
    for i <- 1..n do
      {t,_} = :timer.tc(fn() -> cost_memo(Enum.to_list(1..i)) end)
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



  def cost([]) do {[]} end
  def cost([e]) do {0, e} end
  def cost(seq) do cost(seq, 0, [], []) end
  def cost([], l, left, right) do
    {leftCost, leftTree} = cost(left)
    {rightCost, rightTree} = cost(right)
    cost = l + leftCost + rightCost
    {cost, {leftTree, rightTree}}
  end
  def cost([s], l, [], right) do
    {rightCost, rightTree} = cost(right)
    cost = l + s + rightCost
    {cost, {s, rightTree}}
  end
  def cost([s], l, left, []) do
    {leftCost, leftTree} = cost(left)
    cost = s + l + leftCost
    {cost, {leftTree, s}}
  end

  def cost([s|rest], l, left, right) do
    {costL, rightTree} = cost(rest, l+s, [s|left], right)
    {costR, leftTree} = cost(rest, l+s, left, [s|right])
    if costL < costR do
      {costL, rightTree}
    else
      {costR, leftTree}
    end
  end

  defmodule Memo do
    def new() do %{} end
    def add(mem, key, val) do Map.put(mem, :binary.list_to_bin(key), val) end
    def lookup(mem, key) do Map.get(mem, :binary.list_to_bin(key)) end
  end
  def check(seq, mem) do
    case Memo.lookup(mem, seq) do
      nil ->
        cost_memo(seq, mem)
      {c, t} ->
        {c, t, mem}
    end
  end

#c("lumber.ex") && Lumber.mem_bench(8)
  def cost_memo([]) do {0, :na} end
  def cost_memo([e]) do {0, e} end
  def cost_memo(seq) do
  {c,t,_}=cost_memo(seq, 0, [], [], Memo.new())
  {c,t}
  end
  def cost_memo([e], mem) do {0, e, mem} end
  def cost_memo([s|rest] = seq, mem) do
    {c, t, mem} = cost_memo(rest, s, [s], [], mem)
    {c, t, Memo.add(mem, seq, {c, t})}
  end

  def cost_memo([], l, left, right, mem) do
    {leftCost, leftTree, left_mem} = check(left, mem)
    {rightCost, rightTree, right_mem} = check(right, left_mem)
    cost = l + leftCost + rightCost
    {cost, {leftTree, rightTree}, right_mem}
  end
  def cost_memo([s], l, [], right, mem) do
    {rightCost, rightTree, right_mem} = check(right, mem)
    cost = l + s + rightCost
    {cost, {s, rightTree}, right_mem}
  end
  def cost_memo([s], l, left, [], mem) do
    {leftCost, leftTree, left_mem} = check(left, mem)
    cost = s + l + leftCost
    {cost, {leftTree, s}, left_mem}
  end

  def cost_memo([s|rest], l, left, right, mem) do
    {costL, rightTree, right_mem} = cost_memo(rest, l+s, [s|left], right, mem)
    {costR, leftTree, left_mem} = cost_memo(rest, l+s, left, [s|right], right_mem)
    if costL < costR do
      {costL, rightTree, left_mem}
    else
      {costR, leftTree, left_mem}
    end
  end


end
