defmodule CronSchedulerTest do
  use ExUnit.Case

  test "Test run lambda" do
    receiver = self()
    {:ok, _pid} = CronScheduler.Server.start_link([{"* * * * *", fn -> send(receiver, {:hello}) end}])

    assert_receive {:hello}
  end

  test "Test run module" do
    receiver = self()
    {:ok, _pid} = CronScheduler.Server.start_link([{"* * * * *", {TestModule, :hello, [{receiver}]}}])
    assert_receive {:hello}
  end
end
