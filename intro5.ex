#Datastrukturer - tuples
defmodule Intro5 do
  def sum(x) do
    case x do
      {} -> 0
      {a} -> a
      {a,b} -> a+b
      {a,b,c} -> a+b+c
      error -> {:error,error}

    end
  end

end
