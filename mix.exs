defmodule ExSifiComix.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_sifi_comix,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:git_cli, "~> 0.3"},
      {:temp, "~> 0.4", only: :test}
    ]
  end
end
