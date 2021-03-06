defmodule Test do

  def demo2() do
    #eight_k(-2.6, 1.2, 1.2)
    eight_k(-0.17,0.86,-0.125)
  end

  def big(x0, y0, xn) do
    width = 1920
    height = 1080
    depth = 250
    k = (xn - x0) / width
    image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
    PPM.write("bigger.ppm", image)
  end

  def eight_k(x0, y0, xn) do
    width = 7680
    height = 4320
    depth = 128
    k = (xn - x0) / width
    image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
    PPM.write("8k-2.ppm", image)
  end

  def demo3() do
    eight_k(-0.9, 1.2, 1.2)
  end


  def demo() do
    small(-2.6, 1.2, 1.2)
    #small(-0.17,0.86,-0.125)
  end

  def small(x0, y0, xn) do
    width = 960
    height = 540
    depth = 64
    k = (xn - x0) / width
    image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
    PPM.write("small2.ppm", image)
  end

end


defmodule Mandel do

  def mandelbrot(width, height, x, y, k, depth) do
    trans = fn(w, h) ->
      Complex.new(x + k * (w - 1), y - k * (h - 1))
    end
    widthval = width
    rows(width, widthval, height, trans, depth, [], [])
  end

  def rows(_, _, 0, _, _, colors, _) do colors end
  def rows(0, widthval, height, trans, depth, colors, color) do
    width = widthval
    rows(width, widthval, height - 1, trans, depth, [color|colors], [])
  end
  def rows(width, widthval, height, trans, depth, colors, color) do
    c = trans.(width, height)
    brot = Brot.mandelbrot(c, depth)
    col = Colors.convert(brot, depth)
    rows(width - 1, widthval, height, trans, depth, colors, [col|color])
  end
end

defmodule Colors do

  def convert(depth, max) do
    ratio = depth/max
    ratio_multiplier = ratio * 4
    floor_of_ratio_multiplier = trunc(ratio_multiplier)
    gradient = trunc(255 * (ratio_multiplier - floor_of_ratio_multiplier))

    case floor_of_ratio_multiplier do
      0 -> {:rgb, 0, gradient, 0}
      1 -> {:rgb, 0, 255, 255 - gradient}
      2 -> {:rgb, 255-gradient, 255, 0}
      3 -> {:rgb, 0, 255, gradient}
      4 -> {:rgb, 0, 255-gradient, 255}
    end
  end

  #def convert(d, max) do
  #  blue(d, max)
  #end
#
  #def red(d, max) do
  #  f = d / max
#
  #  # a is [0 - 4.0]
  #  a = f * 4
#
  #  # x is [0,1,2,3,4]
  #  x = trunc(a)
#
  #  # y is [0 - 255]
  #  y = trunc(255 * (a - x))
#
  #  case x do
  #    0 ->
  #      # black -> red
  #      {:rgb, y, 0, 0}
#
  #    1 ->
  #      # red -> yellow
  #      {:rgb, 255, y, 0}
#
  #    2 ->
  #      # yellow -> green
  #      {:rgb, 255 - y, 255, 0}
#
  #    3 ->
  #      # green -> cyan
  #      {:rgb, 0, 255, y}
#
  #    4 ->
  #      # cyan -> blue
  #      {:rgb, 0, 255 - y, 255}
  #  end
  #end
#
  #def blue(d, max) do
  #  f = d / max
#
  #  # a is [0 - 4.0]
  #  a = f * 4
#
  #  # x is [0,1,2,3,4]
  #  x = trunc(a)
#
  #  # y is [0 - 255]
  #  y = trunc(255 * (a - x))
#
  #  case x do
  #    0 ->
  #      # black -> blue
  #      {:rgb, 0, 0, y}
#
  #    1 ->
  #      # blue -> cyan
  #      {:rgb, 0, y, 255}
#
  #    2 ->
  #      # cyan -> green
  #      {:rgb, 0, 255, 255 - y}
#
  #    3 ->
  #      # green -> yellow
  #      {:rgb, y, 255, 0}
#
  #    4 ->
  #      # yellow-> red
  #      {:rgb, 255, 255 - y, 0}
  #  end
  #end
end


defmodule Brot do

  def mandelbrot(c, m) do
    z0 = Complex.new(0, 0)
    test(0, z0, c, m)
  end

  def test(m, _z, _c, m), do: 0
  def test(i, z, c, m) do
    a = Complex.abs(z)

    if a <= 2.0 do
      z1 = Complex.add(Complex.sqr(z), c)
      test(i + 1, z1, c, m)
    else
      i
    end
  end
end
#operationer p?? komplexa tal
defmodule Complex do

  def new(r, i) do
    {:cmplx, r, i}
  end

  def add({:cmplx, ar, ai}, {:cmplx, br, bi}) do
    {:cmplx, ar + br, ai + bi}
  end

  def sqr({:cmplx, r, i}) do
    {:cmplx, (r * r) - (i * i),  2 * (r * i)}
  end

  def abs({:cmplx, r, i}) do
    :math.sqrt((r * r) + (i * i))
  end

end

defmodule Print do

  def start(file, width, height) do
    pid = spawn(fn -> init(file, width, height) end)
    {:ok, pid}
  end

  def init(file, width, height) do
    {:ok, fd} = File.open(file, [:write])
    IO.puts(fd, "P6")
    IO.puts(fd, "#generated by ppm.ex")
    IO.puts(fd, "#{width} #{height}")
    IO.puts(fd, "255")
    rows(height, 1, width, fd)
    IO.puts("Image #{file} printed!")
    File.close(fd)
  end

  defp rows(0, _, _, _fd), do: :ok
  defp rows(h, n, w, fd) do
    receive do
      :go ->
        ### the server has sent a row to a client
        :ok
    end

    receive do
      {:row, ^n, row} ->
        chars = row(row)
        IO.write(fd, chars)
        rows(h - 1, n + 1, w, fd)
    after
      1000 ->
        black =
          List.foldr(Enum.to_list(1..w), [], fn _, a ->
            [0, 0, 0 | a]
          end)

        IO.write(fd, black)
        rows(h - 1, n + 1, w, fd)
    end
  end

  defp row(row) do
    List.foldr(row, [], fn {:rgb, r, g, b}, a ->
      [r, g, b | a]
    end)
  end

end

defmodule PPM do

  # write(name, image) The image is a list of rows, each row a list of
  # tuples {R,G,B}. The RGB values are 0-255.

  def write(name, image) do
    height = length(image)
    width = length(List.first(image))
    {:ok, fd} = File.open(name, [:write])
    IO.puts(fd, "P6")
    IO.puts(fd, "#generated by ppm.ex")
    IO.puts(fd, "#{width} #{height}")
    IO.puts(fd, "255")
    rows(image, fd)
    File.close(fd)
  end

  defp rows(rows, fd) do
    Enum.each(rows, fn(r) ->
      colors = row(r)
      IO.write(fd, colors)
    end)
  end

  defp row(row) do
    List.foldr(row, [], fn({:rgb, r, g, b}, a) ->
      [r, g, b | a]
    end)
  end

end



