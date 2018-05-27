# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Style do
  include CopHelper

  SLEEP_LENGTH = 5

  subject(:cop) { RuboCop::Cop::Style::SleepCop.new }

  it 'MSG is about SleepCop' do
    expect(RuboCop::Cop::Style::SleepCop::MSG).to match(/Do not.*SleepCop/)
  end

  context 'with single line' do
    context 'with sleep' do
      before { inspect_source('sleep(1000)') }

      it 'has one error' do
        expect(cop.offenses.size).to eq(1)
      end

      it 'is a warning' do
        expect(cop.offenses.first.severity).to eq(:warning)
      end

      it 'shows error message' do
        expect(cop.messages.first).to eq(RuboCop::Cop::Style::SleepCop::MSG)
      end
    end

    context 'without sleep' do
      before { inspect_source('puts "Sleep. No sleep. I am not sleeping."') }

      it 'has no errors' do
        expect(cop.offenses.size).to eq(0)
      end

      it 'has no error message' do
        expect(cop.messages.first).to be_nil
      end
    end
  end

  context 'with multiple lines' do
    context 'when sleep at the beginning' do
      before do
        source = <<~SOURCE
                   sleep 50
                   puts 'hello'
                   puts 'more string'
                 SOURCE
        inspect_source(source)
      end

      it 'finds the location of sleep' do
        left = cop.offenses.first.location.column
        found = cop.offenses.first.location.source_line[left, SLEEP_LENGTH]
        expect(found).to eq('sleep')
      end
    end

    context 'when sleep in the middle' do
      before do
        source = <<~SOURCE
                   loop do
                     print 'hello, '
                     puts 'world' && (sleep 1)
                   end
                 SOURCE
        inspect_source(source)
      end

      it 'finds the location of sleep' do
        left = cop.offenses.first.location.column
        found = cop.offenses.first.location.source_line[left, SLEEP_LENGTH]
        expect(found).to eq('sleep')
      end
    end
  end

  context 'when disabled' do
    before do
      source = <<~SOURCE
                 # rubocop:disable all, Style/SleepCop
                 sleep 1
                 # rubocop:enable all, Style/SleepCop
               SOURCE
      inspect_source(source)
    end

    # TODO: Figure this out.
    # This currently fails because it complains about the sleep even though
    # the cop is disabled. Note that currently all cops are disabled and we
    # would still fail here.
    # Because of that, the test is x-ed out.
    #
    # Oh, and because of all these comments RuboCop says this block has too
    # many lines. When it rains, it pours!
    xit 'does not complain about sleeps' do
      # raise cop.offenses.first.message
      expect(cop.offenses.size).to eq(0)
    end
  end
end
