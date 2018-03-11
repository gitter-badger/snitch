defmodule Snitch.Seed.CountryState do
  @moduledoc """
  This module has functions to create and insert seed data for the state and the country
  entitites.
  """

  alias Worldly.Country, as: WorldCountry
  alias Worldly.Region, as: WorldRegion
  alias Snitch.Repo

  def seed_countries_and_states! do
    insert_countries() 
  end

  def insert_countries do
    wc = WorldCountry.all()
    all_countries = Enum.map(wc, fn country -> to_param(country) end)
    {_ ,countries_ids} = Repo.insert_all("snitch_countries", 
                                        all_countries, 
                                        on_conflict: :nothing, 
                                        returning: [:id])    
    country_id = Enum.map(countries_ids, fn (x) -> x.id end)
    
    wc 
    |> Enum.map(&WorldRegion.regions_for/1)
    |> Enum.zip(country_id)
    |> Enum.map(fn {statelist, id} -> 
                    Enum.map(statelist, fn state -> 
                          to_param(state, id) end) end)
    |> List.flatten
    |> insert_and_map_states  

  end

  def insert_and_map_states(states) do
    Repo.insert_all("snitch_states", states, on_conflict: :nothing)    
  end
  
  defp to_param(%WorldCountry{
      name: name,
      alpha_2_code: iso,
      alpha_3_code: iso3,
      numeric_code: numcode,
      has_regions: has_regions
    }) do
    %{
      name: name,
      iso: iso,
      iso3: iso3,
      numcode: numcode,
      states_required: has_regions,
      iso_name: String.upcase(name),
      inserted_at: Ecto.DateTime.utc(),
      updated_at: Ecto.DateTime.utc()  
    }
  end

  defp to_param(%WorldRegion{code: abbr, name: name}, id) do
    %{
      abbr: to_string(abbr), 
      name: to_string(name),
      country_id: id,
      inserted_at: Ecto.DateTime.utc(),
      updated_at: Ecto.DateTime.utc()  
    }
  end
end
