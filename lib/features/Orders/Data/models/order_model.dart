import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffe_app/features/home/data/models/UserData/user_data.dart';
import 'package:coffe_app/features/home/data/models/coffe_item.dart';

class OrderModel {
  final List<CoffeeItem> myOrders;
  String stateOfTheOrder;
  String orderTotalPrice;
  DateTime orderStartDate;
  UserDataClass userDataClass;

  OrderModel(
      {required this.myOrders,
      required this.stateOfTheOrder,
      required this.orderTotalPrice,
      required this.orderStartDate,
      required this.userDataClass});

  factory OrderModel.fromJson(Map<String, dynamic> myData) {
    return OrderModel(
        myOrders: (myData['orders'] as List<dynamic>?)
                ?.map(
                    (data) => CoffeeItem.fromMap(data as Map<String, dynamic>))
                .toList() ??
            [],
        stateOfTheOrder: myData['stateOfTheOrder'],
        orderTotalPrice: myData['orderTotalPrice'] ?? '0',
        userDataClass: UserDataClass.fromJson(myData['userData']),
        orderStartDate: (myData['orderStartDate'] as Timestamp).toDate());
  }

  Map<String, dynamic> toJson() {
    return {
      'orders': myOrders.map((item) => item.toMap()).toList(),
      'stateOfTheOrder': stateOfTheOrder,
      'orderTotalPrice': orderTotalPrice,
      'orderStartDate': orderStartDate.toUtc(),
      'userData': userDataClass.toJson(),
    };
  }
}
