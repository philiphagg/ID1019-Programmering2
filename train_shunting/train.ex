defmodule Train do



end

defmodule Shunt do

  def split(list, atom) do
    case Lists.member(list, atom) do
      false -> :ops
      true -> {Lists.take(list, Lists.position(list, atom)-1), Lists.drop(list, Lists.position(list, atom))}
    end
  end

  def find(xs, ys) do
    case ys do
      [] -> []
      [y|t] ->
        {hs, ts} = split(xs, y)
        step = Moves.single({:one, length(ts)+1}, {xs, [], []})
        step = Moves.single({:two, length(hs)}, step)
        step = Moves.single({:one, -(length(ts)+1)}, step)
        {[_|t2], [], []} = Moves.single({:two, -(length(hs))}, step)

        [{:one, length(ts)+1}, {:two, length(hs)}, {:one, -(length(ts)+1)}, {:two, -(length(hs))}| find(t2, t)]
    end
  end


  def few([u|k], [u|t]) do few(k, t) end
  def few(xs, ys) do
    case ys do
      [] -> []
      [y|t] ->
        {hs, ts} = split(xs, y)
        step = Moves.single({:one, length(ts)+1}, {xs, [], []})
        step = Moves.single({:two, length(hs)}, step)
        step = Moves.single({:one, -(length(ts)+1)}, step)
        {[_|t2], [], []} = Moves.single({:two, -(length(hs))}, step)

        [{:one, length(ts)+1}, {:two, length(hs)}, {:one, -(length(ts)+1)}, {:two, -(length(hs))}| few(t2, t)]
    end
  end
end

#cd("train_shunting") && c("train.ex")
defmodule Lists do


  def take([h | _], 0) do [] end
  def take([h | _], 1) do [h] end
  def take([h | t], n) do [h | take(t, n - 1)] end

  def drop([]) do [] end
  def drop([h|t], 0) do [h|t] end
  def drop([_|t], 1) do t end
  def drop([_|t], n) do drop(t, n - 1) end

  def append(xs, ys) do
    xs ++ ys
  end

  def member([], _) do false end
  def member([h|t], y) do
    cond do
      h == y -> true
      true -> member(t, y)
    end
  end

  def position([], _) do :ops end
  def position([h|t], y) do
    cond do
      h == y -> 1
      true -> 1 + position(t, y)
    end
  end

end
#c("train.ex") && Moves.move([{:one,1},{:two,1},{:one,-1}],{[:a,:b],[],[]})
defmodule Moves do
  def single({:one,n},{main,one,two}) do
    case n do
      0 -> {main,one,two}
      -1 -> {Lists.append(main,Lists.take(one,1)), Lists.drop(one,1),two}
      1 -> {Lists.take(main,length(main)-n), Lists.drop(Lists.append(main,one),length(main)-n),two}
    end
  end

  def single({:two,n},{main,one,two})do
    case n do
      0 -> {main, one, two}
      -1 -> {Lists.append(main,Lists.take(two,1)),one,Lists.drop(two,1)}
      1 -> {Lists.take(main,length(main)-n),one,Lists.append(Lists.drop(main,length(main)-n), two)}
    end
  end
  def move([], state) do [state] end
  def move([h|t], state) do
    [state|move(t,single(h,state))]
  end




  #c("train.ex") && Moves.test2()
  def test() do
    single({:one, -1},{[:a,:b],[:d,:e],[:f,:g]})
  end
  def test2() do
    single({:one, 1},{[:a,:b],[],[]})
  end
end
