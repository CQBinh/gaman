# Gaman
[![Gem Version](https://badge.fury.io/rb/gaman.svg)](https://badge.fury.io/rb/gaman)

Required:

- `ruby` 1.9 or greater (see https://www.ruby-lang.org/en/installation )
- `rubygems` (included with ruby; see https://github.com/rubygems/rubygems )

Recommended:

- `rvm` for controling your versions of ruby (see: https://github.com/rvm/rvm )

## Installation
Install as you would any other ruby gem:

    $ gem install gaman

## Using
### List all ssh keys

    $ gaman list

### Switch to a ssh key

    $ gaman switch

And then follow the inline-instruction.

### Create new ssh key

    $ gaman new -e your_email@domain.com

### Check current user that connect to github via ssh

    $ gaman current_user

## Contributors
[@at-binhcq](https://github.com/at-binhcq) from [AsianTech](http://asiantech.vn) with love.
## Contributing

1. Fork [the project](https://github.com/AT-RubyRacer/gaman)
2. Create your feature branch (`git checkout -b my-awesome-feature`)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new pull request with a description of your changes

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Thank give
Special thank to [@vinhnglx](https://github.com/vinhnglx) and [@Nguyenanh](https://github.com/Nguyenanh) for helping me on this project.
