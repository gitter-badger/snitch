# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Snitch.Repo.insert!(%Snitch.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# seeds countries and states entity
Snitch.Seed.CountryState.seed_countries_and_states!()

# seed payment methods
Snitch.Seed.PaymentMethods.seed!()
