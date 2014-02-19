require 'csv'
require './restaurent'
require './puzzle'

describe Puzzle do
  context "on invoking of 'read_menu' method" do
    before(:each) do
      @puzzle = Puzzle.new
      @puzzle.read_menu('test_data.csv')
    end
   
    it "'item_hash' attribute's value should not be an empty hash" do
      @puzzle.item_hash.should_not eq({})
      @puzzle.item_hash.should eq({"burger"=>{"1"=>{0=>4.0, 3=>2.0}, "3"=>{7=>3.0}, "4"=>{12=>2.0, 14=>2.0, 15=>6.0}, "5"=>{17=>0.0}}, "pizza"=>{"1"=>{1=>3.0}, "2"=>{4=>3.0, 6=>6.0}, "4"=>{11=>5.0, 13=>0.0, 14=>2.0}}, "hotdog"=>{"1"=>{2=>6.0}, "2"=>{5=>0.0}, "3"=>{8=>2.0, 9=>1.0}, "4"=>{13=>0.0, 15=>6.0}}, "cake"=>{"4"=>{10=>4.0}}, "fries"=>{"5"=>{16=>0.0}}})
    end

    it "'max_price_hash' attribute's value should not be an empty hash" do
      @puzzle.max_price_hash.should_not eq({})
      @puzzle.max_price_hash.should eq({"1"=>6.0, "2"=>6.0, "3"=>3.0, "4"=>6.0, "5"=>0.0})
    end
  end

  context "on invoking of 'init_max_price_hash' method" do
    it "should assign (max_value + 1) in 'max_price_hash' to keys that have value as '0.0' or 'nil'" do
      @puzzle = Puzzle.new
      @puzzle.read_menu('test_data.csv')
      @puzzle.max_price_hash.should eq({"1"=>6.0, "2"=>6.0, "3"=>3.0, "4"=>6.0, "5"=>0.0})

      @puzzle.init_max_price_hash
      @puzzle.max_price_hash.should eq({"1"=>6.0, "2"=>6.0, "3"=>3.0, "4"=>6.0, "5"=>7.0})
    end
  end

  context "on invoking of 'get_available_restaurents' method" do
    before(:each) do
      @puzzle = Puzzle.new
      @puzzle.read_menu('test_data.csv')
      @puzzle.init_max_price_hash
    end
    
    it "should return list of restaurents that contains all items ordered by user" do
      @puzzle.get_available_restaurents(['burger'])   
      @puzzle.restaurents.collect(&:restaurent_number).should eq(['1','3', '4', '5'])
    end
    
    it "should return list of restaurents that contains all items ordered by user" do
      @puzzle.get_available_restaurents(['fries'])   
      @puzzle.restaurents.collect(&:restaurent_number).should eq(['5'])
    end

    it "should return list of restaurents that contains all items ordered by user" do
      @puzzle.get_available_restaurents(['burger', 'pizza'])   
      @puzzle.restaurents.collect(&:restaurent_number).should eq(['1', '4'])
    end
    
    it "should return list of restaurents that contains all items ordered by user" do
      @puzzle.get_available_restaurents(['pizza', 'burger'])   
      @puzzle.restaurents.collect(&:restaurent_number).should eq(['1', '4'])
    end
    
    it "should return list of restaurents that contains all items ordered by user" do
      @puzzle.get_available_restaurents(['burger', 'pizza', 'hotdog'])   
      @puzzle.restaurents.collect(&:restaurent_number).should eq(['1', '4'])
    end
  end

  context "on invoking of 'get_optimized_price' method" do
    before(:each) do
      @puzzle = Puzzle.new
      @puzzle.read_menu('test_data.csv')
      @puzzle.init_max_price_hash
    end

    it "should return the restaurent_no offering all items ordered by user at minimum cost" do
      @puzzle.get_available_restaurents(['burger'])   
      @puzzle.get_optimized_price(['burger'])
      @puzzle.restaurent_no.should eq('1')
      @puzzle.minimum_price.should eq(2.0)
    end
    
    it "should return the restaurent_no offering all items ordered by user at minimum cost" do
      @puzzle.get_available_restaurents(['fries'])   
      @puzzle.get_optimized_price(['fries'])
      @puzzle.restaurent_no.should eq('5')
      @puzzle.minimum_price.should eq(7.0)
    end
    
    it "should return the restaurent_no offering all items ordered by user at minimum cost" do
      @puzzle.get_available_restaurents(['pizza', 'burger'])   
      @puzzle.get_optimized_price(['pizza', 'burger'])
      @puzzle.restaurent_no.should eq('4')
      @puzzle.minimum_price.should eq(2.0)
    end
    
    it "should return the restaurent_no offering all items ordered by user at minimum cost" do
      @puzzle.get_available_restaurents(['burger', 'pizza'])   
      @puzzle.get_optimized_price(['burger', 'pizza'])
      @puzzle.restaurent_no.should eq('4')
      @puzzle.minimum_price.should eq(2.0)
    end
    end
  end
end
