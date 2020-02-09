require 'yaml'
require 'date'

class Library
    attr_accessor :catalog, :return_date, :books_checked_out, :user_search, :books_returned

    STANDARD_TIME_MONTH = 1

    def initialize
        @catalog = YAML.load_file('./lib/data.yml')
        @return_date = set_return_date()
        @books_returned = []
    end

    def full_catalog
        
    end 

    def user_type
        puts "Welcome to the Digital Library"
        puts "Are you a visitor or employee? "
        user_type = gets.chomp.to_s
        if user_type == 'visitor'
            puts "To view entire library catalog: library.full_catalog"
            puts "To search for a book by title: library.title_search(*book title*)"
            puts "To search for a book by author: library.author_search(*author name*)"
            puts "To checkout a book:"
            puts "To return a book: "
        else
            puts "To view full library catalog: library.full_catalog"
            puts "To add new book to library collection: library.add_new_book"
        end
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
        #reload yml file since its been updated
        YAML.load_file('./lib/data.yml')
        #message to user
        { message: 'Checkout complete', return_date: set_return_date } 
    end
    
    def set_return_date
        Date.today.next_month(STANDARD_TIME_MONTH).strftime('%D')
    end   
    
    def book_to_return(user_search)
        @books_returned << @catalog.detect { |obj| obj[:item][:title] == user_search }
    end

    def return_book
        #update availability
        @books_returned[0][:available] = true
        #update return date
        @books_returned[0][:return_date] = nil
        #push to yml
        File.open('./lib/data.yml', 'w') { |f| f.write catalog.to_yaml }
        #reload yml file since its been updated
        YAML.load_file('./lib/data.yml')
        #reset books_returned to 0 so that is user reopens 
        @books_returned = nil
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