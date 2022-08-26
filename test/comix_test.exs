defmodule CoMixTest do
  use ExUnit.Case
  doctest CoMix

  # Creates a temporary git repo for testing
  defp create_temp_repo(path) do
    dir = Temp.mkdir!(path)
    Git.init!(dir)
  end

  # Adds a commit and tags repo with desired tag
  defp commit_and_tag(repo, tag) do
    # Make an empty commit so we have something to tag
    Git.commit!(repo, ["--allow-empty", "-m test"])
    Git.tag!(repo, tag)
  end

  setup do
    # This neat library will clean up everything for us if we ask it to track~
    Temp.track!()
    {:ok, %{}}
  end

  # Captures version from tag version scheme and makes sure it's valid
  defp match_version_scheme(version) do
    version = Regex.run(~r/v((?:\d+\.){2}\d+(?:-.*)?)/, version, capture: :all_but_first)
    assert version, "Tag doesn't match version capture expression"
    version
  end

  test "version is valid but marked tagless when there are no tags" do
    # Create temporary repo for testing
    repo = create_temp_repo("tagless_repo")

    # Get output of CoMix.version inside repo
    version = File.cd!(repo.path, fn -> CoMix.version() end)
    # It should be marked tagless
    assert String.ends_with?(version, "tagless")

    # The version should match version scheme and return the same version
    expected = match_version_scheme("v" <> version)
    assert [version] == expected
  end

  test "version function retrieves git version from tag" do
    # Create and tag temporary repo for testing
    repo = create_temp_repo("properly_tagged_repo")
    commit_and_tag(repo, "v4.34.1-test")

    # Get output of CoMix.version inside repo
    version = File.cd!(repo.path, fn -> CoMix.version() end)

    # It should not be marked tagless
    assert !String.ends_with?(version, "tagless")

    # Git describe should match version scheme and that should be the same as what CoMix.version returns
    expected = Git.describe!(repo, "--tags")
    expected = match_version_scheme(expected)
    assert [version] == expected
  end

  test "version function throws an error when git version cannot be extracted from tag" do
    # Create and tag temporary repo for testing
    repo = create_temp_repo("invalidly_tagged_repo")
    # Tags without a leading v are invalid
    commit_and_tag(repo, "4.34.1-test")
    # CoMix.version inside repo should throw
    catch_error File.cd!(repo.path, fn -> CoMix.version() end)
  end
end
