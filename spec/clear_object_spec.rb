require 'byebug'

class User
  extend ClearObject    
end

RSpec.describe ClearObject do

  subject { User }
  before { subject.clear_object! }

  it 'has a version number' do
    expect(ClearObject::VERSION).not_to be nil
  end

  it 'holds the attributes in an accessor' do
    expect(subject.clear_attributes).to eq([])
  end

  it 'has a clear method' do
    expect(subject.clear).to_not be_nil
  end

  it 'fills the clear_attributes array with values' do
    subject.clear(:name, :email)
    expect(subject.clear_attributes).to eq([:name, :email])
  end

  it 'stores an initializer definition' do
    subject.clear(:name)

    expect(subject.initialize_definition).to eq('name: ')
  end

  it 'implicitly defines an initializer' do
    subject.clear(:name)

    expect{ subject.new }.to raise_error(ArgumentError)
  end
end
