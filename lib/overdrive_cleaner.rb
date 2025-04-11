# frozen_string_literal: true

require 'marc'
require 'marc_cleanup'

# This is a class that takes a directory of MARC files from overdrive
# and gives back a file of MARC records that are formatted the way PUL wants them
class OverdriveCleaner
  # input_directory is where the files from overdrive are
  attr_accessor :input_directory

  # OverdriveCleaner.clean(input_directory) should produce a combined file of cleaned marc records
  def self.clean(input_directory)
    odc = OverdriveCleaner.new(input_directory)
    odc.write_output_file
    odc
  end

  def initialize(input_directory)
    @input_directory = input_directory
  end

  def marc_file
    true
  end

  def marc_files
    Dir["#{input_directory}*"]
  end

  # output_file are the records that have been combined and cleaned
  def output_file
    "#{input_directory}clean_records.mrc"
  end

  def write_output_file
    File.open(output_file, 'w') { |file| file.write('your text') }
  end

  def marc_records
    records = []
    marc_files.each do |file|
      reader = MARC::Reader.new(file)
      reader.each do |record|
        records << record
        puts MarcCleanup.leader_errors?(record)
      end
    end
    records
  end

  def author_100a
    authors = []
    marc_files.each do |file|
      reader = MARC::Reader.new(file)
      reader.each do |record|
        authors << record['100']['a']
      rescue MARC::Exception
      end
    end
    authors
  end
end
