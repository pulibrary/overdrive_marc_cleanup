# frozen_string_literal: true

require 'byebug'
require 'overdrive_cleaner'

RSpec.describe OverdriveCleaner do
  let(:input_directory) { File.join(File.dirname(__FILE__), 'fixtures/Princeton University-20250204090033910/') }
  let(:oc) { OverdriveCleaner.clean(input_directory) }

  # runs before every test and deletes the output file
  before do
    temp_object = OverdriveCleaner.new(input_directory)
    File.delete(temp_object.output_filename) if File.exist?(temp_object.output_filename)
  end

  after do
    temp_object = OverdriveCleaner.new(input_directory)
    File.delete(temp_object.output_filename) if File.exist?(temp_object.output_filename)
  end

  it 'can be instantiated' do
    oc = OverdriveCleaner.new(input_directory)
    expect(oc).to be_instance_of(OverdriveCleaner)
  end

  it 'has a file of marc records' do
    oc = OverdriveCleaner.new(input_directory)
    expect(oc.marc_file).to be true
  end

  it 'takes a directory of marc files' do
    expect(oc).to be_instance_of(OverdriveCleaner)
    expect(oc.input_directory).to eq(input_directory)
  end

  it 'has a list of the marc files' do
    expect(oc.marc_files.first).to match 'Princeton University-20250204090033910_audio.mrc'
  end

  it 'has a list of the marc records' do
    oc = OverdriveCleaner.new(input_directory)
    expect(oc.marc_records.count).to eq 16
  end

  it 'has an array with 100$a subfield for each marc record' do
    expect(oc.author_100a.first).to eq 'Kureishi, Hanif'
  end

  it 'combines all the files and writes them out' do
    expect(File.exist?(oc.output_filename)).to be true
  end
end
