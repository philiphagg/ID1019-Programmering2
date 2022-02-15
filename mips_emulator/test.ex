defmodule Test do

  def test2() do

  end

  def demo2() do
    code =
      [
        {:addi, 1, 0, 5},     # $1 <- 5
        {:lw, 2, 0, :arg},    # $2 <- data[:arg]
        {:add, 4, 2, 1},      # $4 <- $2 + $1
        {:addi, 5, 0, 1},     # $5 <- 1
        {:label, :loop},
        {:sub, 4, 4, 5},      # $4 <- $4 - $5
        {:out, 4},            # out $4
        {:bne, 4, 0, :loop},  # branch if not equal
        {:halt}
      ]
    data =
      [
        {:arg, 12}
      ]
    prgm = {:prgm, code, data}
    Emulator.run(prgm)
  end



  def test() do
    code = Program.assemble(demo())
    mem = Memory.new([])
    out = Out.new()
    Emulator.run(code, mem, out)
  end

  def demo() do
    [
      {:addi, 1, 0, 10},
      {:addi, 2, 0, 5},
      {:add, 3, 1, 2},
      {:sw, 3, 0, 7},
      {:lw, 4, 0, 7},
      {:addi, 5, 0, 1},
      {:sub, 4, 4, 5},
      {:out, 4},
      {:bne, 4, 0, -3},
      {:halt}
    ]
  end



end