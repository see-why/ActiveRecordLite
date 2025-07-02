require 'spec_helper'
require 'activerecord_lite'
require 'activerecord_lite/relation'

describe ActiveRecordLite::Relation do
  it 'loads the class' do
    expect(defined?(ActiveRecordLite::Relation)).to eq('constant')
  end
end
