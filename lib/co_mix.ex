defmodule CoMix do
  @moduledoc File.read!(Path.expand("../README.md", __DIR__))

  @default_version "v0.0.1-tagless"

  @doc """
  Build version from git tag
  """
  def version do
    case :file.consult("hex_metadata.config") do
      # Use version from hex_metadata when we're a package
      {:ok, data} ->
        {"version", version} = List.keyfind(data, "version", 0)
        version

      # Otherwise, use git version
      _ ->
        git_version()
    end
  end

  # Build version from git version tag
  defp git_version do
    # Just remove the starting 'v' from git version tag
    git_version_tag() |> String.slice(1..-1)
  end

  # Get git version tag
  defp git_version_tag do
    case Git.describe(Git.new(), "--tags") do
      {:ok, "v" <> version} ->
        "v" <> String.trim(version)

      {:ok, tag} ->
        raise "Closest tag #{inspect(tag)} doesn't start with v?! (not version tag?)"

      {:error, error} ->
        msg = "could not get version. Error: #{inspect(error)}"

        if System.get_env("CO_MIX_TAGLESS") do
          IO.puts("CO_MIX_TAGLESS is set, so this may be intentional, but #{msg}")
          @default_version
        else
          Kernel.raise("Env Var CO_MIX_TAGLESS is unset, raising because #{msg}")
        end
    end
  end
end
