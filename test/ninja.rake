require "ninja"

r1 = Ninja.Rule("gcc -c $in -o $out")
b1 = Ninja.Build(r1, Ninja.Target("a1", ["b1", "c1"]), Ninja.Explicitly(["d"], "e"), Ninja.Implicitly("f"))
b2 = Ninja.Build(r1, Ninja.Target("a2", ["b2", "c2"]), Ninja.Explicitly(["d"], "e"))

# compile the actual files
# About gcc M flags: When used with the driver options -MD or -MMD, -MF overrides the default dependency output file.
rule = Ninja.Rule("gcc -MMD -MF $out.d -O3 -o $out $in -lm", "$out.d")
b3 = Ninja.Build(
  rule,
  Ninja.Target("mylib"),
  Ninja.Explicitly("mylib.c"))

Ninja.end_of_ninja(b1, b2, b3)
