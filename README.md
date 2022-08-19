# ExSifiComix
Common mix.exs code that all projects can benefit from

## Installation
Add this to the top of your mix.exs file:
```elixir
unless Kernel.function_exported?(ExSifiComix, :version, 0) do
  {:ok, _} = Application.ensure_all_started(:hex)
  Mix.install([{:ex_sifi_comix, "~> 0.1", organization: "simplifi", runtime: false}])
end
```
Then set `version = ExSifiComix.version()` inside of the `def project`, instead of using a hardcoded version.

### Troubleshooting
#### Issue: Adding the `Mix.install` line to `mix.exs` causes `mix` commands like `mix deps.get` to error:
```
  (exit) exited in: GenServer.call(Hex.Registry.Server, {:open, []}, 60000)
     (EXIT) no process: the process is not alive or there’s no process currently associated with the given name, possibly because its application isn’t started
    (elixir 1.13.4) lib/gen_server.ex:1019: GenServer.call/3
    (hex 1.0.1) lib/hex/remote_converger.ex:28: Hex.RemoteConverger.converge/2
    (mix 1.13.4) lib/mix/dep/converger.ex:95: Mix.Dep.Converger.all/4
    (mix 1.13.4) lib/mix/dep/converger.ex:51: Mix.Dep.Converger.converge/4
    (mix 1.13.4) lib/mix/dep/fetcher.ex:16: Mix.Dep.Fetcher.all/3
    (mix 1.13.4) lib/mix/tasks/deps.get.ex:31: Mix.Tasks.Deps.Get.run/1
    (mix 1.13.4) lib/mix/task.ex:397: anonymous fn/3 in Mix.Task.run_task/3
    (mix 1.13.4) lib/mix/cli.ex:84: Mix.CLI.run_task/2
```

##### Solution
Be sure to include the call to `Application.ensure_all_started(:hex)` before calling `Mix.Install/2`, to explicitly ensure hex is started.

#### Issue: Commands like `mix local.hex --force` are failing (common for Travis):
```
** (MatchError) no match of right hand side value: {:error, {:hex, {'no such file or directory', 'hex.app'}}}
    mix.exs:1: (file)
    (mix 1.13.2) lib/mix/cli.ex:42: Mix.CLI.load_mix_exs/0
    (mix 1.13.2) lib/mix/cli.ex:29: Mix.CLI.proceed/1
The command "mix local.hex --force" failed and exited with 1 during .
```

##### Solution
This is because `mix.exs` needs to ensure hex is started, so the machine needs to install hex first before mix can run with the updated mix.exs
1. `cd` over to a directory without a `mix.exs`
    - Short and to the point, `cd` will take you to the home dir, which is unlikely to have this file
2. Run whichever mix commands were failing
    - Also run the commands necessary to authenticate with hex through mix, as they'll grant access to this and other private packages we need to `Mix.Install/2`
3. Run `cd -` to return to your previous directory, and proceed as usual

In `.travis.yml`, this usually looks something like
```yaml
install:
  - cd
  - mix do local.rebar --force, local.hex --force
  - mix hex.organization auth simplifi --key ${HEX_API_KEY}
  - cd -
```

In `scripts/elixir_release.sh`, this looks like
```bash
#!/bin/bash

set -ex

# auth for sifi hex packages
cd
mix hex.organization auth simplifi --key ${HEX_API_KEY}
cd -
# compile for production
```

#### Issue: The release build is failing to upload from Travis:
##### Solution
There may be a script trying to pull the version by reading mix.exs
A good solution to this that we've found is to look for and update these scripts:
- If they already have hex installed and authed, go ahead and use `mix app.version`
- In other cases, it may be cleaner to have the script call the binary, after it has been built, with the `version` argument
Such solutions can look like `VERSION=$(_build/prod/rel/cledos/bin/cledos version | cut -d ' ' -f2)`

## Testing
Testing is done by running `mix test`.

## Releasing
You should be using [git flow](https://simplifi.atlassian.net/wiki/spaces/RTB/pages/28855038) here.
However, since this repo enables simplified versioning, we have chosen for the moment not to have it depend on itself.

As such, after running `git flow release start <X.Y.Z>`, you must create a commit bumping the version in mix.exs before running `git flow release finish <X.Y.Z>`.
