# frozen_string_literal: true

require 'byebug'
require 'overdrive_cleaner'

RSpec.describe OverdriveCleaner do
  let(:input_directory) { File.join(File.dirname(__FILE__), 'fixtures/Princeton University-20250204090033910/') }

  it 'can be instantiated' do
    oc = OverdriveCleaner.new
    expect(oc).to be_instance_of(OverdriveCleaner)
  end

  it 'has a file of MARC records' do
    oc = OverdriveCleaner.new
    expect(oc.marc_file).to be true
  end

  it 'takes a directory of marc files' do
    oc = OverdriveCleaner.clean(input_directory)
    expect(oc).to be_instance_of(OverdriveCleaner)
    expect(oc.input_directory).to eq(input_directory)
  end
end
