defmodule TurnThePage.Mixfile do
  use Mix.Project

  def project do
    [
      app: :turn_the_page,
      version: "0.2.6",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      source_url: "https://github.com/PatNowak/turn_the_page",
      name: "TurnThePage",
      package: package(),
      description: description()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ecto, "~> 2.0.0"},
      {:ex_doc, "~> 0.16.2", only: :dev}
    ]
  end

  defp package do
    [
       name: :turn_the_page,
       maintainers: ["Patryk Nowak"],
       licenses: ["Apache 2.0"],
       links: %{"GitHub" => "https://github.com/PatNowak/turn_the_page"}
   ]
  end

  defp description do
    "Fast, simple and lightweight pagination system for your Elixir application."
  end
end
