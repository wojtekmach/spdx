defmodule SPDX.MixProject do
  use Mix.Project

  def project() do
    [
      app: :spdx,
      version: "0.1.0",
      elixir: "~> 1.4",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  defp deps() do
    [
      {:jason, "~> 1.0", only: [:dev, :test]}
    ]
  end

  defp aliases() do
    [
      test: [
        "run lib/spdx.ex.exs",
        "compile",
        "test"
      ]
    ]
  end
end
