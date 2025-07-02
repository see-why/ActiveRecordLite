require 'spec_helper'
require 'activerecord_lite/database_connection'

describe ActiveRecordLite::DatabaseConnection do
  it 'loads the class' do
    expect(defined?(ActiveRecordLite::DatabaseConnection)).to eq('constant')
  end
end
