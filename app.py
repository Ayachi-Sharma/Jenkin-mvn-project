def calculate_total(price, quantity):
    return price * quantity


item_price = 100
quantity = 3

total = calculate_total(item_price, quantity)
print(f"Invoice total: ₹{total}")