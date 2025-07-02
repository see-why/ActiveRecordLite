require 'spec_helper'
require 'activerecord_lite'

describe ActiveRecordLite::CurrentScope do
  subject(:current_scope) { described_class.new }

  it 'can set and get the scope attribute' do
    fake_scope = double('Scope')
    current_scope.scope = fake_scope
    expect(current_scope.scope).to eq(fake_scope)
  end

  it 'initializes with nil scope by default' do
    expect(current_scope.scope).to be_nil
  end
end
