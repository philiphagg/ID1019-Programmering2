defmodule Merge do
  def msort(l) do
    case l do
      [] -> []
      [h] -> [h]
      [_|_] -> {low, high} = msplit(l, [], [])
               merge(msort(low), msort(high))
    end
  end

  def merge(low, []) do low end
  def merge([], high) do high end
  def merge(low = [h1|t1], high = [h2|t2]) do
    if h1 < h2 do
      [h1 | merge(t1, high)]
    else
      [h2 | merge(low, t2)]
    end
  end

  def msplit(l, low, high) do
    case l do
      [] -> {low, high}
      [h|t] -> msplit(t, [h | high], low)
    end
  end

end
