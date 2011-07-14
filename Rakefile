require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Tests negative-captcha.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generates documentation for negative-captcha.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'NegativeCaptcha'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Create the negative-captcha gemspec'
begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'negative-captcha'
    gem.summary = %Q{Makes the process of creating a negative captcha in Rails much less painless.}
    gem.description = %Q{Makes the process of creating a negative captcha in Rails much less painless.}
    gem.email = 'erik@skribit.com'
    gem.homepage = 'https://github.com/stefants/negative-captcha'
    gem.authors = ['subwindow']
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end