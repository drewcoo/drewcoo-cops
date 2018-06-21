# Drewcoo-Cops

[![TravisCI](https://api.travis-ci.org/drewcoo/drewcoo-cops.svg)](https://travis-ci.org/drewcoo/drewcoo-cops)
[![CircleCI](https://circleci.com/gh/drewcoo/drewcoo-cops.svg?style=shield)](https://circleci.com/gh/drewcoo/drewcoo-cops)
[![AppVeyor](https://ci.appveyor.com/api/projects/status/gxl0sxpc33wcfjjb?svg=true)](https://ci.appveyor.com/project/drewcoo/drewcoo-cops/history)
[![Coverage Status](https://coveralls.io/repos/github/drewcoo/drewcoo-cops/badge.svg?branch=master)](https://coveralls.io/github/drewcoo/drewcoo-cops?branch=master)
[![Gem Version](https://badge.fury.io/rb/drewcoo-cops.svg)](https://badge.fury.io/rb/drewcoo-cops)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/1351580f879346e589d9c4f908b53f05)](https://www.codacy.com/app/drewcoo/drewcoo-cops?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=drewcoo/drewcoo-cops&amp;utm_campaign=Badge_Grade)

# Who? What?

Hi, I'm Drew, drewcoo on [Github](https://github.com/drewcoo) and this is my
collection of custom [RuboCop](http://batsov.com/rubocop/) cops. Well, ok, so
there's only one so far but I expect the collection to grow. Right now there's
a cop to find sleep methods.

## Why Sleeping Is Bad

You'll see a lot of test code peppered with sleeps for MAGIC_SECONDS, and
DIFFERENT_MAGIC_SECONDS, and loops while STILL_OTHER_MAGIC_SECONDS time goes
by. Often this is punctuated with some exception catching and throwing which
also takes up magical amounts of time of its own. All of these things
constantly need to be adjusted for the competing frenemies, speed and
stability, as the underlying code, which is probably messy UI code, shifts
mercilessly underfoot. This is not pretty, my fellow testers.

I'd like to suggest having common polling code somewhere in your codebase.
Call that whenever you need to wait for something or check if something's ready.
Pick a quick polling time (10ths of a sec or less), a long-enough timeout (on
the order of seconds), and pass a proc or lambda with the checks into your
polling method.

Ok. Are you with me so far? Now get rid of all that buggy nightmare of sleeps.
Get rid of all of them except the one in your shiny new polling method. You
can run this cop to check for stray sleeps.

### Dirty Secrets

I sometimes do horrible things to code. I even insert sleeps when I'm trying
to debug something the quick and dirty way. My secret is that I usually have
something like this gem to know what to clean up afterward so that my code
looks clean.

## Installation

Add this line to your application's Gemfile:

    ```ruby
    gem 'drewcoo-cops'
    ```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install drewcoo-cops

## Usage

In your .rubocop.yml just do this to have RuboCop yell at you for all of
your sleeps:

    ```ruby
    require: drewcoo-cops
    ```
And shut the cops up for that one special polling method, which is what you
use instead of peppering your code with sleeps and making an unmaintainable
mess, right?

    ```ruby
    # rubocop:disable Style/SleepCop
    def polling_method
      some stuff
      sleep A_NUMBER_OF_SECONDS
      maybe some other stuff
    end
    # rubocop:enable Style/SleepCop
    ```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/drewcoo/drewcoo-cops.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
