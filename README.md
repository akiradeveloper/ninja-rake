# ninja-rake
Make your Ninja more powerful with the power of Ruby on Rake Framework!

## Motivation
Ninja is a build tool brilliant ever however it lacks some paramount functionalities such as script descpriptiveness:
you can not use typical data structures (array, map, set etc) 
and general algorithms (map, filter, sort etc) equipped with the modern scripting languages in your raw Ninja script.
This makes Ninja hard to be deployed in your projects.

This is the result of the developer of Ninja decided not to provide these functinalities to keep Ninja simple as possible
and let users (you!) to generate Ninja file by our your scripting however,
I believe there should be some de-facto standard for scripting and I again believe it is Ruby that I love the most.

Using this ninja-rake library you can write Ninja code with Ruby language which enables
using plenty of data structures and algorithms in Ruby standard library.
Moreover, your script can easily collaborate with Rake which is
the state of the art framework for describing daily tasks including building softwares.

## Install

## Usage
```ruby
build = Build.new(
  Rule.new("gcc -c $in -o $out"), 
  Target.new("a.o"),
  Explicitly.new("a.c", "b.c"),
  Implicitly.new("c.c"))
create_ninja(build)
```
will produce a Rake task that create "default.ninja" file that is printed

~~~
rule xxx
  command = gcc -c $in -o $out
build a.o: xxx a.c b.c | c.c
~~~

## Roadmap
* Rule generator which enables to build GPGPU project written in CUDA 4.0

## Copyright
Copyright (c) 2011 Akira Hayakawa (@akiradeveloper)
