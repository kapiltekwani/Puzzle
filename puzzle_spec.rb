require '~/work/Puzzle/restaurent'

describe "Restaurent" do

  it "should initialize restaurent object's restaurent_number & minimum_price attributes" do
    @restaurent = Restaurent.new('1')
    @restaurent.restaurent_number.should eq('1');
    @restaurent.minimum_price.should eq(-1)
  end
end
