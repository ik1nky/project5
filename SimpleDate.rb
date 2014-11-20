#
# SimpleDate class represents a calendar date and contains methods to analyze dates.
#
# Author: Michael Kinkema && Jack Rosenhauer
#
class SimpleDate

  include Comparable, Enumerable

  # define some useful constants
  MIN_YEAR = 1753   # minimum allowable year in a date
  NUM_MONTHS = 12
  DAYS_YEAR = 365
  DAYS_LEAP_YEAR = 366
  DAYS_IN_MONTH = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  DAYS_THUS_FAR = [0, 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334]
  MONTH_TABLE = [0, 3, 3, 6, 1, 4, 6, 2, 5, 0, 3, 5]

  # define few more useful constants representing day of week
  SUNDAY = 0
  MONDAY = 1
  TUESDAY = 2
  WEDNESDAY = 3
  THURSDAY = 4
  FRIDAY = 5
  SATURDAY = 6

  # generates getter methods for @month, @day, and @year instance variables
  attr_reader :month, :day, :year

  #
  # Initializes the instance variables @month, @day, and @year using the values
  # of parameters.
  #
  # Raises ArgumentError exception when the following is true:
  #     month, day, and year are not Fixnum type, or
  #     values of month, day, and year do not represent a valid date
  #
  def initialize(month, day, year)
    if SimpleDate.validDate?(month, day, year)
      @month = month
      @day = day
      @year = year
    else
      raise ArgumentError
    end
  end

  #
  # yields @month, @day, and @year values one at a time in that order
  #
  def each
    yield @month
    yield @day
    yield @year
  end

  #
  # Defines an ordering between this SimpleDate object and other SimpleDate object. Returns a negative, zero, or postive number depending on whether the receiver is less than, equal to, or greater than the other object. If the other object is not comparable then the <=> operator should return nil.

  def <=>(other)
    if !other.instance_of?(SimpleDate)
      return nil
    end
    if @year != other.year
      return @year - other.year
    elsif @month != other.month
      return @month - other.month
    elsif @day != other.day
      return @day - other.day
    else
      return 0
    end
  end

  # Returns an integer (must be same as constants SUNDAY, MONDAY, etc.) representing the day of the week for this date.

  def dayOfWeek
    days = 0;
    tempYear = MIN_YEAR
    while tempYear < @year
      days += SimpleDate.daysInYear(tempYear).to_i
      tempYear+=1
    end

    days = days + ordinalDate
    #puts "days #{days}"
    days = days % 7

  end

  # Returns the number of days in the year of this date
  def daysInYear
    if leapYear?
      return 366
    else
      return 365
    end
  end

  #
  # Returns true if this date is in a leap year, false otherwise
  #
  def leapYear?
    if @year % 400 == 0
      return true
    elsif @year % 100 == 0
      return false
    elsif @year % 4 == 0
      return true
    else
      return false
    end
  end

  #
  # Returns the number of days that have elapsed (including this day) since 1 January.
  #
  def ordinalDate
    ordinal = DAYS_THUS_FAR[@month].to_i + @day.to_i
    if leapYear? && @month > 2
      ordinal = ordinal + 1
    end
    return ordinal
  end

  #
  # Returns a SimpleDate object representing the next date of this date.
  #
  def nextDate
    sd = SimpleDate.new(@month, @day, @year)

    if (sd.month == 12 && sd.day == 31)
      return SimpleDate.new(1, 1, @year+1)

    elsif (leapYear? && sd.month == 2 && sd.day == DAYS_IN_MONTH[sd.month] )
      return SimpleDate.new(2, 29, @year)

    elsif(sd.day == SimpleDate.daysInMonth(month, year))
      return SimpleDate.new(@month + 1, 1, @year)

    else
      return SimpleDate.new(@month, @day + 1, @year)
    end
  end

  #
  # Returns a SimpleDate object representing the previous date of this date or nil if
  # previous date is before the MIN_YEAR (i.e.. 1753).
  #
  def prevDate
    sd = SimpleDate.new(@month, @day, @year)

    if (sd.month == 1 && sd.day == 1)
      return SimpleDate.new(12, 31, @year - 1)

    elsif (sd.leapYear? && sd.month == 3 && sd.day == 1)
      return SimpleDate.new(2, 29, @year)

    elsif(sd.day == 1)
      return SimpleDate.new(@month - 1,DAYS_IN_MONTH[@month - 1],@year)

    else
      return SimpleDate.new(@month, @day - 1, @year)
    end
  end

  #
  # Returns a new SimpleDate object representing the date n days ago.
  # If n is negative, then return the date n days in the future.
  # Raise ArgumentError if the new date is before the minimum allowable date (1/1/1753).
  #
  def daysAgo(n)
    puts n
    sd = SimpleDate.new(@month, @day, @year)
    if n < 0
      n *= -1
      n.times do
        sd = sd.nextDate
      end
    else
      n.times do
        sd = sd.prevDate
        #puts sd
      end
    end

    return sd
  end

  #
  # Returns a new SimpleDate object representing the date n days from now.
  # If n is negative, then return the date n days in the past.
  # Raise ArgumentError if the new date is before the minimum allowable date (1/1/1753).
  #
  def daysFromNow(n)
    sd = SimpleDate.new(@month, @day, @year)
    if n > 0
      n.times do
        sd = sd.nextDate
      end
    else
      n *= -1
      n.times do
        sd = sd.prevDate
        #puts "fuck"
      end
    end
    return sd
  end

  #
  # Returns a string representation of this SimpleDate object.
  #
  def to_s
    "#{@month}/#{@day}/#{@year}"
  end

  #
  # Class method that returns true if the given year is a leap year, false otherwise.
  #
  def self.leapYear?(year)
    if year % 400 == 0
      return true
    elsif year % 100 == 0
      return false
    elsif year % 4 == 0
      return true
    else
      return false
    end
  end

  #
  # Class method that returns the number of days in the given year.
  #
  def self.daysInYear(year)
    if self.leapYear?(year)
      return DAYS_LEAP_YEAR
    else
      return DAYS_YEAR
    end
  end

  #
  # Class method that returns the number of days in a month for a given year.
  #
  def self.daysInMonth(month, year)
    if self.leapYear?(year) && month == 2
      return DAYS_IN_MONTH[month] + 1
    else
      return DAYS_IN_MONTH[month]
    end
  end

  #
  # Class method that determines if values for month, day, and year represent a valid date.
  #
  def self.validDate?(month, day, year)
     if !month.is_a?(Integer) || !day.is_a?(Integer) || !year.is_a?(Integer)
       raise ArgumentError
     end

    if year >= MIN_YEAR && month > 0 && month <= NUM_MONTHS && day > 0
      #puts "-234234234"
      #puts self.leapYear?(year)
      #puts month == 2
      #puts day = DAYS_IN_MONTH[month] + 1
      #puts DAYS_IN_MONTH[month] + 1
      #puts day
      #puts "--- end"
      if self.leapYear?(year) && month == 2 && day <= DAYS_IN_MONTH[month] + 1
        return true
      elsif day <= DAYS_IN_MONTH[month]
        return true
      else
        #puts "False 1"
        return false
      end
    end
    #puts "false 2"
    return false
  end

