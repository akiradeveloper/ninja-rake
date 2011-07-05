require "set"
require "uuidtools"

def create_UUID
  UUIDTools::UUID.random_create
end

class Rule
  def initialize(rule_desc)
    @rule_desc = rule_desc
    @unique_name = create_UUID
  end

  def unique_name
    @unique_name
  end
  
  def to_ninja_format
"""
rule #{unique_name}
  command = #{@rule_desc}
"""
  end

  def name
    @unique_name
  end
end

class Target
  def initialize(*xs)
    @dep = xs.flatten
  end

  def to_ninja_format
    @dep.join " "
  end
end

class Explicitly
  def initialize(*xs)
    @dep = xs.flatten
  end

  def to_ninja_format
    "#{@dep.join(" ")}"
  end
end

class Implicitly
  def initialize(*xs)
    @dep = xs.flatten
  end

  def to_ninja_format
    "| #{@dep.join(" ")}"
  end
end

class Build
  def initialize(rule, target, explicit_dep, implicit_dep=nil)
    @rule = rule
    @target = target
    @explicit_dep = explicit_dep
    @implicit_dep = implicit_dep
    # order-only dep is not supported because I do not get how we need it.
  end

  def get_rule_object
    @rule
  end

  def implicit_dep_line
    unless @implicit_dep == nil
      @implicit_dep.to_ninja_format
    else
      ""
    end
  end

  def to_ninja_format
"""
build #{@target.to_ninja_format}: #{@rule.name} #{@explicit_dep.to_ninja_format} #{implicit_dep_line}
"""
  end
end

def __to_ninja_format(xs)
  xs.map{ |x| x.to_ninja_format }.join "\n\n"
end

def rules(ninjas)
  __rules = ninjas.map { |x| x.get_rule_object } 
  Set.new(__rules).to_a
end

def to_ninja_format(ninjas)
  xs = (rules(ninjas) + ninjas).flatten
  __to_ninja_format(xs)
end

def create_ninja_file(*ninjas)
  namespace ninja do
    task :craete_ninja_file do
      f = File.new("default.ninja")
      f.write( to_ninja_format(ninja) )
      f.close
    end
  end
end

if __FILE__ == $0
  puts Rule.new("gcc -c $in -o $out").to_ninja_format

  r1 =  Rule.new("gcc -c $in -o $out")
  b1 = Build.new(r1, Target.new("a", ["b", "c"]), Explicitly.new(["d"], "e"), Implicitly.new("f"))
  b2 = Build.new(r1, Target.new("a", ["b", "c"]), Explicitly.new(["d"], "e"))
  puts b1.to_ninja_format
  puts b2.to_ninja_format
  puts rules([b1, b2])
  puts to_ninja_format([b1, b2])
end

def create_rake_tasks()
  namespace :ninja do

    task "default.ninja" => "ninja.rake" do 
      sh "rake -f ninja.rake ninja:create_ninja_file"
    end

    task :build => "default.ninja" do
      sh "ninja build default.ninja" # really ? I am not sure.
    end
    
    task :clean do
      p "clean"
    end

    # may not needed
    task :query do
      p "task"
    end

    # may not needed
    task :browse do
      p "browse"
    end
  end
end

create_rake_tasks
