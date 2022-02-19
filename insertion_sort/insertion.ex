defmodule Insertion do
  def iSort(l) do
    iSort(l, [])
  end
  def iSort(l, sorted) do
    case l do
      [] -> sorted
      [h|t] -> iSort(t, insert(h, sorted))
    end
  end

  def iSort2(l) do
    iSort2(l, [])
  end
  def iSort2([], sorted) do sorted end
  def iSort2([h|t], sorted) do
    iSort2(t, insert(h, sorted))
  end

end
