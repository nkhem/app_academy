require 'byebug'

#### base two <=> base ten conversion methods ####
def binarify(base_ten_num)
  base_ten_num.to_s(2)
end

def base_tenify(base_two_num)
  base_two_num.to_i(2)
end

def binary_ones_count(base_ten_num)
  binarify(base_ten_num).count('1')
end

#### perfect square helper methods ####
def is_perfect_square?(num)
  return false if num < 1
  Math.sqrt(num) % 1 === 0
end

def next_perfect_square(num)
  return 1 if num < 1
  is_perfect_square?(num) ? next_perfect_square(num + 1) : Math.sqrt(num).ceil**2
end

def prev_perfect_square(num)
  return nil if num <= 1
  is_perfect_square?(num) ? prev_perfect_square(num - 1) : Math.sqrt(num).floor**2
end

#### perfect bit helper methods ####
def is_perfect_bit?(base_ten_num)
  is_perfect_square?(binary_ones_count(base_ten_num))
end

def next_perfect_bit(base_ten_num, is_initial_recursion = true)
  return 1 if base_ten_num < 1

  if is_initial_recursion || !is_perfect_bit?(base_ten_num)
    next_num = base_ten_num + 1
    return next_perfect_bit(next_num, false)

  # cut out when hits a perfect bit that isn't the initial num
  elsif is_perfect_bit?(base_ten_num)
    return base_ten_num
  end
end

def prev_perfect_bit(base_ten_num, is_initial_recursion = true)
  return nil if base_ten_num < 1

  if is_initial_recursion || !is_perfect_bit?(base_ten_num)
    prev_num = base_ten_num - 1
    return prev_perfect_bit(prev_num, false)

  # cut out when hits a perfect bit that isn't the initial num
  elsif is_perfect_bit?(base_ten_num)
    return base_ten_num
  end
end

#### binary base helper methods ####
def is_binary_base?(num)
  binarify(num).count('1') == 1
end

def next_binary_base(base_ten_num)
  return 0 if base_ten_num < 0
  return 1 if base_ten_num == 0
  next_base = 2**(binary_order_of_magnitude(base_ten_num) + 1)
end

def prev_binary_base(base_ten_num)
  return nil if base_ten_num < 1
  return 0 if base_ten_num === 1
  return base_ten_num - 1 if base_ten_num < 3

  prev_base = 2**(binary_order_of_magnitude(base_ten_num))
  prev_base === base_ten_num ? prev_binary_base(prev_base - 1) : prev_base
end

def initial_base_ten_binary_base_in_range(num1, num2)
  return nil if num2 < 1
  return num1 if is_binary_base?(num1)
  next_base = next_binary_base(num1)
  return next_base if next_base <= num2
  nil
end

def final_base_ten_binary_base_in_range(num1, num2)
  return num2 if is_binary_base?(num2)
  prev_base = prev_binary_base(num2)
  return prev_base if prev_base >= num1
  nil
end


#### combinatoric helper methods ####
def factorial(n)
  (1..n).inject(:*) || 1
end

#how many 3-digit unique permutation sets exist with n possible nums
def uniq_permutations_count(slots_count, nums_count)
  uniq_perms_count = factorial(nums_count)/factorial(nums_count - slots_count)
  uniq_perms_count/factorial(slots_count)
end

def uniq_permutations_count_w_set_ones_and_zeroes(ones_count, zeroes_count)
  factorial(ones_count + zeroes_count)/(factorial(ones_count) * factorial(zeroes_count))
end

# given '110101' in a sorted list of permutations, how many perms precede it with the exact same combination of bits?
def prev_permutations_count(base_ten_num)
  base_two_num = binarify(base_ten_num)
  bits_arr = base_two_num.chars.slice(1..base_two_num.length)
  count = 0

  idx = 0

  until bits_arr.length <= 1
    if idx.to_s === bits_arr.first
      bits_arr.shift
      idx = 0
    else
      dynamic_chunk = bits_arr.slice((idx + 1)..bits_arr.length)
      ones_count = dynamic_chunk.count('1')
      zeroes_count = dynamic_chunk.count('0')

      # add to ones count if idx == 0, otherwise subtract
      # add to zeroes count if idx = 1, otherwise subtract
      if idx === 0
        ones_count += 1
        zeroes_count -= 1
      else
        ones_count -= 1
        zeroes_count += 1
      end

      count += uniq_permutations_count_w_set_ones_and_zeroes(ones_count, zeroes_count)
      idx += 1
    end
  end

  count
end

### miscellaneous helper methods ###
def binary_order_of_magnitude(base_ten_num)
  binarify(base_ten_num).chars.count - 1
end

def remove_index(arr, idx)
  arr.slice(0...idx) + arr.slice((idx + 1)..arr.length)
end

def dynamic_chunk(base_two_num)
  return '' unless base_two_num.index('0')

  #remove initial ones
  num = base_two_num.slice((base_two_num.index('0'))..base_two_num.length)

  first_one_idx = num.index('1')

  if first_one_idx

    # change first 1 to 0
    num[first_one_idx] = '0'

    #slice off first 0, because 1 will have shifted over there
    return num.slice(1..num.length)
  else
    return num
  end

end

def no_binary_bases_in_range?(num1, num2) #(16,32) deliberately returns true
  return !is_binary_base?(num1) if num1 == num2
  return false if is_binary_base?(num1) || is_binary_base?(num2)
  (next_binary_base(num1) > num2) && prev_binary_base(num2) && (prev_binary_base(num2) < num1)
end

def has_min_two_binary_bases_in_range?(num1, num2)
  return false if num1 == num2
  binary_bases = []
  binary_bases << num1 if is_binary_base?(num1)
  binary_bases << num2 if is_binary_base?(num2)

  first_binary_base = next_binary_base(num1)
  last_binary_base = prev_binary_base(num2)

  binary_bases << first_binary_base if first_binary_base < num2
  binary_bases << last_binary_base if last_binary_base > num1

  binary_bases.uniq.count >= 2
end

#17, [16,32]==>true
#16, [16,32]==>true
#32, [16,32]==>false
#33, [16,32]==>false
def is_in_noninclusive_range?(x, range)
  x >= range[0] && x < range[1]
end