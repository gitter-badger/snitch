defmodule Snitch.Data.Model.StateZoneTest do
  use ExUnit.Case, async: true
  use Snitch.DataCase

  alias Snitch.Data.Model.StateZone
  alias Snitch.Data.Schema.{Zone, StateZoneMember, State}

  @state_ids [1, 2, 3, 2]
  @expected_state_ids Enum.uniq(@state_ids)

  describe "create/3 and member_ids" do
    test "succeeds with valid state_ids" do
      assert {:ok, zone} = StateZone.create("foo", "bar", @state_ids)

      assert @expected_state_ids ==
               Repo.all(
                 from(s in StateZoneMember, where: s.zone_id == ^zone.id, select: s.state_id)
               )

      assert @expected_state_ids == StateZone.member_ids(zone.id)
    end

    test "fails if some states are invalid" do
      assert {:error, :members, %{errors: errors}, %{zone: zone}} =
               StateZone.create("foo", "bar", [1, 2, -1])

      assert nil == Repo.get(Zone, zone.id)
      assert errors == [state_id: {"does not exist", []}]
    end
  end

  describe "with state_zone" do
    setup :state_zone

    test "members/1 returns State schemas", %{zone: zone} do
      states = Enum.map(@expected_state_ids, &Repo.get(State, &1))
      assert states == StateZone.members(zone.id)
    end

    test "delete/1 removes all members too", %{zone: zone} do
      {:ok, _} = StateZone.delete(zone)
      assert [] = StateZone.members(zone.id)
    end

    test "update/3 succeeds with valid state_ids", %{zone: zone} do
      assert {:ok, _} = StateZone.update(zone, %{}, [3, 2, 5, 5, 4])
      state_ids = MapSet.new(StateZone.member_ids(zone.id))

      assert [2, 3, 4, 5]
             |> MapSet.new()
             |> MapSet.equal?(state_ids)
    end

    test "update/3 succeeds with no states", %{zone: zone} do
      assert {:ok, _} = StateZone.update(zone, %{}, [])
      assert [] = StateZone.member_ids(zone.id)
    end

    test "update/3 fails with invalid states", %{zone: zone} do
      assert {:error, :added, %{errors: errors}, %{zone: updated_zone}} =
               StateZone.update(zone, %{}, [6, -1])

      assert errors == [state_id: {"does not exist", []}]
      assert @expected_state_ids == StateZone.member_ids(updated_zone.id)
    end
  end

  defp state_zone(_) do
    {:ok, zone} = StateZone.create("foo", "bar", @state_ids)
    [zone: zone]
  end
end
