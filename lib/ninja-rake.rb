require "ninja"

module Ninja

  DEFAULT_NINJA_FILENAME = "build.ninja"

  def self.create_ninja_file(ninjas)
    namespace "ninja" do
      desc("generate ninja file if ninja.rake is changed.")
      task "generate_ninja_file" => DEFAULT_NINJA_FILENAME 

      file DEFAULT_NINJA_FILENAME => "ninja.rake" do 
        puts "--- REGENERATING THE NINJA FILE NOW ---"
        f = File.new(DEFAULT_NINJA_FILENAME, "w")
	txt = to_ninja_format(ninjas)
        f.write(txt)
        f.close
      end
    end
  end
  
  def self.end_of_ninja(*ninjas)
    create_ninja_file(ninjas.flatten)
  end

  def self.define_ninja_rule
    rule /^ninja[-\s\w]+$/ => "ninja:generate_ninja_file" do |ninja_cmd|
      sh "#{ninja_cmd}"
    end
  end
end # end of Ninja module

Ninja.define_ninja_rule
