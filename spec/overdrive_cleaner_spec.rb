# frozen_string_literal: true

require 'byebug'
require 'overdrive_cleaner'

RSpec.describe OverdriveCleaner do
  let(:input_directory) { File.join(File.dirname(__FILE__), 'fixtures/Princeton University-20250204090033910/') }
  let(:oc) { OverdriveCleaner.clean(input_directory) }

  it 'can be instantiated' do
    oc = OverdriveCleaner.new
    expect(oc).to be_instance_of(OverdriveCleaner)
  end

  it 'has a file of MARC records' do
    oc = OverdriveCleaner.new
    expect(oc.marc_file).to be true
  end

  it 'takes a directory of marc files' do
    expect(oc).to be_instance_of(OverdriveCleaner)
    expect(oc.input_directory).to eq(input_directory)
  end

  it 'knows where the output file should go' do
    expect(oc.output_file).to eq "#{input_directory}clean_records.mrc"
  end

  it 'combines all the files and writes them out' do
    expect(File.exist?(oc.output_file)).to be true
  end
end
