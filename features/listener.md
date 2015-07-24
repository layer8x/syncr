---
layout: feature
---

Listener
=======

Listener automatically listen for file changes and copy files.

#### Simple example


{% include code_with_path_begin path="~/.config/syncr.rb" %}
  {% highlight ruby %}
  listen '~/Code', to: 'ssh://backup-server:/mnt/backups/'
  {% endhighlight %}
{% include code_end %}

## Sync modes
There are two modes of operation for Listener: one-way and two-way. One-way is the default mode.
One-way sync means that Listener will only listen for changes on one end and not on the other end. Two-way means that Listener will listen for changes on both ends.

{% include alert_info_begin %}
  <b>Note:</b> Currently Listener cannot support two way syncing with remote clients such as SSH
{% include alert_end %}

## Code usage

You can use Listener in code by calling Syncr::Listener.new or Syncr::Listener.start

#### Using .start

Calling .start will instantiate a new Listener object and start it.

{% include code_begin %}
  {% highlight ruby %}
listener = Syncr::Listener.start local: '/tmp/origin/path/', external: '/tmp/destination/path/'
# => <#Syncr::Listener...>

# Code here to do stuff

listener.stop # Stops listeners
  {% endhighlight %}
{% include code_end %}
