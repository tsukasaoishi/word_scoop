# WordScoop

WordScoop will pick up keywords that have been pre-registered from the text.
WordScoop is very fast library. The average of registring 1 word time is 0.487 µs. The average of to search time is 1.248 ms.(Be performed on the Macbook air at 2012)


## Installation

Add this line to your application's Gemfile:

    gem 'word_scoop'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install word_scoop

## Usage

Register keywords

    keywords = WordScoop.new(["Ruby", "Rails"])

Add keyword

    keywords << "Tsukasa"

Pick up the keywords in a text

    keywords.search("I Love Ruby") #=> ["Ruby"]

## HTML text support

config replace URL base

    keyword.link_url = %Q|<a href="http://ja.wikipedia.org/wiki/%s">%s</a>|

Replace keyword to link

    keywords.filter_html("I Love Ruby") #=> %Q|I Love <a href="http://ja.wikipedia.org/wiki/Ruby">Ruby</a>|

## Rake command

compiling code

    $ bundle exec rake compile

run rspec

    $ bundle exec rake spec

run benchmark test

    $ bundle exec rake benchmark

## Contributing

1. Fork it ( https://github.com/[my-github-username]/word_scoop/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
