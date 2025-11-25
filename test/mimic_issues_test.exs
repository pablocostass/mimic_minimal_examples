defmodule MimicIssuesTest do
  use ExUnit.Case
  use Mimic

  describe "__MODULE__.fun() vs. fun()" do
    test "works with __MODULE__.fun()" do
      Mimic.expect(Mod1, :bar, 1, fn ->
        :mod1_mocked
      end)

      Mimic.expect(Mod2, :xyz, fn ->
        :mod2_mocked
      end)

      Mod1.foo1()
    end

    test "crashes with fun()" do
      Mimic.expect(Mod1, :bar, 1, fn ->
        :mod1_mocked
      end)

      Mimic.expect(Mod2, :xyz, fn ->
        :mod2_mocked
      end)

      Mod1.foo2()
    end
  end

  describe "regular process vs. Task vs. Task.Supervisor" do
    test "properly fails when not in a Task" do
      x = 1

      Mimic.expect(Mod3, :identity, fn received_x ->
        assert received_x == 2
        received_x
      end)

      Mod3.identity(x)
    end

    test "properly fails with Task.async/1" do
      x = 1

      Mimic.expect(Mod3, :identity, fn received_x ->
        assert received_x == 2
        received_x
      end)

      Task.async(fn -> Mod3.identity(x) end)
      |> Task.await()
    end

    test "weirdly success with Task.Supervisor.start_child/2" do
      {:ok, _pid} = Task.Supervisor.start_link(name: MyApp.TaskSupervisor)
      x = 1

      Mimic.expect(Mod3, :identity, fn received_x ->
        assert received_x == 2
        received_x
      end)

      Task.Supervisor.start_child(MyApp.TaskSupervisor, fn -> Mod3.identity(x) end)
    end
  end
end