end
# end of SimpleDate class

sd = SimpleDate.new(1, 1, 1754)
puts sd
puts sd.leapYear?
puts sd.dayOfWeek
puts "ordinal date #{sd.ordinalDate}"

puts "-------"

sd2 = SimpleDate.new(11, 17, 2014)
puts sd2
puts sd2.ordinalDate

puts sd2.dayOfWeek

puts "leap year #{sd2.leapYear?}"



puts SimpleDate.validDate?(1 ,2, 1800)

sd3 = SimpleDate.new(1, 1, 1756)
p sd

puts sd3.prevDate

sd3 = SimpleDate.new(3, 1, 2004)
puts sd3.prevDate

sd3 = SimpleDate.new(3, 5, 2004)
puts sd3.prevDate


puts "--------- sd4 ---------"
sd4 = SimpleDate.new(3, 1, 2004)
puts sd4.leapYear?
puts sd4.prevDate
puts sd4.nextDate

puts "--------- sd5 ---------"
sd5 = SimpleDate.new(3, 1, 2007)
puts sd5.leapYear?
puts sd5.prevDate
puts sd5.nextDate


puts "--------- sd6 ---------"
sd6 = SimpleDate.new(3, 1, 2012)
#puts sd6.dayOfWeek

puts sd6.daysAgo(30)
#puts sd6.leapYear?
