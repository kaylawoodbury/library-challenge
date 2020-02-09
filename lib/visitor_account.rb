class Visitor
    attr_accessor :name, :borrowed_books, :id, :account_status 

    def initialize(name="")
        name.empty? ? provide_name : @name = name
        @borrowed_books = []
        @id = nil
        @account_status = nil        
    end

    private

    def provide_name
        raise ArgumentError, 'You must provide a name when you create an account'
    end
end