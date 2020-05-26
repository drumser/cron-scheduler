defmodule CronSchedulerTest do
  use ExUnit.Case
  doctest CronScheduler

  test "process started" do
    receiver = self()
    {:ok, _pid} = CronScheduler.start_link([{"* * * * *", fn -> send(receiver, {:hello}) end}])

    assert_receive {:hello}
  end
end
