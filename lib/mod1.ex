defmodule Mod1 do
  def foo1 do
    __MODULE__.bar()
    Mod2.xyz()
  end

  def foo2 do
    bar()
    Mod2.xyz()
  end

  def bar do
    :mod1_unmocked
  end
end
