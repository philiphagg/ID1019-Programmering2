defmodule QuickSort do
  require Integer

  @spec quick_sort(list(Integer)) :: list(Integer)
  def quick_sort([]), do: []

  def quick_sort([head | tail]) do
    smaller = Enum.filter(tail, fn x -> x <= head end) |> quick_sort()
    bigger = Enum.filter(tail, fn x -> x > head end) |> quick_sort()

    Enum.concat(smaller, [head]) |> Enum.concat(bigger)
  end
end
