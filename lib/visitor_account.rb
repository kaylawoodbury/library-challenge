class Visitor
    attr_accessor :name, :borrowed_books, :visitor_id, :visitor_account_status 

    def initialize(name="")
        name.empty? ? provide_name : @name = name
        @borrowed_books = []
        @visitor_id = nil
        @visitor_account_status = nil        
    end

    private

    def provide_name
        raise ArgumentError, 'Must include name to create account.'
    end
end