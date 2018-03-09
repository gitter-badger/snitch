defmodule Snitch.Factory.Zone do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      alias Snitch.Data.Schema.{Zone, StateZone, CountryZone}

      def zone_factory do
        %Zone{
          name: sequence("area", fn area_code -> "-#{area_code + 50}" end),
          description: "Does area-51 exist?"
        }
      end

      def state_zone_factory do
        %StateZone{
          zone: build(:zone, zone_type: "S")
        }
      end

      def country_zone_factory do
        %CountryZone{
          zone: build(:zone, zone_type: "C")
        }
      end

      def state_zones(context) do
        count = Map.get(context, :state_zone_count, 1)
        [state_zones: insert_list(count, :state_zone, state_id: 1)]
      end

      def country_zones(context) do
        count = Map.get(context, :state_zone_count, 1)
        [country_zones: insert_list(count, :country_zone, country_id: 1)]
      end
    end
  end
end
