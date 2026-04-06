# Enhanced Features

## 1. Quantity‑Aware Delete Logic (Smart Delete Popup)

This feature upgrades the delete behavior to match real inventory workflows.  
Instead of instantly deleting an item when the trash icon is tapped, the app now displays a confirmation dialog with quantity‑based options.

### What This Feature Adds

- A confirmation popup appears before deleting an item.
- If an item has **quantity > 1**, the user can:
  - **Decrease the quantity by 1**, or
  - **Delete the entire item**
- If the quantity is **1**, only the full delete option is shown.
- Prevents accidental deletion of items that still have remaining stock.

### How It Works

- Tapping the trash icon opens an `AlertDialog`.
- The dialog checks the current quantity stored in Firestore.
- Depending on the quantity:
  - `update({'quantity': quantity - 1})`
  - or `delete()` for full removal.

### Why It Matters

- More realistic inventory management.
- Reduces user mistakes and accidental data loss.
- Supports workflows like selling, restocking, or adjusting stock levels.

---

## 2. Full Quantity Support in Add/Edit Item Form

The item form was enhanced to include a **quantity field**, making quantity a core part of the inventory model.

### What This Feature Adds

- Users can set quantity when adding a new item.
- Users can edit quantity when modifying an existing item.
- Validation ensures:
  - Quantity is required
  - Quantity must be numeric
  - Quantity cannot be negative

### How It Works

- Added a `quantityCtrl` controller to the form.
- Added `initialQuantity` for editing existing items.
- Updated `onSubmit` to return `(name, price, quantity)`.
- Firestore documents now include:

```json
{
  "name": "Item Name",
  "price": 10.0,
  "quantity": 5
}
```
