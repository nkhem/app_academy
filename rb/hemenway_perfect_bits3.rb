require 'byebug'

def binarify(base_ten_num)
  base_ten_num.to_s(2)
end

# p binarify(3)

def base_tenify(base_two_num)
  base_two_num.to_i(2)
end

def factorial(n)
  (1..n).inject(:*) || 1
end

def binary_order_of_magnitude(num)
  binarify(num).chars.count - 1
end

def is_perfect_square?(num)
  return false if num < 1
  Math.sqrt(num) % 1 == 0
end

def next_perfect_square(num)
  return 1 if num < 1
  is_perfect_square?(num) ? next_perfect_square(num + 1) : Math.sqrt(num).ceil**2
end

def next_binary_base(base_ten_num)
  2**(binary_order_of_magnitude(base_ten_num) + 1)
end

def prev_binary_base(base_ten_num)
  2**(binary_order_of_magnitude(base_ten_num))
end

def is_binary_base?(num)
  binarify(num).count('1') == 1
end


def initial_base_ten_binary_base_in_range(num1, num2)
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

#how many 3-digit unique permutation sets exist with n possible nums
def uniq_permutations_count(slots_count, nums_count)
  # debugger
  uniq_perms_count = factorial(nums_count)/factorial(nums_count - slots_count)

  #uniq perm sets
  uniq_perms_count/factorial(slots_count)
end

def uniq_permutations_count_w_set_ones_and_zeroes(slots_count, ones_count, zeroes_count)
  factorial(slots_count)/(factorial(ones_count) * factorial(zeroes_count))
end


def remaining_uniq_permutations_count(base_ten_num)
  base_two_num = binarify(base_ten_num)
# debugger
  # snip off initial ones
  broken_set = base_two_num.slice((base_two_num.index('0'))..base_two_num.length)

  #snip off next initial zeroes
  broken_set = broken_set.slice(1..broken_set.length)

  #snip off any remaining initial ones
  broken_set = broken_set.slice((base_two_num.index('0') + 1)..broken_set.length)

  #find all uniq perms of what remains
  broken_set_perm_count = uniq_permutations_count_w_set_ones_and_zeroes(broken_set.length, (broken_set.count('1') - 1), (broken_set.count('0') + 1))

  full_set = base_two_num.slice((base_two_num.index('0') + 1)..base_two_num.length)
  full_set_perm_count = uniq_permutations_count_w_set_ones_and_zeroes(full_set.length, (full_set.count('1') - 1), (full_set.count('0') + 1))
  broken_set_perm_count + full_set_perm_count + 1
end

p remaining_uniq_permutations_count(53)# == 3
p remaining_uniq_permutations_count(43)# == 6

def count_perms_fully_in_noninclusive_range(num1, num2)
  min_binary_o_of_mag = binary_order_of_magnitude(initial_base_ten_binary_base_in_range(num1, num2))
  max_binary_o_of_mag = binary_order_of_magnitude(final_base_ten_binary_base_in_range(num1, num2))

  count = 0

  current_sq = 1
  current_o_of_mag = min_binary_o_of_mag

  while current_o_of_mag < max_binary_o_of_mag
    count += uniq_permutations_count((current_sq - 1), current_o_of_mag)

    next_sq = next_perfect_square(current_sq)
# debugger
    if next_sq > max_binary_o_of_mag
      current_o_of_mag += 1
      current_sq = 1
    else
      current_sq = next_sq
    end
  end
  count
end

# p '---'
# p count_perms_fully_in_noninclusive_range(2,16) == 4
# p count_perms_fully_in_noninclusive_range(2,17) == 4
# p '---'
# p count_perms_fully_in_noninclusive_range(4,16) == 3
# p count_perms_fully_in_noninclusive_range(3,17) == 3
# p count_perms_fully_in_noninclusive_range(3,31) == 3
#
# p '---'
# p count_perms_fully_in_noninclusive_range(10,67) == 16
# p count_perms_fully_in_noninclusive_range(16,64) == 16
#
# p '---'
# p count_perms_fully_in_noninclusive_range(3,70) == 19
# p count_perms_fully_in_noninclusive_range(4,64) == 19
#
# p '---'
# p count_perms_fully_in_noninclusive_range(32,64) == 11
# p count_perms_fully_in_noninclusive_range(32,65) == 11
# p '---'
# p count_perms_fully_in_noninclusive_range(32, 1152921504606846976)

def count_perms_in_initial_range(num1, num2)
  current_sq = binarify(num1).count('1')
  current_o_of_mag = binary_order_of_magnitude(num1)

  # remaining_count_in_current_set =
  # num1 is in the middle of a permutation set
  # num2 is the end, which should be non_inclusive
end

def count_perms_in_upper_range(num1, num2)
end

def perfect_bits(num1, num2)
  count = 0

  if binary_order_of_magnitude(num1) == binary_order_of_magnitude(num2)
  else
    count += count_perms_in_initial_range(num1, num2)
    count += count_perms_fully_in_noninclusive_range(num1, num2)
    count += count_perms_in_upper_range(num1, num2)
  end

end

#
# def perfect_squares_in_base_ten_range(min_num, max_num)
#   squares_in_range = []
#   min_digit_count = binary_order_of_magnitude(min_num)
#   max_digit_count = binary_order_of_magnitude(max_num)
#
#   (min_digit_count..max_digit_count).each do |num|
#     num
#   end
# end