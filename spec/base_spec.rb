require 'spec_helper'
require 'activerecord_lite'

describe ActiveRecordLite::Base do
  before do
    # Define a test subclass for isolation
    class TestUser < described_class; end
  end

  after do
    Object.send(:remove_const, :TestUser) if defined?(TestUser)
  end

  describe '.table_name' do
    it 'returns the correct table name' do
      expect(TestUser.table_name).to eq('testusers')
    end
  end

  describe '.where and .order' do
    it 'returns a relation that accumulates where and order conditions' do
      rel = TestUser.where(name: 'Alice').order(created_at: :desc)
      expect(rel).to be_a(ActiveRecordLite::Relation)
      expect(rel.where_values).to include(name: 'Alice')
      expect(rel.order_values).to include(created_at: :desc)
    end
  end

  describe '.count' do
    it 'executes the correct SQL and returns the count' do
      fake_result = [{"COUNT(*)" => 42}]
      allow_any_instance_of(ActiveRecordLite::DatabaseConnection).to receive(:execute).and_return(fake_result)
      expect(TestUser.count).to eq(42)
    end
  end

  describe '.to_a' do
    it 'executes the correct SQL and returns the result array' do
      fake_result = [{"id" => 1, "name" => "Alice"}]
      allow_any_instance_of(ActiveRecordLite::DatabaseConnection).to receive(:execute).and_return(fake_result)
      expect(TestUser.to_a).to eq(fake_result)
    end
  end
end
