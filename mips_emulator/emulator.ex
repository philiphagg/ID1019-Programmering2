defmodule Emulator do

  def run(prgm) do
    {code, data} = Program.load(prgm)
    reg = Register.new()
    out = Out.new()
    run(0, code, data, reg, out)
  end


  def run(pc, code, mem, reg, out) do
    next = Program.read(code, pc)
    case next do

      {:halt} ->
        Out.close(out)

      {:out, rs} ->
        a = Register.read(reg, rs)
        run(pc+4, code, mem, reg, Out.put(out,a))

      {:add, rd, rs, rt} ->
        a = Register.read(reg, rs)
        b = Register.read(reg, rt)
        reg = Register.write(reg, rd, a + b)  # we're not handling overflow
        run(pc+4, code, mem, reg, out)

      {:sub, rd, rs, rt} ->
        a = Register.read(reg, rs)
        b = Register.read(reg, rt)
        reg = Register.write(reg, rd, a - b)
        run(pc+4, code, mem, reg, out)

      {:addi, rd, rs, imm} ->
        a = Register.read(reg, rs)
        reg = Register.write(reg, rd, a + imm)
        run(pc+4, code, mem, reg, out)

      {:beq, rs, rt, imm} ->
        a = Register.read(reg, rs)
        b = Register.read(reg, rt)
        pc = if a == b do  pc+(imm*4) else pc end
        run(pc+4, code, mem, reg, out)

      {:bne, rs, rt, imm} ->
        a = Register.read(reg, rs)
        b = Register.read(reg, rt)
        pc = if a != b do  mem[imm] else pc+4 end
        run(pc, code, mem, reg, out)

      {:lw, rd, rs, imm} ->
        a = Register.read(reg, rs)
        val = Memory.read(mem, imm)
        reg = Register.write(reg, rd, val)
        run(pc+4, code, mem, reg, out)

      {:sw, rs, rt, imm} ->
        vs = Register.read(reg, rs)
        vt = Register.read(reg, rt)
        addr = vt + mem[imm]
        mem = Memory.write(mem, addr, vs)
        run(pc+4, code, mem, reg, out)

        {:label, v} ->
          mem = [{v, pc} | mem]
          run(pc+4, code, mem, reg, out)



    end
  end



end