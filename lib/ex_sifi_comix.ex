defmodule ExSifiComix do
  @moduledoc """
  Documentation for `ExSifiComix`.
  """

  @default_version "v0.0.1-tagless"

  @doc """
  Build version from git tag
  """
  def version do
    case :file.consult('hex_metadata.config') do
      # Use version from hex_metadata when we're a package
      {:ok, data} ->
        {"version", version} = List.keyfind(data, "version", 0)
        version

      # Otherwise, use git version
      _ ->
        git_version()
    end
  end

  @doc """
  Build version from git version tag
  """
  defp git_version do
    # Just remove the starting 'v' from git version tag
    git_version_tag |> String.slice(1..-1)
  end

  @doc """
  Get git version tag
  """
  defp git_version_tag do
    case System.cmd("git", ["describe", "--tags"]) do
      {"v" <> version, 0} ->
        "v" <> String.trim(version)

      {tag, 0} ->
        raise "Closest tag #{inspect(tag)} doesn't start with v?! (not version tag?)"

      {error, errno} ->
        IO.puts("Could not get version. errno: #{inspect(errno)}, error: #{inspect(error)}")
        @default_version
    end
  end
end
