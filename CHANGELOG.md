# Shoppe Release Notes

This document outlines key changes which are introduced in each version. The full commit history can be found [on GitHub](http://github.com/tryshoppe/core).

## v0.0.12

* Don't persist order item pricing until the order is confirmed. While an order is being built
  all prices will be calculated live from the parent product and these values will be persisted
  (in case of any future changes to the product) at the point of confirmation. This makes way for
  changes to the tax rates based on order itself to be introduced.

## v0.0.11

* All countries are now stored in the database which will allow for delivery & tax rate decisions to
  be made as appropriate. There is now no need to use things like `country_select` in applications.
  Any existing order which has a country will have this data lost. A rake task method is provide to
  allow a default set of countries to be imported (`rake shoppe:import_countries`). There is
  currently no way to manage countries from the Shoppe interface.

* Items with prices are now assigned to a `Shoppe::TaxRate` object rather than specifying a
  percentage on each item manually. This allows rates to be changed globally and allows us to change
  how tax should be charged based
  on other factors (country?).

## v0.0.10

* Improved stock control so that a journal is kept of all stock movement in and out of the system.
  There is no need to make any changes to your application however all existing stock levels will be
  removed when upgrading to this version.