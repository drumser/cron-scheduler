defmodule CronScheduler do
  @moduledoc """
  Simple cron-like scheduler that was made for educational purposes

  ## Usage
  ```elixir
    Supervisor.init(
      [
        %{
          id: CronScheduler,
          start:
            {CronScheduler, :start_link,
             [
               [
                 {"*/3 * * * *", fn -> IO.puts("execute */3 * * * *") end},
                 {"* * * * *", fn -> IO.puts("execute * * * * *") end}
               ]
             ]}
        }
      ],
      strategy: :one_for_one
    )
  ```
  """

  use Task

  @type job :: {String.t(), module(), String.t()} | {String.t(), function()}

  @spec start_link(list(job())) :: {:ok, pid}
  def start_link(jobs) do
    Task.start_link(__MODULE__, :loop, [jobs])
  end

  @spec loop(list(job())) :: no_return
  def loop(jobs) do
    jobs |> run

    get_left_seconds_from_new_minute()
    |> :timer.seconds()
    |> Process.sleep()

    loop(jobs)
  end

  defp run(jobs) when is_list(jobs) do
    {:ok, current_datetime} = get_current_datetime_without_seconds()

    jobs
    |> Enum.filter(&is_job_ready(&1, current_datetime))
    |> Enum.each(&handle_job/1)
  end

  defp is_job_ready(tuple, current_datetime) do
    elem(tuple, 0)
    |> get_next_run_date(current_datetime) == current_datetime
  end

  defp handle_job(job) do
    try do
      execute_job(job)
    rescue
      e -> IO.inspect {:error, e}
    end
  end

  defp execute_job({_, func}) when is_function(func) do
    Task.async(func)
  end

  defp execute_job({_, module, func}) do
    Task.async(module, func, [])
  end

  defp get_next_run_date(cron_expr, datetime) do
    {:ok, next_run_date} =
      cron_expr
      |> parse_cron_expression
      |> Crontab.Scheduler.get_next_run_date(datetime)

    next_run_date
  end

  defp parse_cron_expression(cron_expr) do
    case Crontab.CronExpression.Parser.parse(cron_expr) do
      {:ok, expr} -> expr
    end
  end

  defp get_left_seconds_from_new_minute do
    {_, _, seconds} = Time.utc_now() |> Time.to_erl()

    60 - seconds + 1
  end

  defp get_current_datetime_without_seconds() do
    current_datetime = NaiveDateTime.utc_now()

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
