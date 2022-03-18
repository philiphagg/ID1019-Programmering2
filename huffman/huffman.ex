defmodule Huffman do

  #c("huffman.ex") && Huffman.tree(Huffman.sample)
  #c("huffman.ex") && Huffman.tree(Huffman.text)
  #c("huffman.ex") && Huffman.test2()


  def measure(function) do
    function
    |> :timer.tc
    |> elem(0)
    |> Kernel./(1_000)
  end

  #def read(file) do
  #  {:ok, file} = File.open(file, [:read, :utf8])
  #  binary = IO.read(file, :all)
  #  File.close(file)

  #  case :unicode.characters_to_list(binary, :utf8) do
  #    {:incomplete, list, _} -> list
  #    list -> list
  #  end
  #end

  def read(file, n) do
    {:ok, fd} = File.open(file, [:read, :utf8])
    binary = IO.read(fd, n)
    File.close(fd)

    length = byte_size(binary)
    case :unicode.characters_to_list(binary, :utf8) do
      {:incomplete, chars, rest} ->
        {chars, length - byte_size(rest)}
      chars ->
        {chars, length}
    end
  end


  def sample do
    'the quick brown fox jumps over the lazy dog
this is a sample text that we will use when we build
up a table we will only handle lower case letters and
no punctuation symbols the frequency will of course not
represent english but it is probably not that far off'
  end

  def text() do
    'this is something that we should encode'
  end

  def test1 do
    sample = sample()
    tree = tree(sample)
    codes(tree, [])
  end
  def test2 do
    sample = sample()
    tree = tree(sample)
    encode_table(tree)
  end
  def test3 do
    sample = sample()
    tree = tree(sample)
    encode = encode_table(tree)
    encode(text,encode)
  end

  def test do
    sample = sample()
    tree = tree(sample)
    encode = encode_table(tree)
    decode = decode_table(tree)
    text = text()
    seq = encode(sample, encode)
    seq = encode(text, encode)
    decode(seq, decode)
  end

  #c("huffman.ex") && Huffman.measure_test("kallocain.txt", 300_000)
  def measure_test(file, n) do
    {text, b} = read(file, n)
    sample = sample()
    c = length(text)
    {tree, t2} = time(fn -> tree(text) end)
    {encode, t3} = time(fn -> encode_table(tree) end)
    s = length(encode)
    {decode, _} = time(fn -> decode_table(tree) end)
    {encoded, t5} = time(fn -> encode(text, encode) end)
    e = div(length(encoded), 8)
    r = Float.round(e / b, 3)
    {_, t6} = time(fn -> decode(encoded, decode) end)

    IO.puts("text of #{c} characters")
    IO.puts("tree built in #{t2} ms")
    IO.puts("table of size #{s} in #{t3} ms")
    IO.puts("encoded in #{t5} ms")
    IO.puts("decoded in #{t6} ms")
    IO.puts("source #{b} bytes, encoded #{e} bytes, compression #{r}")

  end

  def time(func) do
    initial = Time.utc_now()
    result = func.()
    final = Time.utc_now()
    {result, Time.diff(final, initial, :microsecond) / 1000}
  end

  def freq(sample) do
    freq(sample, [])
  end

  def freq([], freq) do
    freq
  end

  def freq([char | rest], freq) do
    freq(rest, count_char(char, freq))
  end

  def count_char(char, []) do # issue
    [{char, 1}]
  end
  def count_char(char, list) do
    [h1 | t1] = list
    {h2, t2} = h1
    cond do
      char === h2 -> [{h2, t2 + 1} | t1]
      true -> [h1] ++ count_char(char, t1)
    end
  end

  def tree(sample) do
    freq = freq(sample)
    huffman(freq)
  end

  def huffman(freq) do
    sorted = Enum.sort(freq, fn({_, x}, {_, y}) -> x < y end)
    huffman_tree(sorted)
  end


  def huffman_tree([{tree, _}]) do tree end
  def huffman_tree([{char1, char1_freq}, {char2, char2_freq} | rest]) do
    huffman_tree(insert({{char1, char2}, char1_freq + char2_freq}, rest))
  end

  def insert({char, freq}, []) do [{char, freq}] end
  def insert({char1, char1_freq}, [{char2, char2_freq} | rest]) when char1_freq < char2_freq do
    [{char1, char1_freq}, {char2, char2_freq} | rest]
  end
  def insert({char1, char1_freq}, [{char2, char2_freq} | rest]) do
    [{char2, char2_freq} | insert({char1, char1_freq}, rest)]
  end

  def codes({elem_1, elem_2}, binary_codes) do
    left = codes(elem_1, [0 | binary_codes])
    right = codes(elem_2, [1 | binary_codes])
    left ++ right
  end
  def codes( elem, code) do
    [{elem, Enum.reverse(code)}]
  end


  def encode_table(tree) do
    Enum.sort(codes(tree, []), fn({_,x},{_,y}) -> length(x) < length(y) end)
  end

  def decode_table(tree) do
    codes(tree, [])
  end

  def encode([], _), do: []
  def encode([char | rest], table) do
    {_, code} = List.keyfind(table, char, 0)
    code ++ encode(rest, table)
  end



  #def decode(seq, table) do
  #  {char, rest} = decode_char(seq, 1, table)
  #  [char | decode(rest, table)]
  #end
  #def decode_char(seq, n, table) do
  #  {code, rest} = Enum.split(seq, n)
  #  case List.keyfind(table, code, 1) do
  #    {char, _} ->
  #      {char, rest};
  #    nil ->
  #      decode_char(seq, n+1, table)
  #  end
  #end



  def decode(sequence, table) do
    decoder(sequence, table, [], [])
  end

  def decoder([], table, check, message) do
    Enum.reverse(message)
  end
  def decoder(encoded, table, check, message) do
    [head | tail] = encoded
    new_check = check ++ [head]
    decode_answer = decode_checker(new_check, table)
    case decode_answer do
      [nil] -> decoder(tail, table, new_check, message)
      _ -> decoder(tail, table, [], [decode_answer] ++ message)
    end
  end


  def decode_checker(code, []) do
    [nil]
  end
  def decode_checker(code, table) do
    [head | tail] = table
    {element, element_code} = head
    cond do
      code === element_code -> element
      true -> decode_checker(code, tail)
    end
  end

end
