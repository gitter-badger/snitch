defmodule Snitch.Data.Schema.CountryZoneTest do
  use ExUnit.Case, async: true
  use Snitch.DataCase

  import Snitch.Factory

  alias Snitch.Data.Schema.CountryZone

  setup :state_zones
  setup :country_zones

  describe "CountryZone records" do
    test "refer only country type zones (uniquely)", context do
      %{country_zones: [country_zone]} = context
      %{zone: zone} = country_zone

      new_country_zone =
        CountryZone.changeset(%CountryZone{country_id: 1}, %{zone_id: zone.id}, :create)

      assert {:error, %{errors: errors}} = Repo.insert(new_country_zone)
      assert errors == [zone_id: {"has already been taken", []}]
    end

    test "don't refer a country zone", context do
      %{state_zones: [state_zone]} = context
      %{zone: zone} = state_zone

      new_country_zone =
        CountryZone.changeset(%CountryZone{country_id: 1}, %{zone_id: zone.id}, :create)

      assert {:error, %Ecto.Changeset{errors: errors}} = Repo.insert(new_country_zone)
      assert errors == [zone_id: {"does not refer a country zone", []}]
    end
  end
end
