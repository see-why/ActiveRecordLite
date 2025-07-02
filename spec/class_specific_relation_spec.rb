require 'spec_helper'
require 'activerecord_lite/class_specific_relation'

describe ActiveRecordLite::ClassSpecificRelation do
  it 'loads the class' do
    expect(defined?(ActiveRecordLite::ClassSpecificRelation)).to eq('constant')
  end
end
