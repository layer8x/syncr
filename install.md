---
layout: flow
---

# Installing Ruby
Syncr is distributed as a RubyGem, and as such you will need Ruby as well as RubyGems to install Syncr. Syncr requires at least Ruby version 1.9.3, although a newer version such as 2.1 is recommended. You can use a pre-built packaged Ruby or use [RVM](https://rvm.io/) to install Ruby. Let's go over using a pre-built package first.

## Linux
Your distribution's package manager _should_ have Ruby in it. When installing Ruby remember that Syncr requires 1.9 Ruby; some distributions still ship with 1.8 in the package manager. If you have confirmed that your distribution's package manager has at least 1.9 Ruby, simply install Ruby. RubyGems ships with Ruby by default but some package managers extract RubyGems into its own package usually called `ruby-rubygems` or just `rubygems`.
{% include code_begin %}
{% highlight bash %}
[sudo] apt-get install ruby
[sudo] dnf install ruby
{% endhighlight %}
{% include code_end %}

## OS X
I wouldn't trust OS X's default Ruby farther than I could throw a WOPR computer. Therefore use [Homebrew](http://brew.sh/) or [RVM](https://rvm.io/) to install Ruby.

{% include code_begin %}
{% highlight bash %}
[sudo] brew install ruby
{% endhighlight %}
{% include code_end %}

## Windows
Syncr currently doesn't support Windows and Ruby support on Windows is flaky. I've found the best way to install Ruby is to use [RubyInstaller for Windows](http://rubyinstaller.org/)

## RVM
[RVM](https://rvm.io/) works on most, if not all, Unixes (Unics?, Unixs?). Open a Terminal window and paste this in. Always be careful of pasting commands from the internet into your terminal prompt.
{% include code_begin %}
{% highlight bash %}
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby
{% endhighlight %}
{% include code_end %}

This will install the latest Ruby to your home directory as well as RubyGems.

# Installing Syncr
Getting Ruby installed is the hardest part. After that Syncr is dead simple to install. Make sure the Ruby you installed is in your [$PATH](http://lmgtfy.com/?q=how+to+change+%24PATH), and run this command:

{% include code_begin %}
{% highlight bash %}
gem install syncr
{% endhighlight %}
{% include code_end %}

That's it! Now you can get on with configuration!
