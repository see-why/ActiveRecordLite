require 'spec_helper'
require 'activerecord_lite/base'

describe ActiveRecordLite::Base do
  it 'loads the class' do
    expect(defined?(ActiveRecordLite::Base)).to eq('constant')
  end
end
