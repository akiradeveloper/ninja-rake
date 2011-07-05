# ninja-rake
Make your Ninja more powerful with the power of Ruby on Rake Framework!

## Motivation
Ninja is a build tool brilliant ever however it lacks some paramount functionalities such as script descpriptiveness:
you can not use typical data structures (for example array, map, set etc) 
and general algorithms (for example map, filter, sort etc) equipped with the modern scripting languages in your raw Ninja script.
This makes Ninja hard to be deployed into your projects.

This is the result of the developer of Ninja decided not to provide these functinalities to keep Ninja as simple as possible
and let users (like you!) to generate Ninja file by your own scripting however,
I believe there should be some de-facto standard for scripting and I again believe it is Ruby that I love the most.

Using this ninja-rake library you can write Ninja code with Ruby language which enables
using plenty of data structures and algorithms in Ruby standard library.
Moreover, your script can easily collaborate with Rake which is
the state of the art framework for describing daily tasks including building softwares.

## Install

## Usage

```ruby
rule = Ninja::Rule.new("gcc -c $in -o $out"), # rule have unique ID.
build1 = Ninja::Build.new(
  rule,
  Ninja::Target.new("a.o"),
  Ninja::Explicitly.new("a.c", "b.c"),
  Ninja::Implicitly.new("c.c"))
build2 = (rule, ...)
Ninja.end_of_ninja(build1, build2)  
```

will produce a Rake task that create "build.ninja" file that is written as

~~~
rule ID
  command = gcc -c $in -o $out
build1 a.o: ID a.c b.c | c.c
build2 ...: ID ...
~~~

## Roadmap
* Rule generator which enables to build GPGPU project written in CUDA 4.0.

## Copyright
Copyright (c) 2011 Akira Hayakawa (@akiradeveloper)
