require_relative "ninja"

r1 =  Ninja::Rule.new("gcc -c $in -o $out")
b1 = Ninja::Build.new(r1, Ninja::Target.new("a1", ["b1", "c1"]), Ninja::Explicitly.new(["d"], "e"), Ninja::Implicitly.new("f"))
b2 = Ninja::Build.new(r1, Ninja::Target.new("a2", ["b2", "c2"]), Ninja::Explicitly.new(["d"], "e"))
Ninja.end_of_ninja(b1, b2)
