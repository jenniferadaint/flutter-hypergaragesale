import 'package:firebase_database/firebase_database.dart';
class Item {
  String key;
  String title;
  String price;
  String description;
  String url1;
  String url2;
  String url3;
  String url4;
  //Url urls;

  //Item(this.title, this.price, this.description, this.urls);

  Item(this.title, this.price, this.description,this.url1, this.url2, this.url3, this.url4);
  Item.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        title = snapshot.value["title"],
        price = snapshot.value["price"],
        description = snapshot.value["description"],
        url1 = snapshot.value["url1"],
        url2 = snapshot.value["url2"],
        url3 = snapshot.value["url3"],
        url4 = snapshot.value["url4"];






      toJson() {
    return {
      "title": title,
      "price": price,
      "description": description,
      "url1": url1,
      "url2": url2,
      "url3": url3,
      "url4": url4,

 };
  }
}


