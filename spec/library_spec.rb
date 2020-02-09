require 'yaml'
require './lib/library.rb' #links to this file so the tests can refer to this code
require 'pry'

describe Library do 
    let(:catalog) { instance_double(book_title: 'Pippi Långstrump', author_name: 'Susan Cain', full_book_title: 'Pippi Långstrump', new_book_title: 'Harry Potter and the Chamber of Secrets', new_book_author: 'J.K. Rowling' )}
      
    #before do
       # catalog = YAML.load_file('./lib/default.yml')
        #File.open('./lib/books_database.yml', 'w') { |f| f.write catalog.to_yaml}  
    #end

    it 'view all books' do
        expected_output = YAML.load_file('./lib/data.yml')
        expect(subject.catalog).to eq expected_output
    end

    it 'search for books by title' do
        expected_output = YAML.load_file('./lib/data.yml').select { |obj| obj[:item][:title].include? "Quiet"  }
        expect(subject.title_search()).to eq expected_output
    end

    it 'search for books by author' do
        expected_output = YAML.load_file('./lib/data.yml').select { |obj| obj[:item][:author].include? "Susan Cain"  }
        expect(subject.author_search()).to eq expected_output
    end

    it 'book to check out' do
        expected_output = YAML.load_file('./lib/data.yml').select { |obj| obj[:item][:title] == "Quiet" }
        subject.check_out_book()
        expect(subject.catalog.detect{ |obj| obj[:item][:title] == 'Quiet'}).to eq expected_output
    end 
    
    describe 'user can checkout book' do
        
        it 'message to user"checkout complete, return book on {return_date}" ' do
            #binding.pry
            expected_output = { message: 'Checkout complete', return_date: '03/08/20' }
            subject.check_out_book(:full_book_title) 
            expect(subject.checkout()).to eq expected_output
        end

        it 'message to user"checkout incomplete,book unavailable" ' do
            expected_output = 'Checkout incomplete, book unavailable.'
            expect(subject.book_availability?("Osynligt med Alfons")).to eq expected_output
        end
    
        it 'updates the availability of book,after checkout' do
            expected_output = false
            expect(subject.book_to_checkout('Pippi Långstrump')[0][:available]).to eq expected_output 
        end

        it 'updates the return_date,after checkout' do
            expected_output = (subject.return_date)  
            expect(subject.book_to_checkout('Pippi Långstrump')[0][:return_date]).to eq expected_output  
        end
    end 

    describe 'user can return book' do

        it 'updates the availability of book, after return' do
        
            expected_output = true
            expect(subject.book_to_return("Skratta lagom! Sa pappa Åberg")[0][:available]).to eq expected_output 
        end

        it 'updates the return_date, after return' do
            expected_output = nil  
            expect(subject.book_to_return("Skratta lagom! Sa pappa Åberg")[0][:return_date]).to eq expected_output  
        end
    end

    #it 'librarian can add a new book to catalog'
        #subject.add_new_book()
        #expect(YAML.load_file('./lib/data.yml').select { |obj| obj[:item][:title] == :new_book_title }).to eq true
    #end     
end




   

    









