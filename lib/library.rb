require 'yaml'
require 'date'

class Library
    attr_accessor :catalog, :return_date, :books_checked_out, :user_search

    STANDARD_TIME_MONTH = 1

    def initialize
        @catalog = YAML.load_file('./lib/data.yml')
        @return_date = set_return_date()
    end
   #User can search
    def author_search(user_search)
        @book = catalog.select { |obj| obj[:item][:author].include? user_search }
    end

    def title_search(user_search)
        @book = catalog.select { |obj| obj[:item][:title].include? user_search }
    end

    
    #We want to first find the book the user wants to check out
    def book_to_checkout(user_search)
        books_checked_out = []
        books_checked_out << @catalog.detect { |obj| obj[:item][:title] == user_search }
    end
    
    # we then want to check the book's availability
    # we then want an OR statement to either checkout book or say book is not available (maybe do in one step?)
    def book_availability?(user_search)
        availablity = book_to_checkout(user_search)[0][:available]
        availablity ? checkout(user_search) : 'Checkout incomplete, book unavailable.'
    end
    
    # then if the book is available we want to 'checkout' by updating the books availability and return_date and message to user
    def checkout(user_search)
        #update availability
        book_to_checkout(user_search)[0][:available] = false
        #update return date
        book_to_checkout(user_search)[0][:return_date] = @return_date
        #push to yml
        File.open('./lib/data.yml', 'w') { |f| f.write catalog.to_yaml }
        #message to user
        { message: 'Checkout complete', return_date: set_return_date } 
    end
    
    def set_return_date
        Date.today.next_month(STANDARD_TIME_MONTH).strftime('%D')
    end   
    
    def book_to_return(user_search)
        books_returned = []
        books_returned << @catalog.detect { |obj| obj[:item][:title] == user_search }
    end

    def return_book(user_search)
    #update availability
    books_to_return(user_search)[0][:available] = true
    #update return date
    books_to_return(user_search)[0][:return_date] = nil
    #push to yml
    File.open('./lib/data.yml', 'w') { |f| f.write catalog.to_yaml }
    #message to user
    print "Return Complete"
    end

    #Still working on this, does not yet add to yml file
    def add_new_book
    print "Title of New Book: "
    new_book_title = gets.chomp.to_s
    print "Author: "
    new_book_author = gets.chomp.to_s
    File.open('./lib/data.yml', 'w') { |f| f.write catalog.to_yaml } <<{:item=>{:title=>new_book_title, :author=>new_book_author}, :available=>true, :return_date=>nil}
    
    end


end