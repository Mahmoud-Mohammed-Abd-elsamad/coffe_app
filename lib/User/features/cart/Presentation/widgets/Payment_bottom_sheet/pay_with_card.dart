import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Orders/Data/models/order_model.dart';
import '../../../../home/data/models/coffe_item.dart';
import '../../../../payment/cubit/payment_cubit.dart';

class PayWithCard extends StatefulWidget {
  const PayWithCard(
      {super.key,
      required this.sheetContext,
      required this.amount,
      required this.cartItems,
      required this.orderModel});

  final BuildContext sheetContext;
  final double amount;
  final List<CoffeeItem> cartItems;
  final OrderModel orderModel;

  @override
  State<PayWithCard> createState() => _PayWithCardState();
}

class _PayWithCardState extends State<PayWithCard> {
  bool _isDisabled = false;

  void _disableInteraction() {
    setState(() {
      _isDisabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaymentCubit, PaymentState>(
      builder: (context, state) {
        if (state is PaymentError) {
          return Text('Payment failed: ${state.message}');
        }
        if (state is PaymentLoading) {
          _isDisabled ? null : _disableInteraction;
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.blue,
          ));
        }

        return GestureDetector(
          onTap: () {
            context.read<PaymentCubit>().payWithPayMob(
                widget.amount, widget.sheetContext, widget.orderModel);
          },
          child: Container(
            width: 130,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.blue,
            ),
            child: const Center(
              child: Text(
                'Card Payment',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
