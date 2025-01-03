import 'package:coffe_app/features/cart/Data/repo/user_data_repo.dart';
import 'package:coffe_app/features/home/data/models/coffe_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  UserDataCubit(this.dataRepo) : super(UserDataInitial());
  UserDataRepo dataRepo;
  List<CoffeeItem> userCart = [];

  Future fetchUserCart() async {
    emit(UserDataLoading());
    try {
      final List<CoffeeItem> userCartFirebase = await dataRepo.fetchCart();
      userCart = userCartFirebase;
      print(userCart.length);

      emit(UserDataSuccess(userCart));
    } on Exception catch (e) {
      emit(UserDataError(e.toString()));
    }
  }

  Future addToCart(CoffeeItem item) async {
    UserDataLoading();
    try {
      await fetchUserCart();
      userCart.add(item);
      await dataRepo.addToCart(userCart);
      print('Item added successfully');
      emit(UserDataCartUpdated(userCart));
    } catch (e) {
      print('Item failed');
      print(e.toString());
      emit(UserDataError(e.toString()));
    }
  }

  Future<void> deleteCart(CoffeeItem item) async {
    try {
      final currentState = state;
      if (currentState is UserDataSuccess) {
        userCart.remove(item);
        await dataRepo.addToCart(userCart);
        print('Item deleted successfully');
        final updatedCart = List.from(currentState.userCart)..remove(item);
        emit(UserDataSuccess(updatedCart));
      }
    } catch (e) {
      emit(UserDataError(e.toString()));
    }
  }
}
