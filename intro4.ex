#Datastrukturer - Atoms

defmodule Intro4 do

 def hej(x) do
  case x do
   :foo -> :hello
   :bar -> :bye
   :zot -> :zot
   _ -> x
  end
 end

 def roman(x) do
  case x do
    :i -> 1
    :v -> 5
    :x -> 10
    :l -> 50
    :c -> 100
    :d -> 500
    :m -> 1000
  end
 end

end
