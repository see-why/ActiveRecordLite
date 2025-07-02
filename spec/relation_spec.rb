require 'spec_helper'
require 'activerecord_lite'
require 'activerecord_lite/relation'

describe ActiveRecordLite::Relation do
  let(:model) { double('Model') }
  subject(:relation) { described_class.new(model) }

  it 'loads the class' do
    expect(defined?(ActiveRecordLite::Relation)).to eq('constant')
  end

  describe '#where' do
    it 'adds a where condition' do
      relation.where(name: 'Alice')
      expect(relation.where_values).to include(name: 'Alice')
    end

    it 'chains multiple where conditions' do
      relation.where(name: 'Alice').where(active: true)
      expect(relation.where_values).to eq([{name: 'Alice'}, {active: true}])
    end
  end

  describe '#order' do
    it 'adds an order condition' do
      relation.order(created_at: :desc)
      expect(relation.order_values).to include(created_at: :desc)
    end

    it 'chains multiple order conditions' do
      relation.order(created_at: :desc).order(name: :asc)
      expect(relation.order_values).to eq([{created_at: :desc}, {name: :asc}])
    end
  end

  describe '#to_sql' do
    it 'returns empty string for no conditions' do
      expect(relation.to_sql).to eq("")
    end

    it 'generates WHERE clause for where conditions' do
      relation.where(name: 'Alice')
      expect(relation.to_sql).to eq("WHERE name = 'Alice'")
    end

    it 'generates ORDER BY clause for order conditions' do
      relation.order(created_at: :desc)
      expect(relation.to_sql).to eq("ORDER BY created_at DESC")
    end

    it 'combines WHERE and ORDER BY clauses' do
      relation.where(name: 'Alice').order(created_at: :desc)
      expect(relation.to_sql).to eq("WHERE name = 'Alice' ORDER BY created_at DESC")
    end

    it 'combines multiple where and order conditions' do
      relation.where(name: 'Alice').where(active: true).order(created_at: :desc).order(name: :asc)
      expect(relation.to_sql).to eq("WHERE name = 'Alice' AND active = 'true' ORDER BY created_at DESC, name ASC")
    end
  end
end
