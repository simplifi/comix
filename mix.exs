defmodule ExSifiComix.MixProject do
  use Mix.Project

  defp github, do: "https://github.com/simplifi/ex_sifi_comix"

  def project do
    [
      app: :ex_sifi_comix,
      version: "0.1.0",
      elixir: "~> 1.12",
      package: package(),
      description: "Common mix.exs code that all projects can benefit from",
      source_url: github(),
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
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:git_cli, "~> 0.3"},
      {:temp, "~> 0.4", only: :test}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md"],
      maintainers: ["RTB"],
      organization: "simplifi",
      links: %{Github: github()}
    ]
  end
end
