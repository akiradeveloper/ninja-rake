require "ninja"

# this rule instance cares the implicit dependencies of $out object.
# the implicit dependencies will be generated by -MMD -MF flag in $out.d
rule = Ninja.Rule("gcc -MMD -MF $out.d -O3 -o $out $in -lm", "$out.d")

# build description that will create mylib from mylib.c
# mylib.c depends implicitly on mylib.h. 
build = Ninja.Build(
  rule,
  Ninja.Target("mylib"),
  Ninja.Explicitly("mylib.c"))

# you must declare that you will make .ninja file with the build rules above.
Ninja.end_of_ninja(build)
