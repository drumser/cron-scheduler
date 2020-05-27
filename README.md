# Simple cron-like scheduler

## Installation

The package can be installed
by adding `cron_scheduler` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cron_scheduler, "~> 0.2.0"}
  ]
end
```

## Usage
```elixir
CronScheduler.Server.start_link([
  {
    {"* * * * *", fn -> IO.puts("execute * * * * *") end},
    {"* * * * *", {Module, :func_name, []}}
  }
])
```

Source code can be found at [Github](https://github.com/drumser/cron-scheduler)
and documentation at [https://hexdocs.pm/cron_scheduler](https://hexdocs.pm/cron_scheduler/).

