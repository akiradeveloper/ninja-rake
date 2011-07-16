require "set"
require "uuidtools"

module Ninja

  def self.create_UUID
    UUIDTools::UUID.random_create
  end
  
  class Rule
    def initialize(rule_desc, depfile="")
      @rule_desc = rule_desc
      @depfile = depfile
      @unique_name = Ninja.create_UUID
    end

    def with_name!(name)
      @unique_name = name
      self
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
