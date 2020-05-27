defmodule TestModule do
  @moduledoc """
  Module used by tests
  """
  def hello({caller}) do
    send(caller, {:hello})
  end
end
