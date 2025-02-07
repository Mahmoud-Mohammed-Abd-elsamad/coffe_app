import 'package:coffe_app/features/home/presentation/cubit/coffe_items/coffee_items_cubit.dart';
import 'package:coffe_app/features/home/presentation/widgets/_coffe_item_list_widgets/coffee_item_shimmer_gridview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'coffee_item_grid_view.dart';

class BuildCoffeeItemsList extends StatefulWidget {
  const BuildCoffeeItemsList({super.key});

  @override
  State<BuildCoffeeItemsList> createState() => _CoffeeItemsListState();
}

class _CoffeeItemsListState extends State<BuildCoffeeItemsList> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<CoffeeItemsCubit>().fetchCoffeeItems();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoffeeItemsCubit, CoffeeItemsState>(
        builder: (context, state) {
      if (state is CoffeeItemsLoading) {
        return CoffeeItemShimmerGridview();
      }
      if (state is CoffeeItemsError) {
        return Center(child: Text(state.errorMessage));
      }
      if (state is CoffeeItemsSuccess) {
        var myItems = state.items;
        return CoffeeItemGridView(myItems: myItems);
      }
      return const SizedBox.shrink();
    });
  }
}
