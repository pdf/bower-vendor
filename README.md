# BowerVendor

Vendor the bower assets you want for Ruby on Rails.  Inspired by [bower-installer](https://github.com/blittle/bower-installer).

## Installation

Add this line to your Rails application's Gemfile:

```ruby
gem 'bower-vendor'
```

And then execute:

```shell
bundle
rails generate bower_vendor:configure
```

## Usage

Add bower packages to the `bower.json` file in your Rails root as normal, then
execute:

```shell
rails generate bower_vendor:install
```

To automatically vendor files specified by the bower package's `main` attribute
to the appropriate vendor directory.

Files are vendored based on file extension under:

`vendor/assets/(javascripts|stylesheets|images|media)/[package-name]`

Currently supported file extensions are:
* `javascripts`: `.js` `.coffee`
* `stylesheets`: `.css` `.scss` `.sass` `.less`
* `images`: `.gif` `.png` `.jpg` `.svg`
* `media`: `.*` (everything else)

The following generators are available:

### Available Generators

`rails generate bower_vendor:install [options]`

    Options:
      [--update]                    # Update bower assets (ie - `bower update`)
      [--skip-git-ignore]           # Add vendored bower asset package directories to .gitignore
      [--force-clean]               # Clean vendored bower assets without prompting
      [--skip-clean]                # Skip cleaning vendored bower assets
      [--include-dev-dependencies]  # Include bower devDependencies
     
    Runtime options:
      -f, [--force]    # Overwrite files that already exist
      -p, [--pretend]  # Run but do not make any changes
      -q, [--quiet]    # Suppress status output
      -s, [--skip]     # Skip files that already exist
     
    Vendor bower assets based on bower.json

`rails generate bower_vendor:clean [options]`

    Options:
      [--force]   # Delete vendored bower assets without prompting
      [--cached]  # Delete only the bower cache from tmp/bower_components
     
    Runtime options:
      -p, [--pretend]  # Run but do not make any changes
      -q, [--quiet]    # Suppress status output
      -s, [--skip]     # Skip files that already exist
     
    Cleans bower assets (CAUTION: Vendored asset directories for all bower packages will be deleted!)

### Configuring installed assets

Take the following example bower package:

```json
{
  "name": "widgets",
  "repo": "pdf/widgets",
  "description": "Now with more widgets!",
  "version": "0.0.1",
  "main": [
    "build/dir/js/widgets.js",
    "build/dir/css/widgets.css",
  ]
}
```

Let's add `widgets` to our application's `bower.json`, like so:

```json
{
  "dependencies": {
    "widgets": "~0.0.1"
  }
}
```

This is a contrived example, but it exists in the real world - if we were to
install this using bower directly, we'd end up with some pretty ugly paths to
reference in our application.  It might look something like this:

    components/widgets/build/dir/js/widgets.js
    components/widgets/build/dir/js/widgets-super.js
    components/widgets/build/dir/css/widgets.css
    components/widgets/src/cruft/widgets.coffee
    components/widgets/src/widgets.scss
    components/widgets/.ilikedonuts

However, if we instead vendor the bower package by executing
`rails g bower_vendor:install --force-clean`, we end up with just the following
files added to our project space:

    vendor/assets/javascripts/widgets/widgets.js
    vendor/assets/stylesheets/widgets/widgets.css

Much nicer.

Simply `require` them in your `application.js` or `application.css`:

```javascript
//= require 'widgets/widgets'
```

### Advanced bower.json
(Hat-tip to [bower-installer](https://github.com/blittle/bower-installer) for the inspiration)

If the bower package's `main` attribute does not include all the files you want
to vendor (or files you want to omit from vendoring), you can override the
vendored files using a `sources` attribute with a key of the package name,
containing an array of source files to install, like so:

```json
{
  "dependencies": {
    "widgets": "~0.0.1"
  },
  "sources": {
    "widgets": [
      "build/dir/js/widgets.js",
      "build/dir/js/widgets-super.js",
      "build/dir/css/widgets.css"
    ]
  }
}
```

Which will result in the following files being vendored:

    vendor/assets/javascripts/widgets/widgets.js
    vendor/assets/javascripts/widgets/widgets-super.js
    vendor/assets/stylesheets/widgets/widgets.css

You can also override the destination path/filename, by using a hash of source
paths to destinations instead of an array, like so:

```json
{
  "dependencies": {
    "widgets": "~0.0.1"
  },
  "sources": {
    "widgets": {
      "build/dir/js/widgets.js": "widgets.js",
      "build/dir/js/widgets-super.js": "super/widgets-super.js",
      "build/dir/css/widgets.css": "my_widgets.css"
    }
  }
}
```

Resulting in the following:

    vendor/assets/javascripts/widgets/widgets.js
    vendor/assets/javascripts/widgets/super/widgets-super.js
    vendor/assets/stylesheets/widgets/my_widgets.css

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
