# encoding: utf-8
require "jeweler"
require "rake/testtask"

Jeweler::Tasks.new do |spec|
  spec.name = "paginary"
  spec.rubyforge_project = "paginary"
  spec.summary = "View-based pagination for Rails."
  spec.description = "Simple, view-based pagination for Rails, built on top of Active Record 3 awesomeness."

  spec.authors = ["Rolf Timmermans"]
  spec.email = "r.timmermans@voormedia.com"
  spec.homepage = "http://github.com/voormedia/paginary"
end

Jeweler::GemcutterTasks.new

Jeweler::RubyforgeTasks.new do |rubyforge|
  rubyforge.doc_task = "rdoc"
  rubyforge.remote_doc_path = "doc"
end

Rake::TestTask.new do |test|
  test.pattern = "test/**/*_test.rb"
end

task :default => :test

begin
  require "hanna/rdoctask"
  Rake::RDocTask.new do |rdoc|
  end
rescue LoadError
end
