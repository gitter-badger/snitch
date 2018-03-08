defmodule Snitch.Data.Schema.Zone do
  @moduledoc """
  Models a Zone.

  `Zone` is a "supertype" ie, it is polymorphic. A zone may comprise of states
  (`Snitch.Data.Schema.StateZone`), or countries
  (`Snitch.Data.Schema.CountryZone`).
  """

  use Snitch.Data.Schema

  @typedoc """
  Zone struct.

  ## Fields

  * `zone_type` is a discriminator, the only valid values are the characters `S`
    and `C`.
  """
  @type t :: %__MODULE__{}

  schema "snitch_zones" do
    field(:name, :string)
    field(:description, :string)
    field(:zone_type, :string)
    timestamps()
  end

  @update_fields ~w(name description)a
  @create_fields [:type | @update_fields]

  @doc """
  Returns a `Zone` changeset.
  """
  @spec changeset(t, map, :create | :update) :: Ecto.Changeset.t()
  def changeset(zone, params, :create) do
    zone
    |> cast(params, @create_fields)
    |> validate_required(@create_fields)
    |> validate_discriminator(:type, ["S", "C"])
  end

  def changeset(zone, params, :update) do
    zone
    |> cast(params, @update_fields)
  end

  defp validate_discriminator(%{valid?: true} = changeset, key, permitted) do
    {_, discriminator} = fetch_field(changeset, key)

    if discriminator in permitted do
      changeset
    else
      changeset
      |> add_error(:payment_type, "'#{discriminator}' is invalid", validation: :inclusion)
    end
  end
end
