# ClearObject

`clear_object` helps you define your ruby objects(classes) without the need for a lot of boilerplate code.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'clear_object'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install clear_object

## Usage
Imagine the following ruby class:
```ruby
class User
  attr_reader :name, :email, :address

  def initialize(name = 'Jo', address, email = nil, *rest)
    @name = name
    @address = address
    @email = email
  end

  def location
    address.location
  end

  Address = Struct.new(city:, street:) do
    def location
     "#{city} #{street}"
    end
  end
end
```

clear_object gives you exactly the same code, but reduces the boilerplate

```ruby
class User
  extends ClearObject
  clear :name, default: 'Jo'
  clear :email, default: nil
  clear :address do
    clear :city, :address
    def location
      "#{city} #{street}"
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/clear_object. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ClearObject project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/clear_object/blob/master/CODE_OF_CONDUCT.md).
