require 'spec_helper'
require 'activerecord_lite'

describe ActiveRecordLite::ClassSpecificRelation do
  let(:model) do
    Class.new do
      def foo(x)
        "foo-#{x}"
      end
    end.new
  end

  let(:klass) do
    Class.new do
      include ActiveRecordLite::ClassSpecificRelation
      def initialize(model)
        @model = model
      end
    end
  end

  subject(:relation) { klass.new(model) }

  describe '#method_missing' do
    it 'delegates missing methods to the model' do
      expect(relation.foo('bar')).to eq('foo-bar')
    end

    it 'raises NoMethodError for truly missing methods' do
      expect { relation.nonexistent_method }.to raise_error(NoMethodError)
    end
  end

  describe '#respond_to_missing?' do
    it 'returns true for methods the model responds to' do
      expect(relation.respond_to?(:foo)).to be true
    end

    it 'returns false for methods the model does not respond to' do
      expect(relation.respond_to?(:nonexistent_method)).to be false
    end
  end
end
