require 'spec_helper'
require 'activerecord_lite'

describe 'ActiveRecordLite integration', type: :integration do
  before(:all) do
    # Setup in-memory DB and table
    db = ActiveRecordLite::DatabaseConnection.instance
    db.execute('DROP TABLE IF EXISTS users')
    db.execute(<<-SQL)
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        name TEXT,
        organization TEXT,
        active BOOLEAN,
        created_at DATETIME
      );
    SQL
    db.execute("INSERT INTO users (name, organization, active, created_at) VALUES (?, ?, ?, ?)", ["Alice", "OrgA", 1, "2024-06-01"])
    db.execute("INSERT INTO users (name, organization, active, created_at) VALUES (?, ?, ?, ?)", ["Bob", "OrgB", 0, "2024-06-02"])
    db.execute("INSERT INTO users (name, organization, active, created_at) VALUES (?, ?, ?, ?)", ["Carol", "OrgA", 1, "2024-06-03"])

    class User < ActiveRecordLite::Base
      def self.active
        where(active: 1)
      end
      def self.recent
        order(created_at: :desc)
      end
    end
  end

  after(:all) do
    Object.send(:remove_const, :User) if defined?(User)
  end

  it 'returns correct count for filtered and ordered queries' do
    expect(User.where(organization: "OrgA").active.count).to eq(2)
    expect(User.active.where(organization: "OrgA").recent.count).to eq(2)
    expect(User.where(active: 0).count).to eq(1)
  end

  it 'returns correct records for filtered and ordered queries' do
    results = User.where(organization: "OrgA").active.recent.to_a
    expect(results.size).to eq(2)
    expect(results.first["name"]).to eq("Carol") # Most recent
    expect(results.last["name"]).to eq("Alice")
  end

  it 'returns all records with to_a' do
    expect(User.to_a.size).to eq(3)
  end
end
