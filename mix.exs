defmodule Grapey.MixProject do
  use Mix.Project

  def project do
    [
      app: :grapey,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Grapey.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.1"},
      {:sweet_xml, "~> 0.6.6"},
      {:tesla, "~> 1.2.0"},
      {:hackney, "~> 1.14.0"} # optional, but recommended adapter
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
