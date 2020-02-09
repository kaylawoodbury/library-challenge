require 'yaml'
require 'date'
require 'pp'
require 'colorize'
require 'awesome_print'
require 'pry'


class Library
    attr_accessor :catalog, :return_date, :book_checked_out, :user_search, :book_returned, :is_book_available

    STANDARD_TIME_MONTH = 1

    def initialize
        @catalog = YAML.load_file('./lib/data.yml')
        @return_date = set_return_date()
        @book_returned = []
        @book_checked_out = []
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

    def create_visitor_id(visitor)        
        visitor.visitor_account_status = true
        visitor.visitor_id = rand(100000..999999)                     
    end

   def full_catalog
        ap @catalog
   end 

   #User can search, working as expected
    def author_search
        puts 'Search for books with author name like: '
        author_name = gets.chomp.to_s
        ap catalog.select { |obj| obj[:item][:author].include? author_name }
        
    end

    def title_search
        puts 'Search for books with title like: '
        book_title = gets.chomp.to_s
        #@book = catalog.select { |obj| obj[:item][:title].include? book_title}
        ap catalog.select { |obj| obj[:item][:title].include? book_title}

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
        availability = @is_book_available[0][:available]
        
        if availability == true
            puts 'This book is available, would you like to continue to checkout? (yes/no)'
            proceed_to_checkout = gets.chomp.to_s
            if proceed_to_checkout == 'yes'
                @book_checked_out << @catalog.detect { |obj| obj[:item][:title] == full_book_title }
                checkout()
            else  puts 'Checkout cancelled'
            end
        else puts 'This book is currently unavailable'
        end
    end
     
    # then if the book is available we want to 'checkout' by updating the book\s availability and return_date in the yml file, and send message to user
    def checkout()
        #update availability
        @book_checked_out[0][:available] = false
        #update return date
        @book_checked_out[0][:return_date] = @return_date
        #push to yml
        File.open('./lib/data.yml', 'w') { |f| f.write catalog.to_yaml }
        #reload yml file since its been updated
        YAML.load_file('./lib/data.yml')
        @is_book_available = [] 
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
        @book_returned << @catalog.detect { |obj| obj[:item][:title] == full_book_title}

        #update availability
        @book_returned[0][:available] = true
        #update return date
        @book_returned[0][:return_date] = nil
        #push to yml
        File.open('./lib/data.yml', 'w') { |f| f.write catalog.to_yaml }
        #reload yml file since its been updated
        YAML.load_file('./lib/data.yml')
        @book_returned = [] 
        #message to user
         { message: 'Return Complete', book_returned: full_book_title, returned_date: Date.today }
    end



###### Add new book #########

    def add_new_book
        print "Title of New Book: "
        new_book_title = gets.chomp.to_s
        print "Author: "
        new_book_author = gets.chomp.to_s
        @catalog << {:item=>{:title=>new_book_title, :author=>new_book_author}, :available=>true, :return_date=>nil}
        File.write('./lib/data.yml', YAML.dump(@catalog))
    end
end