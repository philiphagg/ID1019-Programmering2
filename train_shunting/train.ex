defmodule Train do



end

defmodule Shunt do

  def split(list, atom) do
    case Lists.member(list, atom) do
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


  def few([head|k], [head|t]) do few(k, t) end
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

  def compress([])do [] end
  def compress(moves)do

    moves_compressed = rules(moves)

    case moves_compressed == moves do
      true -> moves
      false -> compress(moves_compressed)
    end
  end

  def rules([]) do [] end

  def rules([{_, 0} | []]) do [] end

  def rules([xs | []]) do [xs] end

  def rules([{_, 0} | tail]) do rules(tail) end

  def rules([{track1, order1},{_, 0} | tail])do
    rules([{track1, order1} | tail])
  end
  def rules([{track1, order1},{track1, order2}| tail])do
    rules([{track1, order1 + order2} | tail])
  end
  def rules([{track1, order1},{track2, order2}| tail])do
    [{track1, order1} | rules([{track2, order2} | tail])]
  end


  #def rules([]) do [] end
  #def rules([_, 0]) do [] end
  #def rules([{track_num,0} | rest]) do
  #  rules(rest)
  #end
  #def rules([{a,b}]) do [a,b] end
  #def rules([{track_num, num}, {track_num_num, num_num} | rest] = ms) do
  #  if track_num == track_num_num and num + num_num == 0 do
  #    rules(Lists.append([{track_num, num + num_num}], rest)) else
  #    Lists.append([{track_num,num}], [rules([{track_num_num, num_num}|rest])])
  #  end
  #end

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
  def single({:one, n}, {main, one, two}) do
    cond do
      length(main) - n < 0 ->
        {main, one, two}
      n < 0 ->
        {Lists.append(main, Lists.take(one, n*-1)), Lists.drop(one, n * -1), two}
      n > 0 ->
        {Lists.take(main, length(main)-n), Lists.append(Lists.drop(main, length(main)-n), one), two}
      true -> {main, one, two}
    end
  end


  def single({:two, n}, {main, one, two}) do
    cond do
      length(main) - n < 0 ->
        {main, one, two}
      n < 0 ->
        {Lists.append(main, Lists.take(two, n*-1)), one, Lists.drop(two, n*-1)}
      n > 0 ->
        {Lists.take(main, length(main)-n), one, Lists.append(Lists.drop(main, length(main)-n), two)}
      true -> {main, one, two}
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
