require "overdrive_cleaner"

RSpec.describe OverdriveCleaner do
  it "can be instantiated" do
    oc = OverdriveCleaner.new
    expect(oc).to be_instance_of(OverdriveCleaner)
  end
end