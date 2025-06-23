require 'sqlite3'
require 'singleton'

module ActiveRecordLite
  class DatabaseConnection
    include Singleton

    def initialize
      @db = SQLite3::Database.new ":memory:"
      @db.results_as_hash = true
    end

    def execute(*args)
      @db.execute(*args)
    end
  end
end
