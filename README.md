# Syncr

a sort-of front-end for Rsync

[![Build Status](https://travis-ci.org/layer8x/syncr.svg)](https://travis-ci.org/layer8x/syncr)
+[![Stories in Ready](https://badge.waffle.io/layer8x/syncr.png?label=ready&title=Ready)](https://waffle.io/layer8x/syncr)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'syncr'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install syncr

## Usage
```ruby
# Simple example
Syncr.start(local: '/home/user/Projects', external: 'backup-server:/backups/Projects')

# More advanced example
# NOTE: Two way syncing does not work with remote directories, so not over SSH
s = Syncr.new(local: '/home/user/Projects', external: '/mnt/backup/Projects', two_way_syncing: true)
s.start
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/layer8x/syncr.
