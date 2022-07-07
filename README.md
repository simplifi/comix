# ExSifiComix
Common mix.exs code that all projects can benefit from

## Installation
Add this to your mix.exs file:
```elixir
Mix.Install([
  {:ex_sifi_comix, "~> 0.1.0"}
])
```
Then set `version = ExSifiComix.version()` instead of using a hardcoded version.

## Testing
Testing is done by running `mix test`, for custom scenarios follow the below directions first:
- Test custom git tags by creating them with `git tag <tag name>`
- Test having no git tags by deleting all tags with `git tag -d $(git tag -l)`
- Restore all git tags from the repo remote with `git fetch --tags` after testing
