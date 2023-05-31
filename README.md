# Finch API Demo

This demo is built in rails, which is overkill. But it should be straight forward to set up locally.

Start with the usual git clone `git clone git@github.com:myblake/finch_api_demo.git` in the directory you want to install into.

Make sure you have ruby >= 3.0.0, if not check out [RVM installation here](https://rvm.io/rvm/install) or use the ruby version manager of your choice.

Once done you should be able to run `bundle` and `rails s` to run the application locally on port 3000 provided it's not in use.

This application does not use the database or have tests, Rails will default to sqlite and so it shouldn't require any of the typical database set up one often sees with rails apps.

There are no real dependencies beyond the rails default gems and HTTParty, all of which bundle should handle.
