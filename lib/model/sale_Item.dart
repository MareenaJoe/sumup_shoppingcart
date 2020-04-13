class SaleItem {
  int id;
  String name;
  double price;

  SaleItem({this.id, this.name, this.price});

  factory SaleItem.fromJson(Map<String, dynamic> item){
    return SaleItem(id: item['id'], name: item['name'], price: item['price']);
  }

  @override
  String toString() {
    return 'SaleItem{id: $id, name: $name, price: $price}';
  }
}