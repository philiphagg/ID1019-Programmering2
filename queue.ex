defmodule Queue do
  def new() do {:queue,[],[]} end

  def add({:queue, front, back}, elem) do {:queue, front, [elem|back]} end

  def remove({:queue, [], []}) do :error end
  def remove(:queue, [], back) do
    {:queue, reverse(back), []}
  end
  def remove({:queue, [elem|rest], back}) do
    {:ok, elem, {:queue, rest, back}}
  end
  def reverse(lst) do reverse(lst,[]) end
  def reverse([], rev) do rev end
  def reverse([h|t], rev) do reverse(t, [h|rev]) end

end
