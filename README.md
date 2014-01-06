Puzzle
======

Restaurent Puzzle

How to run the program: 

ruby puzzle.rb test_data.csv pizza burger

============================================

Validations Handled

If a restaurent has same item with two prices, then the program will pick item with lower price.

If any row in input csv does not have restaurent_number, then that row will be ignored

If any row in input csv does not have item_name(s), then that row will be ignored

If any row in input csv does have price associated with item_name, price may be "", nil or negative, then price of that item is set to the price of costliest item in that restaurent because since we don't know the price, rather than ignoring that row, we will be showing that item with little more cost, so user will have an option to select that item for meal. In this way, we can atleast notify user with information required by him.




