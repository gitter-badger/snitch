defmodule Snitch.Data.Schema.StateZoneMemberTest do
  use ExUnit.Case, async: true
  use Snitch.DataCase

  import Snitch.Factory

  alias Snitch.Data.Schema.StateZoneMember

  describe "StateZoneMember records" do
    test "refer only state type zones" do
      state_zone = insert(:zone, zone_type: "S")

      new_state_zone =
        StateZoneMember.changeset(
          %StateZoneMember{state_id: 1},
          %{zone_id: state_zone.id},
          :create
        )

      assert {:ok, _} = Repo.insert(new_state_zone)
    end

    test "don't refer a country zone" do
      country_zone = insert(:zone, zone_type: "C")

      new_state_zone =
        StateZoneMember.changeset(
          %StateZoneMember{state_id: 1},
          %{zone_id: country_zone.id},
          :create
        )

      assert {:error, %Ecto.Changeset{errors: errors}} = Repo.insert(new_state_zone)
      assert errors == [zone_id: {"does not refer a state zone", []}]
    end
  end
end
