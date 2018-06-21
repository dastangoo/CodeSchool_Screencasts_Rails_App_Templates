gem_group :development, :test do
  gem 'rspec-rails'
  gem 'capybara'
end

run 'bundle install'
run 'rm -rf test'
generate 'rspec:install'

insert_into_file 'spec/spec_helper.rb', 
  "require 'capybara/rails'\n",
  after: "require 'rspec/autorun'\n"
  
layout_type = ask("Do you want to use Foundation or Bootstrap?")
case layout_type
when /foundation/i
  gem 'foundation-rails'
  run 'bundle install'
  run 'rm app/views/layouts/applicaiton.html.rb'
  generate 'foundation:install'
when /bootstrap/i
  gem 'bootstrap-sass'
  run 'bundle install'
  run 'mv app/assets/stylesheets/application.css app/assets/stylesheets/applicaiton.css.scss'
  insert_into_file 'app/assets/stylesheets/applicaiton.css.scss',
    "@import 'bootstrap';\n",
    after: "*/\n"
end

gem 'devise'
run 'bundle install'
generate 'devise:install'
devise_model = ask("What should the Devise User Model be called?")
devise_model = 'user' if devise_model.blank?
generate 'devise', devise_model

rake 'db:migrate'

git :init 
git add: '.'
git commit: '-m Initial commit'
