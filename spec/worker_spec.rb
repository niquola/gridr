require 'spec_helper'

describe Gridr::WorkerProcess do
  let(:command) { %(ruby -e 'while true; puts "ups"; sleep 1; end;') }
  subject { Gridr::WorkerProcess.new(command) }

  it "should" do
    subject.start
    subject.stop
  end

  it "should" do
    subject = Gridr::WorkerProcess.new(%(ruby -e 'raise "Ups"'))
    subject.start
    subject.stop
  end
end
