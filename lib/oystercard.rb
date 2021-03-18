class Oystercard 

    MAXIMUM_BALANCE = 90
    MINIMUM_BALANCE = 5
    MINIMUM_CHARGE = 5

    attr_reader :balance, :in_journey, :entry_station, :journeys, :exit_station

    def initialize 
        @balance = 0
        @entry_station = entry_station 
        @exit_station = exit_station
        @journeys = []
    end

    def top_up(amount)
        fail "Maximum balance exceeded #{MAXIMUM_BALANCE}" if amount + balance > MAXIMUM_BALANCE
        @balance += amount
    end

    def in_journey?
        !!entry_station
    end

    def touch_in(entry_station)
        fail 'Insufficient balance to touch in' if @balance < MINIMUM_BALANCE
        @in_journey = true
        @entry_station = entry_station
    end

    def touch_out(exit_station)
        deduct(MINIMUM_CHARGE)
        @in_journey = false
        @journeys.push({:entry_station => entry_station, :exit_station => exit_station})
        @entry_station = nil
        @exit_station = exit_station
    end

    private 
    def deduct(amount)
        @balance -= amount
    end
end
