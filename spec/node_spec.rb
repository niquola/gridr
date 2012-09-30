require 'spec_helper'
require 'logger'
require 'ostruct'
describe Gridr::Node do
  let(:test_dir) { File.dirname(__FILE__) }
  let(:repo_dir) { File.join(test_dir,'test_repository') }
  let(:working_directory) { File.join( test_dir,'work_dir') }
  let(:logger) { Logger.new(STDOUT) }
  let(:run_info) { Hash.new }
  let(:worker_commnad) { 'ls' }

  subject do
    Gridr::Node.new.tap do |n|
      n.logger = logger
      n.working_directory = working_directory
      n.run_info = run_info
      n.worker_commnad = worker_commnad
      n.number_of_workers = 1
    end
  end

  before :each do
    FileUtils.rm_rf(File.join(repo_dir,'.git'))
    Dir.chdir repo_dir do
      `git init && git add . && git commit -m 'initial'`
    end
    FileUtils.rm_rf(working_directory)
    Dir.chdir test_dir do
      puts "git clone #{repo_dir} #{working_directory}"
      system "git clone #{repo_dir} #{working_directory}"
    end
  end

  it "should start workers" do
    subject.run_info = OpenStruct.new(commit: 'master')
    subject.on_run_request
    subject.on_complete
  end

  after :each do
    FileUtils.rm_rf(File.join(repo_dir,'.git'))
    FileUtils.rm_rf(working_directory)
  end
end
