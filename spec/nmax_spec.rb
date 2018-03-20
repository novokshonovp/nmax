require 'simplecov'
SimpleCov.start

require './lib/nmax'
include Nmax

describe Nmax do
  describe '#parse' do
    let(:bp) { BigsParser.new(File.open('./spec/fixtures/sample_data_1_99_and_big.txt','r'), num_of_greatest) }

    context 'when wrong number of greatest' do
      let(:num_of_greatest) { 0 }
      subject { bp.parse }
      it { expect { subject }.to raise_error 'Wrong number of greatest!' }
    end

    context 'when wrong block size' do
      let(:bp) { BigsParser.new(File.open('./spec/fixtures/sample_data_1_99_and_big.txt','r'), num_of_greatest, 0) }
      let(:num_of_greatest) { 1 }
      subject { bp.parse }
      it { expect { subject }.to raise_error 'Wrong block size!' }
    end

    context 'when params right' do
      before { bp.parse }
      subject { bp.greatest.sort }
      let(:num_of_greatest) { 5 }
      context 'when sample less than block ' do
          it { is_expected.to eq([96,97,98,99, ('1'*1000).to_i]) }
      end
      context 'when sample more than block' do
        let(:bp) { BigsParser.new(File.open('./spec/fixtures/sample_data_1_999_and_big.txt','r'), num_of_greatest) }
        it { is_expected.to eq([996,997,998,999, ('1'*1000).to_i]) }
      end
    end
  end
end
