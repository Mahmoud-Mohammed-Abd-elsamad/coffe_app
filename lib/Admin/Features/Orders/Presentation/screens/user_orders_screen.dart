import 'package:coffe_app/Admin/Features/Orders/Presentation/cubits/get_all_users_cubit/get_all_orders_cubit.dart';
import 'package:coffe_app/Admin/Features/Orders/Presentation/screens/order-details.dart';
import 'package:coffe_app/core/utils/widgets/custom_loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_colors.dart';

class ManageOrdersScreen extends StatefulWidget {
  const ManageOrdersScreen({super.key});

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetAllOrdersCubit>().getAllOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          foregroundColor: AppColors.offWhiteAppColor,
          title: const Text('Manage Orders'),
          backgroundColor: AppColors.brownAppColor),
      body: BlocBuilder<GetAllOrdersCubit, GetAllOrdersState>(
        builder: (context, state) {
          if (state is GetAllOrdersLoading) {
            return Center(child: CustomLoadingProgress());
          } else if (state is GetAllOrdersFailure) {
            return Text('Failed to fetch orders');
          } else if (state is GetAllOrdersSuccess) {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderDetailsScreen(order: state.orders[index]),
                      )),
                  child: _buildOrderCard(
                      context,
                      state.orders.length.toString(),
                      state.orders[index].stateOfTheOrder),
                );
              },
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, String orderId, String status) {
    Color getColor() {
      switch (status.toLowerCase()) {
        case 'Pending':
          return AppColors.brownAppColor;
        case 'inProgress':
          return Colors.blue;
        case 'Cancelled':
          return Colors.red;
        case 'Completed':
          return Colors.green;
        default:
          return Colors.grey;
      }
    }

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: const Icon(Icons.coffee, color: AppColors.brownAppColor),
        title:
            Text(orderId, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Status: $status', style: TextStyle(color: getColor())),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'view') {
              Navigator.pushNamed(context, '/viewOrder');
            } else if (value == 'update') {
              // Handle update status logic here
            } else if (value == 'delete') {
              // Handle delete logic here
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'view', child: Text('View Details')),
            const PopupMenuItem(value: 'update', child: Text('Update Status')),
            const PopupMenuItem(value: 'delete', child: Text('Delete Order')),
          ],
        ),
      ),
    );
  }
}
