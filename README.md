# Simple cron-like scheduler

## Installation

The package can be installed
by adding `cron_scheduler` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cron_scheduler, "~> 0.1.0"}
  ]
end
```

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
                {"* * * * *", Module, :func}
              ]
            ]}
      }
    ],
    strategy: :one_for_one
  )
```

Source code can be found at [Github](https://github.com/drumser/cron-scheduler)
and documentation at [https://hexdocs.pm/cron_scheduler](https://hexdocs.pm/cron_scheduler/).

