defmodule ExSifiComixTest do
  use ExUnit.Case
  doctest ExSifiComix

  test "version function retrieves git version from tag" do
    version = ExSifiComix.version()

    expected =
      case System.cmd("git", ["describe", "--tags"]) do
        {tag, 0} ->
          tag

        _ ->
          # If no version could be detected by tag, make sure the version mentions we're tagless
          assert version |> String.ends_with?("tagless")
          "v" <> version
      end

    # Don't enforce a version here, just enforce tagged version scheme
    expected = Regex.run(~r/v((?:\d+\.){2}\d+(?:-.*)?)/, expected, capture: :all_but_first)
    assert expected, "Tag doesn't match version capture expression"

    assert [version] == expected
  end
end
