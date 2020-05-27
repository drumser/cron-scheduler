defmodule CronScheduler.Server do
  @moduledoc """
  Simple cron-like scheduler that was made for educational purposes

  ## Usage
  ```elixir
    CronScheduler.Server.start_link([
      {
        {"* * * * *", fn -> IO.puts("execute * * * * *") end},
        {"* * * * *", {Module, :func_name, []}}
      }
    ])
  ```
  """
  alias Crontab.CronExpression.Parser, as: CronParser

  require Logger
  use Task

  @type job :: {String.t(), {module(), String.t(), list()}} | {String.t(), function()}

  @spec start_link(list(job())) :: {:ok, pid}
  def start_link(jobs) do
    Logger.debug("Starting cron scheduler")
    Task.start_link(__MODULE__, :loop, [jobs])
  end

  @spec loop(list(job())) :: no_return
  def loop(jobs) do
    run(jobs)

    get_left_seconds_from_new_minute()
    |> :timer.seconds()
    |> Process.sleep()

    loop(jobs)
  end

  defp run(jobs) when is_list(jobs) do
    current_datetime = get_current_datetime_without_seconds()

    jobs
    |> Enum.filter(&is_job_ready(&1, current_datetime))
    |> Enum.each(&handle_job/1)
  end

  defp is_job_ready({cron_expr, _}, current_datetime) do
    cron_expr
    |> parse_cron_expression()
    |> get_next_run_date(current_datetime)
    |> Kernel.==(current_datetime)
  end

  defp handle_job(job) do
    Logger.debug("Execute cron job #{inspect(job)}")
    execute_job(job)
    catch
      e -> Logger.error(inspect(e))
  end

  defp execute_job({_, {module, func, args}}), do: Task.start(module, func, args)
  defp execute_job({_, func}), do: Task.start(func)

  defp get_next_run_date(cron_expr, datetime) do
    {:ok, next_run_date} =
      cron_expr
      |> Crontab.Scheduler.get_next_run_date(datetime)

    next_run_date
  end

  defp parse_cron_expression(cron_expr) do
    case CronParser.parse(cron_expr) do
      {:ok, expr} -> expr
    end
  end

  defp get_left_seconds_from_new_minute do
    {_, _, seconds} = Time.utc_now() |> Time.to_erl()

    60 - seconds + 1
  end

  defp get_current_datetime_without_seconds do
    case CronScheduler.DateHelper.utc_now(:without_seconds) do
      {:ok, datetime} -> datetime
    end
  end
end
