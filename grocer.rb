require 'pry'

def consolidate_cart(cart)
  cart_hash = {}
  counter = 0
  
  while (cart[counter]) do
    item = "#{cart[counter].keys[0]}"
    if (cart_hash.has_key?(item) == false) then
      cart_hash[item] = cart[counter].values[0]
      cart_hash[item].store(:count, 1)
    elsif (cart_hash.has_key?(item)) then
      cart_hash[item][:count] += 1
    end
    counter += 1
  end

  return cart_hash
  
end

def apply_coupons(cart, coupons)
	counter = 0
	while coupons[counter] do
		item = coupons[counter][:item]
		item_w_coupon = "#{item} W/COUPON"
		
		#Check if the item is in the cart and there are enough for the coupon
		if (cart.has_key?(item)) then 
		  if (cart[item][:count] >= coupons[counter][:num]) then
		  
		  #subtract the couponed items from the count of the item in the cart
			cart[item][:count] -= coupons[counter][:num]
			
			#check if there are already couponed items of this type in the cart
			if (cart.has_key?(item_w_coupon)) then

			  #if so, increment the count with the new couponed items
			  cart[item_w_coupon][:count] += coupons[counter][:num]
			else 
			  
			  #If there are no couponed items of this type in the cart, create a new hash to store them
			  cart.store(item_w_coupon, {:price => (coupons[counter][:cost] /coupons[counter][:num]), :clearance => cart[item][:clearance], :count => coupons[counter][:num]})
			end
  		end
  		end
		counter += 1
	end
	return cart
end
	

def apply_clearance(cart)
  new_cart = cart.map do |item|
    #binding.pry
    if item[1][:clearance] then  
      item[1][:price] *= 0.8 
      item[1][:price] = item[1][:price].round(2)
      end
    end
  
  return cart
end

def checkout(cart, coupons)
  cart_hash = consolidate_cart(cart)
  cart_hash = apply_coupons(cart_hash, coupons)
  cart_hash = apply_clearance(cart_hash)
  
  total = 0
  
  total = cart_hash.map { |item| item[1][:price]*item[1][:count] }.sum
  
  if (total > 100) then
    total *= 0.9
    total = total.round(2)
  end

  return total
end
