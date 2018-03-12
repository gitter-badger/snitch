defmodule Snitch.Data.Schema.CountryZoneMemberTest do
  use ExUnit.Case, async: true
  use Snitch.DataCase

  import Snitch.Factory

  alias Snitch.Data.Schema.CountryZoneMember

  describe "CountryZoneMember records" do
    test "refer only country type zones" do
      country_zone = insert(:zone, zone_type: "C")

      new_country_zone =
        CountryZoneMember.changeset(
          %CountryZoneMember{country_id: 1},
          %{zone_id: country_zone.id},
          :create
        )

      assert {:ok, _} = Repo.insert(new_country_zone)
    end

    test "don't refer a state zone" do
      state_zone = insert(:zone, zone_type: "S")

      new_country_zone =
        CountryZoneMember.changeset(
          %CountryZoneMember{country_id: 1},
          %{zone_id: state_zone.id},
          :create
        )

      assert {:error, %Ecto.Changeset{errors: errors}} = Repo.insert(new_country_zone)
      assert errors == [zone_id: {"does not refer a country zone", []}]
    end
  end
end
