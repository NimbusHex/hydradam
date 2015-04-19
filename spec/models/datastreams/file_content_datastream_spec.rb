require 'spec_helper'

describe FileContentDatastream do

  before do
    @file = GenericFile.new
    @file.apply_depositor_metadata('justin')
    @file.save!
    @file.add_file(StringIO.new("A test file"), 'content', 'test.txt')
  end
  subject do
    @file.content
  end
  after do
    subject.stub(:live?).and_return(true)
    @file.destroy
  end
  describe "#dsChecksumValid" do
    describe "when the file is unchanged" do
      its(:dsChecksumValid) { should eq true}
    end
    describe "when the file is changed" do
      before do
        File.open(subject.filename, 'wb') do |f|
          f.puts "Changed it"
        end
      end
      its(:dsChecksumValid) { should eq false}
    end
  end


end
