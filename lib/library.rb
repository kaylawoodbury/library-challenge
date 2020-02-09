require 'yaml'
require 'date'
require 'pp'


class Library
    attr_accessor :catalog, :return_date, :books_checked_out, :user_search, :books_returned, :is_book_available

    STANDARD_TIME_MONTH = 1

    def initialize
        @catalog = YAML.load_file('./lib/data.yml')
        @return_date = set_return_date()
        @books_returned = []
        @books_checked_out = []
    end


    #guides users to available actions, working as expected
    def start
        puts "Welcome to the Digital Library"
        puts "Are you a visitor or employee? "
        user_type = gets.chomp.to_s
        if user_type == 'visitor'
            puts 'Available actions include:'
            puts 'library.catalog'
            puts 'library.title_search'
            puts 'library.author_search'
            puts 'library.check_out_book'
            puts 'library.return_book'
        else
            puts 'Available actions include:'
            puts 'library.catalog'
            puts 'library.add_new_book'
        end
    end

   #User can search, working as expected
    def author_search
        puts 'Search for books with author name like: '
        author_name = gets.chomp.to_s
        pp catalog.select { |obj| obj[:item][:author].include? author_name }
        
    end

    def title_search
        puts 'Search for books with title like: '
        book_title = gets.chomp.to_s
        #@book = catalog.select { |obj| obj[:item][:title].include? book_title}
        pp catalog.select { |obj| obj[:item][:title].include? book_title}

    end

####### Check Out Book ################
    #Not working
    # we then want to check the book's availability
    # we then want an OR statement to either checkout book or say book is not available (maybe do in one step?)
    def check_out_book
        puts 'Enter full title of book you wish to checkout: '
        full_book_title = gets.chomp.to_s
        @is_book_available = []
        @is_book_available << @catalog.detect{ |obj| obj[:item][:title] == full_book_title }
        availablity = @is_book_available[0][:available]
        #availablity = @book[0][:available]
        if availability == true
            puts 'This book is available, would you like to continue to checkout? (yes/no)'
            #proceed_to_checkout = gets.chomp.to_s
            #if proceed_to_checkout == yes
                #books_checked_out << @catalog.detect { |obj| obj[:item][:title] == full_book_title }
                #checkout()
            #else  puts 'Checkout cancelled'
            #end
        else puts 'This book is currently unavailable'
        end
    end
     
    # then if the book is available we want to 'checkout' by updating the books availability and return_date and message to user
    def checkout()
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
    
    
########## Return Books ################
    def return_book
        puts 'Enter full title of book you wish to return: '
        full_book_title = gets.chomp.to_s
        @books_returned << @catalog.detect { |obj| obj[:item][:title] == full_book_title}
        puts 'Please enter: library.return_book'
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
        #message to user
        { message: 'Return Complete', book_returned: @books_returned[0][:item][:title], returned_date: Date.today }
        #reset books_returned to 0 so that is user reopens 
        @books_returned = nil
    end

###### Add new book #########
    #Still working on this, does not yet add to yml file
    def add_new_book
        print "Title of New Book: "
        new_book_title = gets.chomp.to_s
        print "Author: "
        new_book_author = gets.chomp.to_s
        @catalog << {:item=>{:title=>new_book_title, :author=>new_book_author}, :available=>true, :return_date=>nil}
        File.write('./lib/data.yml', YAML.dump(@catalog))
    end
end