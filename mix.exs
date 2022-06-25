defmodule Carbonex.MixProject do
  use Mix.Project

  def project do
    [
      app: :carbonex,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
     # mod: {MyApp.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.3"},
      {:finch, "~> 0.12.0"},
      {:multipart, "~> 0.3.0"},
#      {:environment, path: "../environment"}
    ]
  end
end
