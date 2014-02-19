MenuItem = Struct.new(:id ,:price)

class Restaurent
		
  attr_accessor :restaurent_number, :minimum_price
  
  def initialize(restaurent_number)
    self.restaurent_number = restaurent_number
    self.minimum_price = -1.0
  end

  #this functions checks that whether current combination of item_ids cover all items required by user
  def is_complete?(item_ids, item_hash)
    ARGV[1..-1].all? do |item|
      item_ids.collect{|item_id| item_hash[item][self.restaurent_number].keys.include?(item_id)}.uniq.include?(true)
    end
  end

  #this functions calculates the bill for each combination of item s fora given restaurent
  def bill_plate(plates, max_price_hash)
    bill_amt = 0.0
    plates.each do |plate|
      plate.price = max_price_hash[self.restaurent_number] if plate.price <= 0
      bill_amt += plate.price
    end
    bill_amt
  end

  #this functions returns the minimum price for which desired input menu will be available for a given restaurent
  def find_minimum(kitchen, m, n, plate, k, item_hash, max_price_hash)
    if !(kitchen[m].nil?)
      if !(kitchen[m][n].nil?)
        plate[k] = kitchen[m][n]
        k += 1 
        
        if is_complete?(plate.collect(&:id), item_hash)
          current_bill = self.bill_plate(plate.uniq, max_price_hash)

          if self.minimum_price == -1
            self.minimum_price = current_bill
          else
            if current_bill < self.minimum_price
              self.minimum_price = current_bill
            end
          end
        end

        self.minimum_price = find_minimum(kitchen, m+1, 0, plate, k, item_hash, max_price_hash)
        k -= 1
        self.minimum_price = find_minimum(kitchen, m, n+1, plate, k, item_hash, max_price_hash)
      end
    end
    self.minimum_price

  end

  def self.convert_into_structure(hash)
    array = []
    hash.each do |key, value|
      array << MenuItem.new(key, value )
    end
    array
  end
end




