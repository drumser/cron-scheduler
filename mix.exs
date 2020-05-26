defmodule Scheduler.MixProject do
  use Mix.Project

  def project do
    [
      app: :cron_scheduler,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:crontab, "~> 1.1.2"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
    ]
  end

  defp description do
    """
    Simple cron-like scheduler that was made for educational purposes
    """
  end

  defp package do
    [
     files: ["lib", "mix.exs", "README.md"],
     maintainers: ["Yos Riady"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/drumser/cron-scheduler",
              "Docs" => "https://hexdocs.pm/cron_scheduler/"}
     ]
  end
end
