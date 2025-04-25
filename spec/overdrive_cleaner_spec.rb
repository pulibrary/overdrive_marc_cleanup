# frozen_string_literal: true

require 'byebug'
require 'overdrive_cleaner'

RSpec.describe OverdriveCleaner do
  let(:input_directory) { File.join(File.dirname(__FILE__), 'fixtures/Princeton University-20250204090033910/') }
  let(:oc) { OverdriveCleaner.clean(input_directory) }

  # Runs before every test and deletes the output file.
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

  # E-resources librarian gets an email from overdrive containing the marc files.
  # They save the attachments to a directory. That directory is the starting point.
  # The fixture data is a representitive sample of those email attachments.
  it 'takes a directory of marc files' do
    expect(oc).to be_instance_of(OverdriveCleaner)
    expect(oc.input_directory).to eq(input_directory)
  end

  it 'has an array of the marc files from the input_directory' do
    expect(oc.marc_files.count).to eq 4
    expect(oc.marc_files.first).to match 'Princeton University-20250204090033910_audio.mrc'
  end

  it 'has an array of the marc records contained in all of the marc files' do
    oc = OverdriveCleaner.new(input_directory)
    expect(oc.marc_records.count).to eq 26
  end

  # This has its own set of fixture data.
  # Fixture data has the 100 tag with no period, so I can prove it's fixed.
  # Eventually I want to do more with the 100 tag like add a link to the name authority file.
  context '100 tag' do
    let(:input_directory) { File.join(File.dirname(__FILE__), 'fixtures/100_tag_no_period') }
    let(:oc) { OverdriveCleaner.clean(input_directory) }

    # Testing ability to get a subfield out.
    it 'has an array with 100$a subfield for each marc record' do
      expect(oc.author_100a.first).to eq 'Kureishi, Hanif,'
    end

    # See method tag100_subfield_e(record).
    it 'ensures that the 100 tag always ends in a period' do
      expect(oc.marc_records.first['100']['e'].to_s).to match 'author.'
    end
  end

  #  This has its own set of fixture data for the 650 tag.
  context '650 tag' do
    let(:input_directory) { File.join(File.dirname(__FILE__), 'fixtures/650_tag') }
    let(:oc) { OverdriveCleaner.clean(input_directory) }

    # Testing ability to get a subfield out.
    it 'has an array with 650$a subfield for each marc record' do
      expect(oc.subject_650a.first).to eq 'People with quadriplegia '
    end

    it 'ensures that the 650 tag always ends in a period' do
      expect(oc.marc_records.first['650']['v'].to_s).to match 'Diaries.'
    end
  end

  context 'writing file' do
    let(:input_directory) { File.join(File.dirname(__FILE__), 'fixtures/Princeton University-20250204090033910/') }
    let(:output_directory) { File.join(File.dirname(__FILE__), 'fixtures/output') }
    let(:output_file) { File.join(File.dirname(__FILE__), 'fixtures/output/output_file.mrc') }
    let(:oc) { OverdriveCleaner.new(input_directory, output_file) }

    before do
      File.delete(output_file) if File.exist?(output_file)
    end

    # this should be deleted leaving it here so I can show the output_file
    # after do
    #   File.delete(output_file) if File.exist?(output_file)
    # end

    it 'combines all the files and writes them out' do
      expect(File.exist?(oc.output_filename)).to be false
      oc.write_output_file
      expect(File.exist?(oc.output_filename)).to be true
      od = OverdriveCleaner.new(output_directory)
      expect(od.marc_records.count).to eq 26
    end
  end
end
