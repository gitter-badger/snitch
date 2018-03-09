defmodule Snitch.Data.Schema.StateZoneTest do
  use ExUnit.Case, async: true
  use Snitch.DataCase

  import Snitch.Factory

  alias Snitch.Data.Schema.StateZone

  setup :state_zones
  setup :country_zones

  describe "StateZone records" do
    test "refer only state type zones (uniquely)", context do
      %{state_zones: [state_zone]} = context
      %{zone: zone} = state_zone
      new_state_zone = StateZone.changeset(%StateZone{state_id: 1}, %{zone_id: zone.id}, :create)

      assert {:error, %{errors: errors}} = Repo.insert(new_state_zone)
      assert errors == [zone_id: {"has already been taken", []}]
    end

    test "don't refer a country zone", context do
      %{country_zones: [country_zone]} = context
      %{zone: zone} = country_zone
      new_state_zone = StateZone.changeset(%StateZone{state_id: 1}, %{zone_id: zone.id}, :create)

      assert {:error, %Ecto.Changeset{errors: errors}} = Repo.insert(new_state_zone)
      assert errors == [zone_id: {"does not refer a state zone", []}]
    end
  end
end
