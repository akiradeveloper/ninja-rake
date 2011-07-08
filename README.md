# ninja-rake
Make your Ninja more powerful with the power of Ruby on Rake Framework!

## Motivation
Ninja(https://github.com/martine/ninja) is a build tool brilliant ever however it lacks some paramount functionalities such as script descpriptiveness:
you can not use typical data structures (for example array, map, set etc) 
and general algorithms (for example map, filter, sort etc) equipped with the modern scripting languages in your raw Ninja script.
This makes Ninja hard to be deployed into your projects.

This is the result of the developer of Ninja decided not to provide these functinalities to keep Ninja as simple as possible
and fall back on users to generate Ninja file by your own scripting however,
I believe there should be some de facto standard for scripting and I again believe it is Ruby that I love the most.

Using this ninja-rake library you can write Ninja code with Ruby language which enables
using plenty of data structures and algorithms provided in Ruby standard library.
Moreover, your script can easily collaborate with Rake which is
the state of the art framework for describing daily tasks including building softwares.

## Install

ninja-rake is registered in rubygems.org.
Therefore you can install it only by

~~~
gem install ninja-rake
~~~

To install ninja itself,

- First git clone the ninja repository to any location in your computer.
- install ninja ( just 'sh bootstrap.sh' ).
- configure PATH variable so you can use ninja.

## Usage

```ruby
require "ninja"

rule = Ninja.Rule("gcc -c $in -o $out"), # rule have unique ID.
build1 = Ninja.Build(
  rule,
  Ninja.Target("a.o"),
  Ninja.Explicitly("a.c", "b.c"),
  Ninja.Implicitly("c.c"))
build2 = Ninja.Build(rule, ...)

Ninja.end_of_ninja(build1, build2)
```

will produce a Rake task that create "build.ninja" file that is written as

~~~
rule ID
  command = gcc -c $in -o $out
build1 a.o: ID a.c b.c | c.c
build2 ...: ID ...
~~~

For closer look into ninja-rake, see example. 

## Roadmap
- Rule generator which enables to build GPGPU project written in CUDA 4.0.

## Contributing to ninja-rake
 
- Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
- Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
- Fork the project
- Start a feature/bugfix branch
- Commit and push until you are happy with your contribution
- Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
- Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright
Copyright (c) 2011 Akira Hayakawa (@akiradeveloper). 
See LICENSE.txt for further details.
