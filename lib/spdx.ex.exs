json_path = Path.expand("../license-list-data/json/licenses.json", __DIR__)

json =
  case File.read(json_path) do
    {:ok, json} ->
      json

    {:error, :enoent} ->
      IO.puts("#{json_path} not found, run `git submodule update`")
      System.halt(1)
  end

data =
  json
  |> Jason.decode!()
  |> inspect(limit: :infinity)
  |> Code.format_string!()
  |> IO.iodata_to_binary()

code = """
# Automatically generated by spdx.ex.exs, do not edit manually.

defmodule SPDX do
  @data #{data}

  @spec version() :: String.t()
  def version() do
    @data["licenseListVersion"]
  end

  @spec semver() :: String.t()
  def semver() do
    version = String.trim_leading(version(), "v")
    [major_minor, patch, build] = String.split(version, "-")
    major_minor <> "." <> patch <> "+" <> build
  end

  @spec validate_identifier(identifier) :: :valid | :deprecated | :invalid

  for %{"licenseId" => id, "isDeprecatedLicenseId" => deprecated?} <- @data["licenses"] do
    result = if deprecated?, do: :deprecated, else: :valid
    def validate_identifier(unquote(id)), do: unquote(result)
  end

  def validate_identifier(other) when is_binary(other), do: :invalid
end
"""

module_path = Path.expand("spdx.ex", __DIR__)
File.write!(module_path, code)