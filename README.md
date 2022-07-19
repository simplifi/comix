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
Testing is done by running `mix test`
