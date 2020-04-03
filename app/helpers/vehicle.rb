#I realize vehicles dont sing but this is just an example for fun
#While I could have simply added the sing method to the CVehicle class,
#we’ll instead assume that we wanted to give that singing ability to another class later on.
# For this reason, it’s wise to DRY out the code by
# putting that behavior into a module and simply including it in all applicable classes.
# in real life I would have made a class for singable but sing is ok for now
#  obj.sing
# notice the self use below
# Use self to reference the calling object within an instance method definition.
module Singable
  def sing
    "I'm a/an #{self.name} vehicle, and I'm singing, oh yayyyyyy im singing!"
  end
end


#All Class names use camel case, Being an old MFC C++ programmer I happen to like that very much!
#Ruby is very much convention over configuration
public class CVehicle

  #this is how you include a module
  include Singable

  #With instance variables, you can make them accessible or not with
  # attr_reader and attr_writer outside of the class.
  #so now we could do obj.rentalfee, obj.engine etc...
  #I guess I like to just write the setters getters but this is commonly used convention..

  #can read these ie. think getter
  attr_reader :rentalfee, :engine, :brakes

  #can read and write ie. think setter getter
  attr_accessor :accsomething, :name

  #can write ie think setter
  attr_writer :writesomething

  #different accessors can communicate your intent
  # and make it easier to write classes which will work correctly
  #no matter how their public API is called.

  #attr_writer :age
  #gets translated into:
  #                def age=(value)
  #                  @age = value
  #                end

  #attr_reader :age
  #gets translated into:
  #                def age
  #                  @age
  #                end

  #attr_accessor :age
  #                def age=(value)
  #                 @age = value
  #                end
  #
  #                def age
  #                 @age
  #                end

  #initilize always gets called... ie think constructor
  def initialize
    @engine = 'none'
    @brakes = 'none'
    @rentalfee = 0

    #add this vehicle to the inventory count
    #important that child classes call the base class initilize to keep count
    @@invcount += 1
  end

  #@@invcount is defined for CVehicle as well as for its ancestry classes,
  # as well as for their instances. They all share the same @@invcount.
  # thats the @@ prefix
  @@invcount = 0

  #Use self to denote a method within the class definition as a class method.
  def self.inventorycount
    @@invcount
  end

  #The keyword self in Ruby gives you access to the current object –
  # the object that is receiving the current message. To explain: a
  # method call in Ruby is actually the sending of a message to a receiver.
  # When you write obj.meth, you're sending the meth message to the object obj.
  # obj will respond to meth if there is a method body defined for it. And inside
  # that method body, self refers to obj.
  # it wasn't totally apparent when you might actually need to
  # use self.
  #
  #Use self when setting/getting instance attributes inside a class definition.
  #Use self to denote a method within the class definition as a class method.
  #Use self to reference the calling object within an instance method definition.
  #
  #In the context of a class, self refers to the current class,
  # which is simply an instance of the class Class.
  # Defining a method on self creates a class method.
  # so below could be accessed via CVehicle.SomeClassMethod ie. think static method
  def self.someclassmethod
    #This is a stub
  end

  #NOTE: not sure what happens if i provide my own setter/getter
  #and use the attr_ above? need to research...

  #this is an instance method
  #I need lots o cash so you gotta pay a rental fee for any vehicle!
  def payrentalfee(fee)
    @rentalfee = fee
  end

  #all vehicles have an engine setter and getter
  #o.GetEngine
  def getengine
    @engine
  end
  #
  #o.SetEngine myEngine
  def setengine(anengine)
    @engine = anengine
  end

  #this is another way to do setter/getter
  #
  #setter
  def engine=(engine)
    @engine = engine
  end
  #
  #getter
  def engine
    @engine
  end

  #####################################
  #ruby loop examples
  def looper

    i = 0; #unnessasry semi colon but interesting it works

    total = 100;

    #while
    while i < total
      puts("Inside the loop i = #{i}" )
      i += 1
    end

    i = 0

    #begin end while
    begin
      puts("Inside the loop i = #{i}" )
      i += 1
    end while i < total

    i = 0

    #until do
    until i > total  do
      puts("Inside the loop i = #{i}" )
      i += 1;
    end

    i = 0

    #begin end until
    begin
      puts("Inside the loop i = #{i}" )
      i += 1;
    end until i > num

    i = 0

    #for
    for i in 0..5
      puts "Value of local variable is #{i}"
    end

    #each do
    (0..5).each do |i|
      puts "Value of local variable is #{i}"
    end

    #break
    for i in 0..5
      if i > 2 then
        break
      end
      puts "Value of local variable is #{i}"
    end

    #for in over an array
    #The odd thing about the for loop is that the loop returns the
    # collection of elements after it executes,
    #Most Rubyists forsake for loops and prefer using iterators instead.
    x = [1, 2, 3, 4, 5]
    for j in x do
      puts j
    end

    #Iterators are methods that naturally loop over a given set of data and allow you
    # to operate on each element in the collection.
    #arrays are ordered lists. Let's say that you had an array of names and you
    # wanted to print them to the screen. How could you do that?
    # You could use the each method for arrays, like this:
    #
    #iteration using the each method of arrays
    #stuff between pipes are variables yielded to the block
    # |name_i_can_call_it_anything| is bound to the list element
    #
    #each is a method that accepts a block of code then runs that block of
    # code for every element in a list,
    names = ['Bob', 'Joe', 'Steve', 'Janice', 'Susan', 'Helen']
    names.each { |name_i_can_call_it_anything| puts name_i_can_call_it_anything }
    names.each { |name| puts name }

    #the bit between do and end is a block
    names.each do |name_it_hamandeggs|
      puts "Hello #{name_it_hamandeggs}!"
    end

    #next
    for i in 0..5
      if i < 2 then
        next
      end
      puts "Value of local variable is #{i}"
    end

    #redo
    for i in 0..5
      if i < 2 then
        puts "Value of local variable is #{i}"
        redo
      end
    end

    #rescue retry
    begin
      do_something # exception raised
    rescue
      # handles error
      retry  # restart from beginning
    end

    #retry
    for i in 1..5
      retry if  i > 2
      puts "Value of local variable is #{i}"
    end

  end


end
 
 
class CCar < CVehicle

  def initialize
    #When you invoke super with no arguments Ruby sends a message to the parent of the current object,
    # asking it to invoke a method of the same name as the method invoking super.

    #call the base class constructor/initialize
    super

  end

  #overridding payrentalfee defined in CVehicle
  def payrentalfee(fee)

    #When you invoke super with no arguments Ruby sends a message to the parent of the current object,
    # asking it to invoke a method of the same name as the method invoking super.
   # It automatically
    # forwards the arguments that were passed to the method from which it's called.
    #
    #Called with an empty argument list - super()-it sends no arguments to the higher-up method,
    # even if arguments were passed to the current method.
    #
    #Called with specific arguments - super(a, b, c) - it sends exactly those arguments.
    #
    #so this would call payrentalfee in CVehicle and pass in [fee] waperdoodles
    #pay up!
    super(fee)

    #so this would ALSO call payrentalfee in CVehicle and pass in [fee] waperdoodles since fee
    #is passed to this method its also passed to the base
    super

  end

end
 