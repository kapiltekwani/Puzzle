class Puzzle
  attr_accessor :item_hash, :max_price_hash, :item_counter, :restaurents, :restaurent_no, :minimum_price

  def initialize
    self.item_hash, self.max_price_hash, self.item_counter, self.restaurents = {}, {}, 0, []
  end

  #this method is used to read the input csv file and
  #store the menu items in the hash(item_hash) to  calculate the price of items later
  #We also maintain max_price_hash(restaurent => max_price_item's price)
  #We use max_price_hash to assign prices to items of a restaurent where price is either 'nil' or 'negative'
  def make_menu_hash(row)
    #creating item_hash
    row[2..-1].each do |item|
      if self.item_hash.has_key?(item) 
        if self.item_hash[item].has_key?(row[0])
          self.item_hash[item][row[0]].merge!({self.item_counter => row[1].to_f}) 
        else
          self.item_hash[item].merge!({row[0] => {self.item_counter => row[1].to_f}}) 
        end
      else
        self.item_hash.merge!({item => {row[0] => {self.item_counter => row[1].to_f}}})
      end
    end
    
    #creating max_price_hash
    self.max_price_hash.has_key?(row[0]) ? (self.max_price_hash.merge!({row[0] => row[1].to_f}) if self.max_price_hash[row[0]] < row[1].to_f ): self.max_price_hash.merge!({row[0] => row[1].to_f})

    [self.item_hash, self.max_price_hash]
  end

  def read_menu(file_name)
    CSV.foreach(file_name) do |row|
      #if program encounters a row in csv in which either restaurent_no is missing
      #or item_name(s) is missing then we ignore that row.
      unless (row[0].nil? || row[2..-1].empty?)
        #this hash will be used after available restaurent selection to calculate the price of the meal
        self.item_hash, self.max_price_hash = make_menu_hash(row)
        self.item_counter += 1
      end
    end
  end

  def init_max_price_hash
  #then for those restaurents we are setting the value of maximum price item's price to be (max price of any item among all restaurents + 1)
    max_value = (self.max_price_hash.values.max + 1)
    self.max_price_hash.each do |key, value|
      self.max_price_hash[key] = max_value if max_price_hash[key] <= 0
    end
  end

  def get_available_restaurents(desired_items)
    available_restaurents= {}

    #code to find list of restaurents available for each dish
    desired_items.each {|item| available_restaurents[item] = (item_hash.has_key?(item) ? item_hash[item].keys : nil)}

    #displaying the list of restaurents available for each item that user has demanded
    available_restaurents.each {|key, value| puts "#{key} is available in restaurent numbers: #{value}"}

    #if one of input items desired is not present in any of restaurents, then result = [], else it will contain list of restaurent no's that contain all of desired input items
    if available_restaurents.values.include?(nil)
      result = []
    else
      result = available_restaurents.values.first
      available_restaurents.values[1..-1].each {|value| result = result & value}
    end


    if result.count > 0
      puts "Your desired menu is available at following restaurents: #{result}"
    else
      puts "No restaurent is available as per your wishlist"
      exit
    end

    result.each {|restaurent_number| restaurents << Restaurent.new(restaurent_number)}
  end
    
  #this is code is used to travarse all possible combinations of given list of desired input items
  #this code forms the base for calculating minimum price for the desired input item for given restaurent 
  def get_optimized_price(desired_items)
    for r in restaurents do
      counter = 0
      kitchen = []
      for item in desired_items do
        kitchen[counter] = Restaurent.convert_into_structure(item_hash[item][r.restaurent_number])
        counter += 1
      end
      plate, k  = [], 0
      r.minimum_price = r.find_minimum(kitchen, 0, 0, plate, k, item_hash, max_price_hash)
    end

    #finding the restaurent which is charging least price for desired input items
    final_restaurent = restaurents.sort_by{|r| r.minimum_price}.first

    self.restaurent_no, self.minimum_price = final_restaurent.restaurent_number, final_restaurent.minimum_price
    
    #displaying the solution
    puts "Restaurent No. #{self.restaurent_no}, Price: #{self.minimum_price}"
  end
end

