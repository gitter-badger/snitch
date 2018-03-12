defmodule Snitch.Data.Model.CountryZoneTest do
  use ExUnit.Case, async: true
  use Snitch.DataCase

  alias Snitch.Data.Model.CountryZone
  alias Snitch.Data.Schema.{Zone, CountryZoneMember, Country}

  @country_ids [1, 2, 3, 2]
  @expected_country_ids Enum.uniq(@country_ids)

  describe "create/3 and member_ids" do
    test "succeeds with valid country_ids" do
      assert {:ok, zone} = CountryZone.create("foo", "bar", @country_ids)

      assert @expected_country_ids ==
               Repo.all(
                 from(c in CountryZoneMember, where: c.zone_id == ^zone.id, select: c.country_id)
               )

      assert @expected_country_ids == CountryZone.member_ids(zone.id)
    end

    test "fails if some states are invalid" do
      assert {:error, :members, %{errors: errors}, %{zone: zone}} =
               CountryZone.create("foo", "bar", [1, 2, -1])

      assert nil == Repo.get(Zone, zone.id)
      assert errors == [country_id: {"does not exist", []}]
    end
  end

  describe "with country_zone" do
    setup :country_zone

    test "members/1 returns Country schemas", %{zone: zone} do
      states = Enum.map(@expected_country_ids, &Repo.get(Country, &1))
      assert states == CountryZone.members(zone.id)
    end

    test "delete/1 removes all members too", %{zone: zone} do
      {:ok, _} = CountryZone.delete(zone)
      assert [] = CountryZone.members(zone.id)
    end

    test "update/3 succeeds with valid country_ids", %{zone: zone} do
      assert {:ok, _} = CountryZone.update(zone, %{}, [3, 2, 5, 5, 4])
      country_ids = MapSet.new(CountryZone.member_ids(zone.id))

      assert [2, 3, 4, 5]
             |> MapSet.new()
             |> MapSet.equal?(country_ids)
    end

    test "update/3 succeeds with no states", %{zone: zone} do
      assert {:ok, _} = CountryZone.update(zone, %{}, [])
      assert [] = CountryZone.member_ids(zone.id)
    end

    test "update/3 fails with invalid states", %{zone: zone} do
      assert {:error, :added, %{errors: errors}, %{zone: updated_zone}} =
               CountryZone.update(zone, %{}, [6, -1])

      assert errors == [country_id: {"does not exist", []}]
      assert @expected_country_ids == CountryZone.member_ids(updated_zone.id)
    end
  end

  defp country_zone(_) do
    {:ok, zone} = CountryZone.create("foo", "bar", @country_ids)
    [zone: zone]
  end
end
