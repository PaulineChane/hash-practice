
# This method will return an array of arrays.
# Each subarray will have strings which are anagrams of each other
# Time Complexity: O(n) if you pretend line 12 is a simple mathematically based hashing function,
# probably O (n * n log n) as for each string you have to sort the string to get a key for 
# the hash. 

# Space Complexity: O(n) - worst case is one string to one key, which is linearly dependent on 
# the number of strings in the input array -- for an array of N strings, the has will at minimum expand
# to hold N elements, and at most 2 * N elements

# assume all anagrams are unique 
def grouped_anagrams(strings)
  string_hash = {}

  strings.each do |string|
    key = string.split("").sort.join # probably an O(n log n) operation, I couldn't find an integer based hashing function i liked

    string_hash[key] ||= [] # trying this thing out
    string_hash[key] << string
  end
  
  return string_hash.values # also probably an O(n) operation
end

# This method will return the k most common elements
# in the case of a tie it will select the first occuring element.
# Time Complexity: O(n) - First runs through length of list, then all elements in list via list param, 
# then all hash objects in hash, then another array with size of list sequentially,
# which adds up to O(3n) or just O(n)

# Space Complexity: O(n) - Two arrays and one hash is created whose size 
# depend on the number of elements in the list. No nesting, stays O(n)
def top_k_frequent_elements(list, k)
  return [] if list.empty? 
  # list tracking quantities
  total_ele = list.length # O(n) operation
  return list if total_ele == 1
  top_k = Array.new(total_ele + 1){[]} # plus one for better tracking
  count_hash = {}

  # get frequencies of each element, O(n)
  list.each do |e|
    count_hash[e] ||= 1
    count_hash[e] += 1
  end

  # use a non-nested O(n) operation to sort
  # frequencies in top_k
  count_hash.each do |k,v|
    top_k[v] << k
  end

  return_arr = []
  
  # sort array in order now
  until total_ele == 0
    if(!top_k[total_ele].empty?)
      return_arr += top_k[total_ele]
    end

    total_ele -= 1
  end

  return return_arr[0...k]
end


# This method will return the true if the table is still
#   a valid sudoku table.
#   Each element can either be a ".", or a digit 1-9
#   The same digit cannot appear twice or more in the same 
#   row, column or 3x3 subgrid
# Time Complexity: I want to say this is O(1) since the number of elements in a 3x3 grid
# you have to check is always the same, and any lookups and inserts are O(1) since I'm not 
# only storing everything in a hash, but I'm mapping the keys to another hash. 

# Space Complexity: I also think if we are always using a 3x3 grid and inserting into a hash, 
# this should technically be O(1) since all of the hashes will only expand to the number of 
# elements in a 3x3 grid, which doesn't change, or would only increase by a constant.
def valid_sudoku(table)
  sudoku_box_hash = { [0, 0] => {}, [0, 1] => {}, [0, 2] => {},
                      [1, 0] => {}, [1, 1] => {}, [1, 2] => {},
                      [2, 0] => {}, [2, 1] => {}, [2, 2] => {}}

  sudoku_row_hash = { 1 => {}, 2 => {}, 3 => {},
                      4 => {}, 5 => {}, 6 => {},
                      7 => {}, 8 => {}, 9 => {}}
  
  sudoku_col_hash = { 1 => {}, 2 => {}, 3 => {},
                      4 => {}, 5 => {}, 6 => {},
                      7 => {}, 8 => {}, 9 => {}}

  sudoku_diagonal_hash = {1 => {}, 9 => {}}

  table.each_with_index do |arr, i|
    arr.each_with_index do |ele, j|
      next if ele == "."
      # check and add diagonals
      if i == j 
        return false if sudoku_diagonal_hash[1].include?(ele)
        sudoku_diagonal_hash[1][ele] = 1
      elsif i + j + 1 == 9 || i == 4 && j == 4
        return false if sudoku_diagonal_hash[9].include?(ele)
        sudoku_diagonal_hash[9][ele] = 1
      end

      # check these hashes for all elements
      return false if sudoku_row_hash[i + 1].include?(ele)
      return false if sudoku_col_hash[j + 1].include?(ele)
      return false if sudoku_box_hash[[i / 3, j / 3]].include?(ele)

      # can add if no return 
      sudoku_row_hash[i + 1][ele] = 1
      sudoku_col_hash[j + 1][ele] = 1
      sudoku_box_hash[[i / 3, j / 3]][ele] = 1 # based off calculating indices of ecah sudoku box
    end
  end

  return true
end
