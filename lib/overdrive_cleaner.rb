# frozen_string_literal: true

require 'marc'
require 'marc_cleanup'

# This is a class that takes a directory of MARC files from overdrive
# and gives back a file of MARC records that are formatted the way PUL wants them
class OverdriveCleaner
  # input_directory is where the files from overdrive are
  attr_accessor :input_directory, :output_filename

  # OverdriveCleaner.clean(input_directory) should produce a combined file of cleaned marc records
  def self.clean(input_directory)
    odc = OverdriveCleaner.new(input_directory)
    odc.write_output_file
    odc
  end

  # output_filename is where the records that have been combined and cleaned
  # OverdriveCleaner.new('/Users/swarren/Documents/OverdriveFiles',
  # '/Users/swarren/Documents/alma_uploads/clean_records.mrc')
  def initialize(input_directory, output_filename = nil)
    @input_directory = input_directory
    @output_filename = output_filename || File.join(File.dirname(__FILE__), 'clean_records.mrc')
  end

  # Return an array of the files that are in this directory.
  def marc_files
    Dir["#{input_directory}/*"]
  end

  def write_output_file
    writer = MARC::Writer.new(output_filename)
    marc_records.each do |record|
      writer.write(record)
    end
    writer.close
  end

  # Returns an array of clean marc records.
  def marc_records
    records = []
    marc_files.each do |file|
      reader = MARC::Reader.new(file)
      reader.each do |record|
        record = tag100_subfield_e(record)
        record = tag650_cleanup(record)
        records << record
      end
    end
    records
  end

  def tag_100
    authors = []
    marc_records.each do |record|
      authors << record['100'].to_s
    end
    authors
  end

  # Testing ability to get a subfield out.
  def author_100a
    authors = []
    marc_files.each do |file|
      reader = MARC::Reader.new(file)
      reader.each do |record|
        authors << record['100']['a']
      end
    end
    authors
  end

  # A method to add a period at the end of the 100 tag subfield e (100$e)
  # This method cleans up the 100 tag subfield e
  def tag100_subfield_e(record)
    if record['100']['e'] == 'author'
      tag100_subfields = record['100'].subfields
      tag100e_subfields = tag100_subfields.select { |a| a.code == 'e' }
      tag100e_subfield = tag100e_subfields[0]
      tag100e_subfield.value = 'author.'
    end
    record
  end

  # Testing ability to get a subfield out.
  def subject_650a
    subjects = []
    marc_files.each do |file|
      reader = MARC::Reader.new(file)
      reader.each do |record|
        next if record['650'].nil?

        subjects << record['650']['a']
      end
    end
    subjects
  end

  # A method to add a period at the end of the 650 tag last subfield if it is missing
  # # This method cleans up the 650 tag
  def tag650_cleanup(record)
    return record if record['650'].nil?

    unless record['650'][-1] == '.'
      tag650_subfields = record['650'].subfields
      tag650_last_subfield = tag650_subfields[-1]
      tag650_last_subfield.value = "#{tag650_last_subfield.value}."
    end
    record
  end
end
