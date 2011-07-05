namespace :ninja_rake do
  task :remote_add do
    sh "git remote add origin git@github.com:akiradeveloper/ninja-rake.git"
  end
  
  task :push do
    sh "git push origin master"
  end  
end  
