require 'spec_helper'
require 'gaman/messenger'

RSpec.describe 'Messenger' do
  let(:gaman) { Gaman::GitAccountManager.new }

  context 'display_ssh_keys' do
    it 'notice when empty array passed' do
      expect { gaman.display_ssh_keys([]) }.to output(/no ssh key/).to_stdout
    end

    it 'raise ArgumentError when ssh_keys are not Array' do
      not_array_value = 1
      expect { gaman.display_ssh_keys(not_array_value) }.to raise_error(ArgumentError)
    end

    it 'display in right format' do
      ssh_keys = %w(foo bar)
      output_format = /.+\d+.+ - \w.*/
      expect { gaman.display_ssh_keys(ssh_keys) }.to output(output_format).to_stdout
    end
  end
end
