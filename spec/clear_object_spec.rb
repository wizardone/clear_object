require 'byebug'

class User
  extend ClearObject    
end

RSpec.describe ClearObject do

  subject { User }
  before { subject.instance_variable_set(:@clear_attributes, nil) }

  it 'has a version number' do
    expect(ClearObject::VERSION).not_to be nil
  end

  it 'has a clear method' do
    expect(subject.clear).to_not be_nil
  end

  it 'creates proper keyword arguments underneath' do
    subject.clear(:name, :email)
    expect {
      subject.new
    }.to raise_error(ArgumentError)
  end

  context '#initialize' do
    it 'implicitly defines an initializer' do
      subject.clear(:name)

      expect(subject).to respond_to(:new)
    end

    it 'allows you to initialize the object' do
      subject.clear(:name)

      user = subject.new(name: 'Stefan')

      expect(user.name).to eq('Stefan')
    end

    it 'avoids duplication' do
      subject.clear(:name)
      subject.clear(:name)

      user = subject.new(name: 'Stefan')

      expect(user.name).to eq('Stefan')
    end

    it 'allows you to initialize the object with a default value string' do
      subject.clear(:name, default: 'Tom')
      user = subject.new
      expect(user.name).to eq('Tom')
    end

    it 'allows you to initialize the object with a default value of some object' do
      some_class = Class
      subject.clear(:status, default: some_class)
      user = subject.new
      expect(user.status).to eq(Class)
    end

    it 'allows you to initialize the object with a default value of something else' do
      some_address = []
      subject.clear(:address, default: some_address)
      user = subject.new
      expect(user.address).to eq([])
    end

    it 'allows you to initialize the object with a default value of something else' do
      new_class = Class.new
      subject.clear(:custom, default: new_class)
      user = subject.new
      expect(user.custom).to eq(new_class)
    end

    it 'allows you to initialize the object with a default value of some callable object' do
      callable = -> { 'callable' }
      subject.clear(:custom, default: callable)
      user = subject.new
      expect(user.custom).to eq('callable')
    end
  end

  context 'block usage' do
    it 'can supply a block and dynamically generate a class with inferred name' do
      subject.clear(:address) do
        clear :city, default: 'Toronto'
        clear :street, default: 'Nasty Blv'
      end
      user = subject.new(address: Address.new)
      expect(user.address).to be_a(Address)
      expect(user.address.city).to eq('Toronto')
      expect(user.address.street).to eq('Nasty Blv')
    end

    it 'can supply a block and dynamically generate a class with a custom name' do
      subject.clear(:address, clear_name: :nasty) do
        clear :illegal 
      end
      user = subject.new(address: Nasty.new(illegal: true))
      expect(user.address).to be_a(Nasty)
      expect(user.address.illegal).to eq(true)
    end
  end
end
