defmodule Bench do

  def bench() do

    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]

    time = fn (i, f) ->
      seq = Enum.map(1..i, fn(_) -> :rand.uniform(100000) end)
      elem(:timer.tc(fn () -> f.(seq) end),0)
    end

    bench = fn (i) ->

      list = fn (seq) ->
        List.foldr(seq, list_new(), fn (e, acc) -> list_insert(e, acc) end)
      end

      tree = fn (seq) ->
        List.foldr(seq, tree_new(), fn (e, acc) -> tree_insert(e, acc) end)
      end

      tl = time.(i, list)
      tt = time.(i, tree)

      IO.write("  #{tl}\t\t\t#{tt}\n")
    end

    IO.write("# benchmark of lists and tree \n")
    Enum.map(ls, bench)

    :ok
  end

  def list_new() do [] end

  def list_insert(e, []) do
    [e]
  end
  def list_insert(e, [h|t]) when e < h do
    [e,h|t]
  end
  def list_insert(e, [h|t]) do
    [h|list_insert(e, t)]
  end


def tree_new() do :nil end

  def tree_insert(e, :nil) do {:leaf, e} end
  def tree_insert(e, {:leaf, h}=right) when e < h do
    {:node, e, :nil, right}
  end
  def tree_insert(e, {:leaf, _}=left)  do
    {:node, e, left, :nil}
  end
  def tree_insert(e, {:node, h, left, right}) when e < h do
    {:node, h, tree_insert(e, left), right}
  end
  def tree_insert(e, {:node, h, left, right}) do
    {:node, h, left, tree_insert(e, right)}
  end

end