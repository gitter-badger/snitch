defmodule Snitch.Data.Schema.CountryZone do
  @moduledoc """
  Models a Zone of Countrys.

  `CountryZone` is a "subtype" ie, it is a "concrete" `Zone` comprised of _only_
  `Country`s.
  """
  use Snitch.Data.Schema
  alias Snitch.Data.Schema.{Zone, Country}

  @typedoc """
  CountryZone struct.

  ## Fields

  * `zone_id` uniquely determines both `Zone` and `CountryZone`
  """
  @type t :: %__MODULE__{}

  schema "snitch_country_zones" do
    belongs_to(:zone, Zone)
    belongs_to(:country, Country)
    timestamps()
  end

  @update_fields ~w(country_id)a
  @create_fields [:zone_id | @update_fields]

  @doc """
  Returns a `Zone` changeset.
  """
  @spec changeset(t, map, :create | :update) :: Ecto.Changeset.t()
  def changeset(country_zone, params, :create) do
    country_zone
    |> cast(params, @create_fields)
    |> validate_required(@create_fields)
    |> foreign_key_constraint(:zone_id)
    |> foreign_key_constraint(:country_id)
  end

  def changeset(country_zone, params, :update) do
    country_zone
    |> cast(params, @update_fields)
    |> foreign_key_constraint(:country_id)
  end
end
