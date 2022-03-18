defmodule Morse do
  # Some test samples to decode.
  def base(), do: '.- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ... '

  def rolled(), do: '.... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .---- '

  #@type node() :: {:node, char(), node(), node()} | :nil

  def name_encode(), do: 'philip hagg'

  def decode(signal) do
    table = morse()
    decode(signal, table, table)
  end

  def decode([], _, _) do  []  end
  def decode([?- | tail], {:node, _, long, _}, table) do
    decode(tail, long, table)
  end
  def decode([?. | tail], {:node, _, _, short}, table) do
    decode(tail, short, table)
  end
  def decode([?\s | tail], {:node, char, _, _}, table) do
    [char|decode(tail, table, table) ]
  end



  def encode(text) do
    table = encode_table(morse())
    encode(text, [], table)
  end
  def encode([],_, _), do: []
  def encode([char | rest],so_far, table) do
    {_, code} = List.keyfind(table, char, 0)
    code ++ ' ' ++ encode(rest,so_far, table)
  end

  #def encode(text) do
  #  table = encode_table(morse())
  #  encode(text, [], table)
  #end
#
  #def encode([char],so_far,table) do
  #  {c,l} = Enum.find(table, fn({c,l})-> c==char end )
  #  List.to_string([l|so_far])
  #end
#
  #def encode([char | rest], so_far, table) do
  #  {c,l} = Enum.find(table, fn({c,l})-> c==char end )
  #  encode(rest, [l,' '|so_far],table)
  #end

  def encode_table(tree) do
    generate_path(tree,[])
  end
  #på right kan det behövas reverse
  def generate_path({:node,char,a,b}, binary_code) do
    [{char, binary_code}]++generate_path(a,binary_code ++ [?-]) ++ generate_path(b,binary_code ++ [?.])

  end
  def generate_path(a,code) do
    case a do
      nil -> []
      :na -> []
      _ -> [{a,code}]

    end
  end








  def morse() do
    {:node, :na,
      {:node, 116,
        {:node, 109,
          {:node, 111,
            {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
            {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
          {:node, 103,
            {:node, 113, nil, nil},
            {:node, 122,
              {:node, :na, {:node, 44, nil, nil}, nil},
              {:node, 55, nil, nil}}}},
        {:node, 110,
          {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
          {:node, 100,
            {:node, 120, nil, nil},
            {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
      {:node, 101,
        {:node, 97,
          {:node, 119,
            {:node, 106,
              {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}},
              nil},
            {:node, 112,
              {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}},
              nil}},
          {:node, 114,
            {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
            {:node, 108, nil, nil}}},
        {:node, 105,
          {:node, 117,
            {:node, 32,
              {:node, 50, nil, nil},
              {:node, :na, nil, {:node, 63, nil, nil}}},
            {:node, 102, nil, nil}},
          {:node, 115,
            {:node, 118, {:node, 51, nil, nil}, nil},
            {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
  end

  # Morse representation of common characters.
  #defp codes do
  #  [{32, '..--'},
  #    {37,'.--.--'},
  #    {44,'--..--'},
  #    {45,'-....-'},
  #    {46,'.-.-.-'},
  #    {47,'.-----'},
  #    {48,'-----'},
  #    {49,'.----'},
  #    {50,'..---'},
  #    {51,'...--'},
  #    {52,'....-'},
  #    {53,'.....'},
  #    {54,'-....'},
  #    {55,'--...'},
  #    {56,'---..'},
  #    {57,'----.'},
  #    {58,'---...'},
  #    {61,'.----.'},
  #    {63,'..--..'},
  #    {64,'.--.-.'},
  #    {97,'.-'},
  #    {98,'-...'},
  #    {99,'-.-.'},
  #    {100,'-..'},
  #    {101,'.'},
  #    {102,'..-.'},
  #    {103,'--.'},
  #    {104,'....'},
  #    {105,'..'},
  #    {106,'.---'},
  #    {107,'-.-'},
  #    {108,'.-..'},
  #    {109,'--'},
  #    {110,'-.'},
  #    {111,'---'},
  #    {112,'.--.'},
  #    {113,'--.-'},
  #    {114,'.-.'},
  #    {115,'...'},
  #    {116,'-'},
  #    {117,'..-'},
  #    {118,'...-'},
  #    {119,'.--'},
  #    {120,'-..-'},
  #    {121,'-.--'},
  #    {122,'--..'}]
  #end

end
