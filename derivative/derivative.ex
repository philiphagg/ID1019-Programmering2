defmodule Derivative do

  @type literal() :: {:num, number()} | {:var,atom()}

  @type expr() :: literal()
  |   {:add, expr(), expr()}
  |   {:mul, expr(), expr()}
  |   {:exp, expr(), literal()}
  |   {:div, expr(), expr()}

  def test1() do
    e = {:add,
        {:mul, {:num, 2}, {:var, :x}},
        {:num, 4}}
    d = deriv(e,:x)
    c = calc(d, :x, 5)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simplify(d))}\n")
    IO.write("Calculated: #{pprint(simplify(c))}\n")
    :ok
  end

  #2x^2+3x+5
  def test3() do
    e ={:add,
        {:add,
        {:mul, {:exp,{:var, :x},{:num,2}}, {:num, 2}},
        {:mul, {:num, 3}, {:var, :x}}},
        {:num, 5}}
    d = deriv(e,:x)
    c = calc(d, :x, 5)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simplify(d))}\n")
    IO.write("Calculated: #{pprint(simplify(c))}\n")
    :ok
  end

  def test2() do
    e = {:add,
      {:exp, {:var, :x}, {:num, 3}},
      {:num, 4}}
    d = deriv(e,:x)
    c = calc(d, :x, 4)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simplify(d))}\n")
    IO.write("Calculated: #{pprint(simplify(c))}\n")
    :ok
  end

  def testXhattN()do
    e = {:exp, {:var, :x}, {:var, 4}}
    d = deriv(e, :x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
    IO.write("Simplified: #{pprint(simplify(d))}\n")
  end

  def lnx() do
    e = {:ln, {:var, :x}}
    d = deriv(e, :x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
  end

  def oneOverX() do
    e = {:div,{:num, 1},{:var, :x}}
    d = deriv(e,:x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
  end

  def testSqrt() do
    e = {:sqrt, {:var, :x}}
    d = deriv(e, :x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
  end

  def testSinx() do
    e = {:sin, {:var, :x}}
    d = deriv(e, :x)
    IO.write("Expression: #{pprint(e)}\n")
    IO.write("Derivative: #{pprint(d)}\n")
  end

  def deriv({:num, _}, _) do {:num, 0} end
  def deriv({:var, x}, x) do {:num, 1} end
  def deriv({:var,_},_) do {:num, 0} end
  #Sum rule
  def deriv({:add, e1, e2}, x) do
    {:add, deriv(e1, x), deriv(e2, x)}
  end
  #Chain rule
  def deriv({:mul, e1, e2}, x) do
    {:add,
    {:mul, deriv(e1, x), e2},
    {:mul, e1, deriv(e2, x)}}
  end
  #power rule
  def deriv({:exp, e, {:num, n}}, v) do
    {:mul,
      {:mul, {:num, n}, {:exp, e,{:num,n-1 }}},
    deriv(e,v)}
  end
  #--------
  #--------
  #power rule
  def deriv({:exp, {:var, x}, {:num, n}}, x) do
    {:mul, {:num, n}, { :exp, { :var, x }, {:num, n - 1}}}
  end

  #ln(x)
  def deriv({:ln, {:var, x}}, x) do
    {:div, {:num, 1}, {:var, x}}
  end
  #1/x
  def deriv({:div, {:num,1}, {:var, x}}, x) do
    {:div,
    {:num, -1},
    {:exp, {:var, x}, {:num, 2}}}
  end

  #sqrt(x)
  def deriv({:sqrt, {:var, x}}, x) do
  {:div,
  {:num, 1},
  {:mul,
  {:num, 2}, {:sqrt, {:var, x}}}}
  end
  #sin(x)
  def deriv({:sin, {:var, x}}, x) do
    {:cos, {:var, x}}
  end

  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end
  def simplify({:mul, e1,e2})do
    simplify_mul(simplify(e1), simplify(e2))
  end
  def simplify({:exp, e1,e2})do
    simplify_exp(simplify(e1), simplify(e2))
  end
  def simplify(e) do e end



  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add(e1,{:num, 0}) do e1 end
  def simplify_add({:num, n1},{:num, n2}) do {:num, n1+n2} end
  def simplify_add(e1,e2) do {:add, e1,e2} end


  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(_,{:num, 0}) do {:num, 0} end
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul(e1, {:num, 1}) do e1 end
  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
  def simplify_mul(e1,e2) do {:mul, e1,e2} end


  def simplify_exp(_, {:num, 0}, _) do {:num, 1} end
  def simplify_exp(e1,{:num, 1}) do e1 end
  def simplify_exp({:num, n1}, {:num, n2}) do {:num, :math.pow(n1,n2)} end
  def simplify_exp(e1,e2) do {:exp, e1, e2} end

  def calc({:num, n}, _, _) do {:num, n} end
  def calc({:var, v}, v, n) do {:num, n} end
  def calc({:var, v}, _, _) do {:var, v} end
  def calc({:add, e1, e2}, v, n) do
    {:add, calc(e1, v, n), calc(e2, v, n)}
  end
  def calc({:mul, e1, e2}, v, n) do
    {:mul, calc(e1, v, n), calc(e2, v, n)}
  end
  def calc({:exp, e1, e2}, v, n) do
    {:exp, calc(e1, v, n), calc(e2, v, n)}
  end

  def pprint({:num, n}) do "#{n}" end
  def pprint({:var, v}) do "#{v}" end
  def pprint({:add, e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})" end
  def pprint({:mul, e1, e2}) do "#{pprint(e1)} * #{pprint(e2)}" end
  def pprint({:exp, e1, e2}) do "(#{pprint(e1)})^(#{pprint(e2)})" end
  def pprint({:ln, x}) do "ln(#{pprint(x)})" end
  def pprint({:div, e1,e2}) do "#{pprint(e1)}/(#{pprint(e2)})" end
  def pprint({:sqrt, x}) do "sqrt(#{pprint(x)})" end
  def pprint({:sin, x}) do "sin(#{pprint(x)})" end
  def pprint({:cos, x}) do "cos(#{pprint(x)})" end
end
