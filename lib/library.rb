require 'yaml'
#require 'date'

class Library
    attr_accessor :catalog, :title, :author, :available, :book

    def initialize
        @catalog = YAML.load_file('./lib/data.yml')
    end

    def author_search(user_search)
        @book = catalog.select { |obj| obj[:item][:author].include? user_search }
    end











=begin
    def new_book(args = {})
        title = args[:title]
        author = args[:author]
        available = args[:available]
    end
    def add_book
        File.open('./lib/data.yml', 'w') { |f| f.write new_book.to_yaml }
   end
=end


end