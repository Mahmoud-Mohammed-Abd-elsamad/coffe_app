import 'package:coffe_app/features/payment/wallet_payment.dart';
import 'package:flutter/material.dart';

class PayWithWallet extends StatelessWidget {
  const PayWithWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await PayMobWalletManager()
            .getPaymentKeyForWallet(300, "+201204154971");
      },
      child: Container(
        width: 130,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.green,
        ),
        child: const Center(
          child: Text(
            'Mobile Wallet',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
