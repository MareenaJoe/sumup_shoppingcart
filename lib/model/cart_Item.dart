import 'package:sumupshopping/model/sale_Item.dart';

class CartItem extends SaleItem {
  int currentCount = 0;
  double totalPrice = 0;

  CartItem(SaleItem saleItem){
   this.id = saleItem.id;
   this.price = saleItem.price;
   this.name = saleItem.name;
   incrementCount();
  }

  void incrementCount(){
    currentCount += 1;
    totalPrice = (price * currentCount);
  }

  void decrementCount(){
    if (currentCount > 0){
      currentCount -= 1;
    }
    totalPrice = (price * currentCount);
  }
}