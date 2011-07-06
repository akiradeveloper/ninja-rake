require "set"
require "uuidtools"

module Ninja

  DEFAULT_NINJA_FILENAME = "build.ninja"
  
  def self.create_UUID
    UUIDTools::UUID.random_create
  end
  
  class Rule
    def initialize(rule_desc, depfile="")
      @rule_desc = rule_desc
      @depfile = depfile
      @unique_name = Ninja.create_UUID
    end
  
    def unique_name
      @unique_name
    end

    def depfile_line
      if @depfile == ""
        ""
      else
        "  depfile = #{@depfile}\n"
      end
    end 

    def to_ninja_format
"""
rule #{unique_name}
#{depfile_line}  command = #{@rule_desc}
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
  
    def to_a
      @dep
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
  
    def get_target_object
      @target
    end
  
    def get_rule_object
      @rule
    end
  
    def implicit_dep_line
      if @implicit_dep == nil
        ""
      else
        @implicit_dep.to_ninja_format
      end
    end
  
    def to_ninja_format
"""
build #{@target.to_ninja_format}: #{@rule.name} #{@explicit_dep.to_ninja_format} #{implicit_dep_line}
"""
    end
  end
  
  def self.__to_ninja_format(xs)
    xs.map{ |x| x.to_ninja_format }.join "\n\n"
  end
  
  def self.rules(ninjas)
    __rules = ninjas.map{ |x| x.get_rule_object } 
    Set.new(__rules).to_a
  end
  
  def self.to_ninja_format(ninjas)
    xs = (rules(ninjas) + ninjas).flatten
    __to_ninja_format(xs)
  end
  
  def self.create_ninja_file(ninjas)
    namespace :ninja do
      desc("generate ninja file if ninja.rake is changed")
      file DEFAULT_NINJA_FILENAME => "ninja.rake" do 
        puts "--- REGENERATING THE NINJA FILE NOW ---"
        f = File.new(DEFAULT_NINJA_FILENAME, "w")
	txt = to_ninja_format(ninjas)
        f.write(txt)
        f.close
      end
    end
  end
  
  def self.make_ninja_task(target) 
    namespace :ninja do
      namespace :build do
        task target =>  DEFAULT_NINJA_FILENAME do 
          sh "ninja #{target}"
        end
        task :all => target
      end
      namespace :clean do
        task target => DEFAULT_NINJA_FILENAME do
          sh "ninja -t clean #{target}"
        end
        task :all => target
      end 
    end
  end
  
  def self.end_of_ninja(*ninjas)
    create_ninja_file(ninjas.flatten)

    ninjas.each do |ninja|
      ninja.get_target_object.to_a.each do |target|
        make_ninja_task(target)
      end
    end
  end

  # Facade 
  # To Hide the implementation 
  def self.Rule(rule, depfile="") 
    Ninja::Rule.new(rule, depfile)
  end
  
  def self.Build(rule, target, explicit, implicit=nil)
    Ninja::Build.new(rule, target, explicit, implicit)
  end
  
  def self.Target(*xs)
    Ninja::Target.new(xs)
  end
  
  def self.Explicitly(*xs)
    Ninja::Explicitly.new(xs)
  end
  
  def self.Implicitly(*xs)
    Ninja::Implicitly.new(xs)
  end
end # end of Ninja module

if __FILE__ == $0
  puts Ninja.Rule("gcc -c $in -o $out").to_ninja_format

  p Ninja.Rule("gcc -MMD -MF $out.d -c $in -o $out", "$out.d")
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
