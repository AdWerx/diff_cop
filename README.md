# DiffCop

Run rubocop on the files you've staged in git and only see the offenses on the lines that you've changed or modified. It's like HoundCI, but local.

Example Output:

`git diff --cached --diff-filter=AM -p`

```
diff --git a/lib/diff_cop/version.rb b/lib/diff_cop/version.rb
index ede38dd..e7e71a3 100644
--- a/lib/diff_cop/version.rb
+++ b/lib/diff_cop/version.rb
@@ -1,3 +1,6 @@
 class DiffCop
-  VERSION = '0.1.0'.freeze
+  VERSION =       '0.1.0'.freeze
+
+  def some_method( args)
+    end
 end
```

And then after running `diffcop`:

```
DiffCop Offenses:
=====================

lib/diff_cop/version.rb:2:

    +  VERSION =       '0.1.0'.freeze

    Operator `=` should be surrounded by a single space.
    Unnecessary spacing detected.


lib/diff_cop/version.rb:4:

    +  def some_method( args)

    Space inside parentheses detected.


lib/diff_cop/version.rb:5:

    +    end

    `end` at 5, 4 is not aligned with `def` at 4, 2.
```


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'diff_cop'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install diff_cop

## Usage

Stage some files with `git add {files}` and then run `diffcop` in your git root. Rubocop will run only against the file that you've staged and it will only output the offenses on the lines that you've changed or added.

This attempts to replicate the behavior of a HoundCI locally so that you can fix your linting offenses before pushing to remote :]

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Tests

`rspec`

## Contributing

1. Fork it ( https://github.com/[my-github-username]/diff_cop/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
3.5 Write some passing tests
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## HoundCI

[always in style](https://houndci.com)
