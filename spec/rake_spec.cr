require "./spec_helper"

describe Cadmium::Keywords::Rake do
  # TODO: Write tests
  subject = Cadmium::Keywords::Rake.new
  it "works" do
    subject.keywords(TEXT).should eq(true)
  end
  it "workss" do
    subject.keywords(TEXTT).should eq(true)
  end
  it "wrrrorkss" do
    subject.keywords(TTEXX).should eq(true)
  end
  it "dfgsdsd" do
    subject.keywords(OSDIFOPISDF).should eq(true)
  end
  # it "worksm" do
  #   Cadmium::Rake.get_keywords(TEXT).should eq(true)
  # end
end
