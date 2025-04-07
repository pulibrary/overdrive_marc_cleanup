# frozen_string_literal: true

require 'overdrive_cleaner'

RSpec.describe OverdriveCleaner do
  it 'can be instantiated' do
    oc = described_class.new
    expect(oc).to be_instance_of(described_class)
  end
end
