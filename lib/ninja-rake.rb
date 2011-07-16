require "ninja"

module Ninja

  DEFAULT_NINJA_FILENAME = "build.ninja"

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

  def self.define_ninja_rule
    rule /^ninja[-\s\w]+$/ do |ninja_cmd|
      sh "#{ninja_cmd}"
    end
  end
end # end of Ninja module

Ninja.define_ninja_rule
