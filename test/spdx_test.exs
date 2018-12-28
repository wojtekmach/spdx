defmodule SPDXTest do
  use ExUnit.Case, async: true

  test "version/0" do
    assert SPDX.version() >= "v3.4"
    assert SPDX.version() < "v4.0"
  end

  test "semver/0" do
    assert Version.match?(SPDX.semver(), ">= 3.4.0")
  end

  test "validate_identifier/1" do
    assert SPDX.validate_identifier("Apache-2.0") == :valid

    assert SPDX.validate_identifier("AGPL-1.0") == :deprecated

    assert SPDX.validate_identifier("bad") == :invalid
  end
end
