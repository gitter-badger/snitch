defmodule Mix.Tasks.Core.Resetdb do
  @moduledoc """
  Custom mix task to reset db.
  ```
    mix core.resetdb
  ```
  """
  use Mix.Task

  def run(_) do
    System.cmd(
      "mix",
      ["ecto.drop"],
      stderr_to_stdout: true,
      into: IO.stream(:stdio, :line)
    )

    System.cmd(
      "mix",
      ["ecto.create"],
      stderr_to_stdout: true,
      into: IO.stream(:stdio, :line)
    )

    System.cmd(
      "mix",
      ["ecto.migrate"],
      stderr_to_stdout: true,
      into: IO.stream(:stdio, :line)
    )
  end
end

defmodule Mix.Tasks.Core.Seed do
  @moduledoc """
    Custom mix task to seed db.
    ```
      mix core.seed
    ```
  """
  use Mix.Task

  def run(_) do
    Mix.Task.run("run", ["./apps/core/priv/repo/seeds.exs"])
  end
end
