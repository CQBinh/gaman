require 'spec_helper'
require 'gaman/file_helper'

RSpec.describe 'FileHelper' do
  let(:gaman) { Gaman::GithubAccountManager.new }

  context 'ssh_path' do
    it 'right ssh path' do
      ssh_path = "#{Dir.home}/.ssh"
      expect(gaman.ssh_path).to match(ssh_path)
    end
  end
end
