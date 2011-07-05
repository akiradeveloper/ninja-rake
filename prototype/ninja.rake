require_relative "ninja"

r1 =  Ninja::Rule.new("gcc -c $in -o $out")
b1 = Ninja::Build.new(r1, Ninja::Target.new("a1", ["b1", "c1"]), Ninja::Explicitly.new(["d"], "e"), Ninja::Implicitly.new("f"))
b2 = Ninja::Build.new(r1, Ninja::Target.new("a2", ["b2", "c2"]), Ninja::Explicitly.new(["d"], "e"))

# compile the actual files
rule = Ninja::Rule.new("gcc -MMD -MF $out.d -lm -O3 -o $out -c $in", "$out.d")
b3 = Ninja::Build.new(
  rule,
  Ninja::Target.new("mylib.o"),
  Ninja::Explicitly.new("mylib.c"))

Ninja.end_of_ninja(b1, b2, b3)

