require 'spec_helper'
require 'activerecord_lite'

describe ActiveRecordLite::DatabaseConnection do
  it 'loads the class' do
    expect(defined?(ActiveRecordLite::DatabaseConnection)).to eq('constant')
  end

  describe '.instance' do
    it 'returns a singleton instance' do
      inst1 = described_class.instance
      inst2 = described_class.instance
      expect(inst1).to be_a(described_class)
      expect(inst1).to equal(inst2)
    end
  end

  describe '#execute' do
    it 'executes SQL and returns results as an array of hashes' do
      db = described_class.instance
      db.execute('CREATE TABLE test (id INTEGER PRIMARY KEY, name TEXT);')
      db.execute("INSERT INTO test (name) VALUES ('Alice')")
      result = db.execute('SELECT * FROM test')
      expect(result).to be_an(Array)
      expect(result.first).to include('name' => 'Alice')
    end
  end
end
