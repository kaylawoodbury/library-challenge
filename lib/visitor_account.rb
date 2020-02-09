class Visitor
    attr_accessor :name, :borrowed_books, :visitor_id, :visitor_account_status 

    def initialize(name="")
        name.empty? ? provide_name : @name = name
        @borrowed_books = []
        @visitor_id = nil
        @visitor_account_status = nil        
    end

    def provide_name
        puts 'What is your name?'
        @name = gets.chomp.to_s
    end
end