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
import 'package:sumupshopping/model/event.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product.dart';

double _salesTaxRate = 0.06;
double _shippingCostPerItem = 7;

const API = 'http://192.168.0.178:8080';
const headers = {'Content-Type': 'application/json', 'Accept': 'application/json'};

enum Stage { ERROR, LOADING, DONE }

class AppStateModel extends foundation.ChangeNotifier {
  // All the available products.
  List<Product> _availableProducts;
  Stage stage = Stage.LOADING;

  String _platformVersion = 'Unknown';

//  // The currently selected category of products.
//  Category _selectedCategory = Category.all;

  // The IDs and quantities of products currently in the cart.
  final _productsInCart = <int, int>{};

  Map<int, int> get productsInCart {
    return Map.from(_productsInCart);
  }

  // Total number of items in the cart.
  int get totalCartQuantity {
    return _productsInCart.values.fold(0, (accumulator, value) {
      return accumulator + value;
    });
  }

//  Category get selectedCategory {
//    return _selectedCategory;
//  }

  // Totaled prices of the items in the cart.
  double get subtotalCost {
    return _productsInCart.keys.map((id) {
      // Extended price for product line
      return _availableProducts[id].price * _productsInCart[id];
    }).fold(0, (accumulator, extendedPrice) {
      return accumulator + extendedPrice;
    });
  }

  // Total shipping cost for the items in the cart.
  double get shippingCost {
    return _shippingCostPerItem *
        _productsInCart.values.fold(0.0, (accumulator, itemCount) {
          return accumulator + itemCount;
        });
  }

  // Sales tax for the items in the cart
  double get tax {
    return subtotalCost * _salesTaxRate;
  }

  // Total cost to order everything in the cart.
  double get totalCost {
    return subtotalCost + shippingCost + tax;
  }

  // Returns a copy of the list of available products, filtered by category.
  List<Product> getProducts() {
    if (_availableProducts == null) {
      return [];
    }

    return List.from(_availableProducts);

//    if (_selectedCategory == Category.all) {
//      return List.from(_availableProducts);
//    } else {
//      return _availableProducts.where((p) {
//        return p.category == _selectedCategory;
//      }).toList();
//    }
  }

  // Search the product catalog
  List<Product> search(String searchTerms) {
    return getProducts().where((product) {
      return product.name.toLowerCase().contains(searchTerms.toLowerCase());
    }).toList();
  }

  // Adds a product to the cart.
  void addProductToCart(int productId) {
    if (!_productsInCart.containsKey(productId)) {
      _productsInCart[productId] = 1;
    } else {
      _productsInCart[productId]++;
    }

    notifyListeners();
  }

  // Removes an item from the cart.
  void removeItemFromCart(int productId) {
    if (_productsInCart.containsKey(productId)) {
      if (_productsInCart[productId] == 1) {
        _productsInCart.remove(productId);
      } else {
        _productsInCart[productId]--;
      }
    }

    notifyListeners();
  }

  // Returns the Product instance matching the provided id.
  Product getProductById(int id) {
    return _availableProducts.firstWhere((p) => p.id == id);
  }

  // Removes everything from the cart.
  void clearCart() {
    _productsInCart.clear();
    notifyListeners();
  }

  void setProducts(List<Product> products) {
    _availableProducts = products;
    for (Product item in _availableProducts){
      print ("Setting product: " + item.toString());
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    await SumupFlutter.authenticate("221a8f9e-627f-493e-90be-ce3648f83789");
    await SumupFlutter.presentLoginView();


//    // If the widget was removed from the tree while the asynchronous platform
//    // message was in flight, we want to discard the reply rather than calling
//    // setState to update our non-existent appearance.
//    if (!mounted) return;
//
//    setState(() {
//      _platformVersion = platformVersion;
//    });
  }


//  void setCategory(Category newCategory) {
//    _selectedCategory = newCategory;
//    notifyListeners();
//  }

  // Loads the list of available products from the repo.
  void loadAll() {
    initPlatformState();
    initProducts();
    //initEvents();
    notifyListeners();
  }

  void initProducts() {
    try {
      loadProducts();
      stage = Stage.DONE;
    } catch (e) {
      stage = Stage.ERROR;
    }
  }

  Future loadProducts() async{
    print("About to get products");
    final products = <Product>[];
    http.Response response = await http.get(API + '/products', headers: headers);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      for (var item in jsonData) {
        products.add(Product.fromJson(item));
      }
    }
    else {
      print("Data error");
    }
    setProducts(products);
  }

}