#!/usr/bin/env ruby

require_relative '../lib/activerecord_lite'

# Database setup and record insertion
ActiveRecordLite::DatabaseConnection.instance.execute(<<-SQL)
  CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT,
    organization TEXT,
    active BOOLEAN,
    created_at DATETIME
  );
SQL

ActiveRecordLite::DatabaseConnection.instance.execute(
  "INSERT INTO users (name, organization, active, created_at) VALUES (?, ?, ?, ?)", ["Olande Adekunle", "CIBC", 1, "2025-06-22"]
)

ActiveRecordLite::DatabaseConnection.instance.execute(
  "INSERT INTO users (name, organization, active, created_at) VALUES (?, ?, ?, ?)", ["Cyril Iyadi", "Scribd", 0, "2025-06-22"]
)

ActiveRecordLite::DatabaseConnection.instance.execute(
  "INSERT INTO users (name, organization, active, created_at) VALUES (?, ?, ?, ?)", ["Peter Ibegbulem", "Teda Foods", 1, "2025-06-22"]
)

class User < ActiveRecordLite::Base
  def self.active
    where(active: 1)
  end

  def self.recent
    order(created_at: asc)
  end
end

# Query Example
puts User.where(organisation: "CIBC").active.recent.count
puts User.active.where(organisation: "CIBC").recent.to_a
