source "http://rubygems.org"

gem "rails", "~> 3.0"

group :development do
  gem "jeweler", "~> 1.5.2"

  platforms :ruby do
    gem "sqlite3-ruby"
  end

  platforms :jruby do
    gem "jdbc-sqlite3", :require => "jdbc/sqlite3"
    gem "activerecord-jdbc-adapter", "1.0.0.beta2"
    gem "jruby-openssl", :require => false # Silence openssl warnings.
  end
end
