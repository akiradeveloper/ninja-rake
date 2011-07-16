require 'helper'

def checkshell(s)
  
end

class TestNinjaRake < Test::Unit::TestCase
  # The Test is simple. If it doest raise error, it is OK.
  # It is better than nothing.
  should "not raise error" do
    puts Ninja.Rule("gcc -c $in -o $out").to_ninja_format
    puts Ninja.Rule("gcc -MMD -MF $out.d -c $in -o $out", "$out.d")
    r1 =  Ninja.Rule("gcc -MMD -MF $out.d -c $in -o $out", "$out.d")
    b0 = Ninja.Build(
      r1,
      Ninja.Target("a", ["b", "c"]),
      Ninja.Explicitly(["d"], "e"), Ninja.Implicitly("f"))
    b1 = Ninja.Build(r1, Ninja.Target("a", ["b", "c"]), Ninja.Explicitly(["d"], "e"), Ninja.Implicitly("f"))
    b2 = Ninja.Build(r1, Ninja.Target("a", ["b", "c"]), Ninja.Explicitly(["d"], "e"))
    puts b1.to_ninja_format
    puts b2.to_ninja_format
    puts Ninja.rules([b1, b2])
    puts Ninja.to_ninja_format([b1, b2])
  end

  should "not raise error 2" do
    checkshell("rake -P")
  end

  should "not raise error 3" do
    checkshell("rake \"ninja build\"")
  end

end

