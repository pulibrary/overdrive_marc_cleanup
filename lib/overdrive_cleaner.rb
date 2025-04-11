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
  def initialize(input_directory, output_filename = nil)
    @input_directory = input_directory
    @output_filename = output_filename || File.join(File.dirname(__FILE__), 'output_file.mrc')
  end

  def marc_file
    true
  end

  def marc_files
    Dir["#{input_directory}*"]
  end

  def write_output_file
    File.open(output_filename, 'w') { |file| file.write('your text') }
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
      end
    end
    authors
  end
end
