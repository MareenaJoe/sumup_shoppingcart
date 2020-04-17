// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/foundation.dart' as foundation;
import 'package:sumup_flutter/sumup_flutter.dart';
import 'package:sumupshopping/model/cart_Item.dart';
import 'package:sumupshopping/service/events_service.dart';
import 'event.dart';
import 'sale_Item.dart';

enum Stage { ERROR, LOADING, DONE }

class AppStateModel extends foundation.ChangeNotifier {
  List<Event> _eventsAndProducts;
  Event _currentEvent;
  Stage stage = Stage.LOADING;

  // Loads the list of available products from the repo.
  void loadAll() {
    initPlatformState();
    initEvents();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    await SumupFlutter.authenticate("221a8f9e-627f-493e-90be-ce3648f83789");
    await SumupFlutter.presentLoginView();
  }


  Future<void> initEvents() async{
    EventsService service = EventsService();
    _eventsAndProducts = await service.loadEvents();
    notifyListeners();
  }

  List<Event> getEvents(){
    if (_eventsAndProducts == null){
      return [];
    }
    return List.from(_eventsAndProducts);
  }

  // The IDs and quantities of products currently in the cart.
  Map<int, CartItem> _productsInCart = <int, CartItem>{};

  List<CartItem> get productsInCart {
    return List.from(_productsInCart.values);
  }

  // Total number of items in the cart.
  int get totalCartQuantity {
    if (_productsInCart == null){
      return 0;
    }
    return _productsInCart.length;
  }

 // Total cost to order everything in the cart.
  double get totalCost {
    double totalCost = 0;
    _productsInCart.values.forEach((i) => totalCost += i.totalPrice);
    return totalCost;
  }

  // Adds a product to the cart.
  void addProductToCart(SaleItem saleItem) {
    CartItem savedItem = _productsInCart[saleItem.id];

    if (savedItem != null){
      savedItem.incrementCount();
      return;
    } else{
      CartItem cartItem = CartItem(saleItem);
      _productsInCart[saleItem.id] = cartItem;
    }
    notifyListeners();
  }

  //Remove a product from cart
  void removeProductFromCart(SaleItem item){
    CartItem removeItem = _productsInCart[item.id];
    if (removeItem != null){
      removeItem.decrementCount();
      if (removeItem.currentCount == 0){
        _productsInCart.remove(item.id);
      }
      return;
    }
    notifyListeners();

  }


  // Removes everything from the cart.
  void clearCart() {
    _productsInCart.clear();
    notifyListeners();
  }

  void setCurrentSelectedEvent(Event event) {
    print ("Selected event: "+ event.toString());
    _currentEvent = event;
    notifyListeners();
  }

  List<SaleItem> getProductsBySelectedEvent() {
    if (_currentEvent == null){
      return [];
    }
    return _currentEvent.saleItemList;
  }

  Event getCurrentSelectedEvent(){
    return _currentEvent;
  }


}