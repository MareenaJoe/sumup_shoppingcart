
import 'sale_Item.dart';

class Event{
  String eventID;
  String eventTitle;
  String eventContent;
  List<SaleItem> saleItemList;
  DateTime createDateTime;

  Event({this.eventID, this.eventTitle, this.saleItemList, this.eventContent,this.createDateTime });

  factory Event.fromJson(Map<String, dynamic> item){
    Event event = Event(
        eventID: item['eventID'],
        eventTitle: item['eventTitle'],
        eventContent: item['eventContent'],
        createDateTime: DateTime.parse(item['createDateTime'])
    );
    event.setSaleItemsList(item["saleItemList"]);
    return event;
  }

  void setSaleItemsList(dynamicItem) {
    List<SaleItem> tmpSaleItemsList = <SaleItem>[];
    for (var item in dynamicItem){
      tmpSaleItemsList.add(SaleItem.fromJson(item));
    }
    saleItemList = tmpSaleItemsList;
  }

  @override
  String toString() {
    return 'Event{eventID: $eventID, eventTitle: $eventTitle, eventContent: $eventContent, saleItemList: $saleItemList, createDateTime: $createDateTime}';
  }
}