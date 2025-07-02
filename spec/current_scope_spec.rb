require 'spec_helper'
require 'activerecord_lite/current_scope'

describe ActiveRecordLite::CurrentScope do
  it 'loads the module' do
    expect(defined?(ActiveRecordLite::CurrentScope)).to eq('constant')
  end
end
