import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Orders/presentation/widgets/order_item.dart';
import '../../../home/data/models/coffe_item.dart';
import '../cubit/user_data_cubit.dart';

class DismissedCoffeeCartItem extends StatefulWidget {
  const DismissedCoffeeCartItem(
      {super.key, required this.cartItems, required this.index});
  final List<CoffeeItem> cartItems;
  final int index;

  @override
  State<DismissedCoffeeCartItem> createState() =>
      _DismissedCoffeeCartItemState();
}

class _DismissedCoffeeCartItemState extends State<DismissedCoffeeCartItem> {
  @override
  Widget build(BuildContext context) {
    return CustomOrderItem(
      coffeeItem: widget.cartItems[widget.index],
      onDecrease: () async {
        setState(() {
          widget.cartItems[widget.index].quantityInCart > 1
              ? widget.cartItems[widget.index].quantityInCart--
              : null;
        });
        await context.read<UserDataCubit>().updateQuantity(
            widget.cartItems[widget.index].selectedSize,
            widget.cartItems[widget.index].id,
            widget.cartItems[widget.index].quantityInCart);
      },
      onIncrease: () async {
        setState(() {
          widget.cartItems[widget.index].quantityInCart++;
        });
        await context.read<UserDataCubit>().updateQuantity(
            widget.cartItems[widget.index].selectedSize,
            widget.cartItems[widget.index].id,
            widget.cartItems[widget.index].quantityInCart);
      },
    );
  }
}
