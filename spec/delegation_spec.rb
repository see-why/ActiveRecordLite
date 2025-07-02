require 'spec_helper'
require 'activerecord_lite'
require 'activerecord_lite/delegation'

describe ActiveRecordLite::Delegation do
  it 'loads the module' do
    expect(defined?(ActiveRecordLite::Delegation)).to eq('constant')
  end

  describe '::DELEGATED_CLASSES' do
    it 'is an array of classes/modules to delegate to' do
      expect(described_class::DELEGATED_CLASSES).to be_an(Array)
      expect(described_class::DELEGATED_CLASSES).to include(ActiveRecordLite::Relation)
    end

    it 'is frozen' do
      expect(described_class::DELEGATED_CLASSES).to be_frozen
    end
  end
end
