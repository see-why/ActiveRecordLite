require 'spec_helper'
require 'activerecord_lite'
require 'activerecord_lite/delegation'

describe ActiveRecordLite::Delegation do
  it 'loads the module' do
    expect(defined?(ActiveRecordLite::Delegation)).to eq('constant')
  end
end
