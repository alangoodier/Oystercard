require "./lib/oystercard.rb"
require "./lib/station.rb"


describe Oystercard do 

    let(:station){ double :station }
    let(:card){ Oystercard.new }
    let(:entry_station){ double :entry_station }
    let(:exit_station){ double :exit_station }

    describe 'balance' do
        oystercard = Oystercard.new
        it 'will be an oystercard with a starting balance of 0' do
        expect(oystercard.balance).to eq 0
    end

    describe '#top_up' do 
        it { is_expected.to respond_to(:top_up).with(1).argument }

        it 'can top up the balance' do
        expect { oystercard.top_up (Oystercard::MINIMUM_BALANCE) }.to change{ oystercard.balance }.by (Oystercard::MINIMUM_BALANCE)
    end

    it 'raises an error if the maximum balance is exceeded' do
        maximum_balance = Oystercard::MAXIMUM_BALANCE
        minimum_balance = Oystercard::MINIMUM_BALANCE
        card.top_up maximum_balance
        expect{ card.top_up 1 }.to raise_error "Maximum balance exceeded #{maximum_balance}"
    end

    it 'expected you are not on a journey' do 
        expect(card).not_to be_in_journey
    end

    describe 'after touching in' do

        before do 
            card.top_up(Oystercard::MAXIMUM_BALANCE)
            card.touch_in(station)
        end

    it 'touches in to start journey' do 
        expect(card).to be_in_journey
    end

    it 'touches out to end journey' do 
        expect{ card.touch_out(station) }.to change{ card.balance }.by(-Oystercard::MINIMUM_CHARGE)
    end
    
    it 'stores the entry station' do 
        expect(card.entry_station).to eq station
    end

    it 'stores the exit station' do 
        card.touch_out(station)
        expect(card.exit_station).to eq station
    end
   end

    it 'shows no entry stations after touching out' do
        expect(card.entry_station).to eq nil
    end

    it 'will not touch in if below minimum balance' do
        expect{ card.touch_in(station) }.to raise_error 'Insufficient balance to touch in'
    end

    it 'will expect the journey list to be empty' do
        expect(card.journeys).to be_empty
    end

    it 'will store a journey' do 
        card.top_up(Oystercard::MAXIMUM_BALANCE)
        card.touch_in(entry_station)
        card.touch_out(exit_station)
        expect(card.journeys).to include ({ entry_station: entry_station, exit_station: exit_station })
    end
  end
 end
end

describe Station do 

    station = Station.new


    it 'knows its name' do
        expect(station.name).to eq "Old Street"
    end

    it 'knows its zone' do
        expect(station.zone).to eq 1
    end
end
