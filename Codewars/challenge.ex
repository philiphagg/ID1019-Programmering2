
  defmodule Challenge do
    @pairs %{"{" => "}", "[" => "]", "(" => ")"}
    @opener ["{", "[", "("]
    @closer ["}", "]", ")"]
    def valid_braces(braces) do
      braces
    |> String.split("")
    |> Enum.filter(&(&1 in @opener || &1 in @closer))
    |> iterate([])
    end
    defp iterate([], []), do: true
    defp iterate([], _stack), do: false

    defp iterate([head | tail], stack) when head in @opener,
         do: iterate(tail, [head | stack])

    defp iterate([head | _], []) when head in @closer, do: false

    defp iterate([head | tail], [stack_head | stack_tail]) when head in @closer,
         do: @pairs[stack_head] == head && iterate(tail, stack_tail)




    def valid_braces2(braces) do
      validate(String.codepoints(braces), [])
    end

    defp validate([")" | tail], ["(" | tokens]), do: validate(tail, tokens)
    defp validate(["]" | tail], ["[" | tokens]), do: validate(tail, tokens)
    defp validate(["}" | tail], ["{" | tokens]), do: validate(tail, tokens)
    defp validate([head | tail], tokens) when head in ["(", "[", "{"], do: validate(tail, [head | tokens])
    defp validate([], []), do: true
    defp validate(_, _), do: false
  end

