defmodule CronScheduler.DateHelper do
  @moduledoc """
  Date helper
  """
  def utc_now(:without_seconds) do
    current_datetime = NaiveDateTime.utc_now

    NaiveDateTime.new(
      current_datetime.year,
      current_datetime.month,
      current_datetime.day,
      current_datetime.hour,
      current_datetime.minute,
      0
    )
  end
end
