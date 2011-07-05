require_relative "ninja"

r1 =  Ninja::Rule.new("gcc -c $in -o $out")
b1 = Ninja::Build.new(r1, Ninja::Target.new("a1", ["b1", "c1"]), Ninja::Explicitly.new(["d"], "e"), Ninja::Implicitly.new("f"))
b2 = Ninja::Build.new(r1, Ninja::Target.new("a2", ["b2", "c2"]), Ninja::Explicitly.new(["d"], "e"))

# compile the actual files
# About gcc M flags: When used with the driver options -MD or -MMD, -MF overrides the default dependency output file.
rule = Ninja::Rule.new("gcc -MMD -MF $out.d -O3 -o $out $in -lm", "$out.d")
b3 = Ninja::Build.new(
  rule,
  Ninja::Target.new("mylib"),
  Ninja::Explicitly.new("mylib.c"))

Ninja.end_of_ninja(b1, b2, b3)

