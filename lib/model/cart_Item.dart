import 'package:sumupshopping/model/sale_Item.dart';

class CartItem extends SaleItem {
  int countAdded = 0;
  double totalPrice = 0;

  CartItem(SaleItem saleItem){
   this.id = saleItem.id;
   this.price = saleItem.price;
   this.name = saleItem.name;
   incrementCount();
  }

  void incrementCount(){
    countAdded += 1;
    totalPrice = (price * countAdded);
  }
}