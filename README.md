# ExSifiComix
Common mix.exs code that all projects can benefit from

## Installation
Add this to the top of your mix.exs file:
```elixir
{:ok, _} = Application.ensure_all_started(:hex)
Mix.install([{:ex_sifi_comix, "~> 0.1.0", organization: "simplifi", runtime: false}])
```
Then set `version = ExSifiComix.version()` inside of the `def project`, instead of using a hardcoded version.

## Testing
Testing is done by running `mix test`.

## Releasing
You should be using [git flow](https://simplifi.atlassian.net/wiki/spaces/RTB/pages/28855038) here.
However, since this repo enables simplified versioning, we have chosen for the moment not to have it depend on itself.

As such, after running `git flow release start <X.Y.Z>`, you must create a commit bumping the version in mix.exs before running `git flow release finish <X.Y.Z>`.
