defmodule Snitch.Data.Schema.StateZone do
  @moduledoc """
  Models a Zone of States.

  `StateZone` is a "subtype" ie, it is a "concrete" `Zone` comprised of _only_
  `State`s.
  """
  use Snitch.Data.Schema
  alias Snitch.Data.Schema.{Zone, State}

  @typedoc """
  StateZone struct.

  ## Fields

  * `zone_id` uniquely determines both `Zone` and `StateZone`
  """
  @type t :: %__MODULE__{}

  schema "snitch_state_zones" do
    belongs_to(:zone, Zone)
    belongs_to(:state, State)
    timestamps()
  end

  @update_fields ~w(state_id)a
  @create_fields [:zone_id | @update_fields]

  @doc """
  Returns a `Zone` changeset.
  """
  @spec changeset(t, map, :create | :update) :: Ecto.Changeset.t()
  def changeset(state_zone, params, :create) do
    state_zone
    |> cast(params, @create_fields)
    |> validate_required(@create_fields)
    |> foreign_key_constraint(:zone_id)
    |> unique_constraint(:zone_id)
    |> foreign_key_constraint(:state_id)
    |> check_constraint(
      :zone_id,
      name: :state_zone_exclusivity,
      message: "does not refer a state zone"
    )
  end

  def changeset(state_zone, params, :update) do
    state_zone
    |> cast(params, @update_fields)
    |> foreign_key_constraint(:state_id)
  end
end
