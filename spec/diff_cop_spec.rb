require 'spec_helper'

describe DiffCop do

  subject { described_class.new }

  it 'has a version number' do
    expect(DiffCop::VERSION).not_to be nil
  end

  context 'a single patch in a single file' do

    before :example do
      allow(subject).to receive(:diff_output).and_return(fixture('version.diff'))
      allow(subject).to receive(:`).and_return(fixture('version.json'))
    end

    it 'calls rubocop only on the diffed file' do
      expect(subject).to receive(:`).with(/version\.rb/)
      subject.start
    end

    it 'prints the file and line numbers of offenses' do
      expect { subject.start.print! }.to output(/lib\/diff_cop\/version\.rb:2:/).to_stdout
    end

    it 'prints the offenses' do
      expect { subject.start.print! }.to output(/Operator `=` should be/).to_stdout
    end

    it 'returns false when there are offenses' do
      subject.start
      capture2 do
        expect(subject.print!).to be_falsy
      end
    end

  end

  context 'when there is no diff' do

    before :example do
      allow(subject).to receive(:diff_output).and_return(fixture('empty.diff'))
    end

    it 'does not invoke the linter' do
      expect(subject).to_not receive(:`).with(/rubocop/)
      expect(subject).to receive(:diff_output)
      subject.start
    end

    describe '#print' do

      it 'prints that all is well' do
        expect { subject.start.print! }.to output(/no offenses/).to_stdout
      end

      it 'returns true' do
        capture2 do
          expect(subject.start.print!).to be_truthy
        end
      end

    end

  end

end
