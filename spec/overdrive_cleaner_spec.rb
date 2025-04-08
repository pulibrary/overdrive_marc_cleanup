# frozen_string_literal: true

require 'overdrive_cleaner'

RSpec.describe OverdriveCleaner do
  it 'can be instantiated' do
    oc = OverdriveCleaner.new
    expect(oc).to be_instance_of(OverdriveCleaner)
  end

  it 'has a file of MARC records' do
    oc = OverdriveCleaner.new
    expect(oc.marc_file).to be true
  end
end
