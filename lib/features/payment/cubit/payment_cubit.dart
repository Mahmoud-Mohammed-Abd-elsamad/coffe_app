import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../presentation/payment_screen.dart';
part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());
  final String apiKey =
      'ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRBeE56RXpPQ3dpYm1GdFpTSTZJbWx1YVhScFlXd2lmUS5qZUdnSnk1b2NRcUtpN1Y0SXExS0FTcGVvWm5VM2lKU1hYV0t0cnNpVUlSMy1rSm01WjhtcTkwNGdyckZ4eVFpaUc5Z0o0UFlKUXB1Z19IUHg2cWh4Zw==';
  final String integrationId = '4923808';
  final String frameUrl =
      'https://accept.paymob.com/api/acceptance/iframes/893140?payment_token=';

  Future<String> payWithPayMob(double amount, BuildContext context) async {
    emit(PaymentLoading());
    try {
      String token = await getAuthToken(apiKey);
      int orderId = await createOrder(token, (100 * amount).toInt().toString());
      String paymentKey = await getPaymentKey(
          token, orderId.toString(), (100 * amount).toInt().toString());
      print('Payment Key: $paymentKey');

      emit(PaymentSuccess(message: paymentKey));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PaymentScreen(paymentUrl: '$frameUrl$paymentKey'),
        ),
      );
      return paymentKey;
    } catch (e) {
      print('Payment Error: $e');
      emit(PaymentError(message: e.toString()));
    }
    return '';
  }

//TODO This is the first function to get Auth token that used in second function.
  Future<String> getAuthToken(String apiKey) async {
    final response = await http.post(
      Uri.parse('https://accept.paymob.com/api/auth/tokens'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'api_key': apiKey}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(
          "jsonDecode(response.body)['token']${jsonDecode(response.body)['token']}");
      return jsonDecode(response.body)['token'];
    } else {
      throw Exception('Failed to get auth token');
    }
  }

//TODO This is the second function to create order to get orderId that used in third function.
  Future<int> createOrder(String authToken, String amount) async {
    final response = await http.post(
      Uri.parse('https://accept.paymob.com/api/ecommerce/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken'
      },
      body: jsonEncode({
        'auth_token': authToken,
        'delivery_needed': "true",
        'amount_cents': amount,
        'currency': 'EGP',
        // todo I should put items here
        'items': [],
      }),
    );
    print(amount);

    if (response.statusCode == 201) {
      print(
          "jsonDecode(response.body)['id']${jsonDecode(response.body)['id']}");
      return jsonDecode(response.body)['id'];
    } else {
      print(response.statusCode);
      throw Exception('Failed to create order');
    }
  }

//TODO This is the third function to get paymentKyToken that used in url to complete payment process.
  Future<String> getPaymentKey(
      String authToken, String orderId, String amount) async {
    final response = await http.post(
      Uri.parse('https://accept.paymob.com/api/acceptance/payment_keys'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken'
      },
      body: jsonEncode({
        'auth_token': authToken,
        'order_id': orderId,
        'amount_cents': amount,
        'currency': 'EGP',
        'billing_data': {
          'apartment': 'NA',
          'email': 'john.doe@example.com',
          'floor': 'NA',
          'first_name': 'John',
          'street': 'NA',
          'building': 'NA',
          'phone_number': '+201234567890',
          'shipping_method': 'NA',
          'postal_code': 'NA',
          'city': 'Cairo',
          'country': 'EG',
          'last_name': 'Doe',
          'state': 'NA',
        },
        'integration_id': integrationId,
        'lock_order_when_paid': "false",
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(
          "jsonDecode(response.body)['token']${jsonDecode(response.body)['token']}");
      return jsonDecode(response.body)['token'];
    } else {
      throw Exception('Failed to get payment key');
    }
  }
}
