import 'package:coffe_app/config/routes.dart';
import 'package:coffe_app/config/themes.dart';
import 'package:coffe_app/core/utils/app_colors.dart';
import 'package:coffe_app/core/utils/app_strings.dart';
import 'package:coffe_app/features/home/presentation/cubit/UserData_cubit/user_data_cubit.dart';
import 'package:coffe_app/features/notification/data/user_notifications.dart';
import 'package:coffe_app/features/payment/cubit/payment_cubit.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../features/Orders/Data/DataSource/user_orders_data_firebase.dart';
import '../features/Orders/Data/repo/user_orders_repo.dart';
import '../features/Orders/presentation/cubits/order_cubit/orders_cubit.dart';
import '../features/cart/Data/DataSource/user_data_firebase.dart';
import '../features/cart/Data/repo/user_data_repo.dart';
import '../features/cart/Presentation/cubit/user_data_cubit.dart';
import '../features/home/Domain/use_case/items_use_case.dart';
import '../features/home/data/DataSource/firebase_coffe.dart';
import '../features/home/data/models/coffe_item.dart';
import '../features/home/data/repos/data_repo.dart';
import '../features/home/presentation/cubit/category_cubit/category_cubit.dart';
import '../features/home/presentation/cubit/coffe_items/coffee_items_cubit.dart';
import '../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final directory = await getApplicationDocumentsDirectory();

  Hive.init(directory.path);
  Hive.registerAdapter(CoffeeItemAdapter());
  Hive.registerAdapter(IngredientAdapter());

  await Hive.openBox<CoffeeItem>(AppStrings.hiveBoxName);

  runApp(
      // DevicePreview(
      // builder: (context) =>
      MultiBlocProvider(providers: [
    BlocProvider(
        create: (context) => CategoryCubit(
            DataRepo(coffeeDataSource: CoffeeDataSource()), ItemsUseCse())),
    BlocProvider(create: (context) => UserDataCubit(UserDataRepo(UserData()))),
    BlocProvider(
      create: (context) => CoffeeItemsCubit(ItemsUseCse()),
    ),
    BlocProvider(
      create: (context) => UserDataClassCubit(),
    ),
    BlocProvider(
      create: (context) => OrdersCubit(UserOrdersRepo(OrderDataFirebase())),
    ),
    BlocProvider(create: (context) => PaymentCubit())
  ], child: CoffeeShopApp())
      //)
      );

  Future.delayed(Duration(seconds: 2), () {
    FlutterNativeSplash.remove();
  });
}

class CoffeeShopApp extends StatelessWidget {
  const CoffeeShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        darkTheme: darkTheme,
        theme: darkTheme,
        themeMode: ThemeMode.dark,

        // theme: ThemeData(
        //     bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        //       backgroundColor: Colors.white,
        //       type: BottomNavigationBarType.fixed,
        //     ),
        //     fontFamily: 'Poppins',
        //     scaffoldBackgroundColor: AppColorsDarkTheme.darkBlueAppColor,
        //     textSelectionTheme: const TextSelectionThemeData(
        //         cursorColor: AppColors.brownAppColor)),
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: AppStrings.splash,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
