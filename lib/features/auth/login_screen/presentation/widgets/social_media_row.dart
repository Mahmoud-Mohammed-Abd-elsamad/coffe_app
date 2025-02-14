import 'package:coffe_app/core/utils/app_strings.dart';
import 'package:coffe_app/core/utils/widgets/custom_loading_progress.dart';
import 'package:coffe_app/features/auth/data/authentication_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../../core/utils/app_colors.dart';

class SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool done;

  const SocialButton({
    super.key,
    required this.icon,
    required this.label,
    required this.done,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: done
          ? () async {
              try {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                    child: CustomLoadingProgress(),
                  ),
                );
                await AuthenticationMethods().signInWithGoogle();
                Navigator.pop(context);

                Navigator.pushNamed(context, AppStrings.home);
              } catch (e) {
                print('Failed to sign in with Google: $e');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Sign-in failed. Please try again.')));
              }
            }
          : () {
              Fluttertoast.showToast(
                  msg: "In progress...",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity
                      .BOTTOM, // You can change it to top, center, etc.
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
      child: Container(
        width: 80.w,
        height: 60.h,
        decoration: BoxDecoration(
          color: const Color(0xff16181C),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class SocialMediaRow extends StatelessWidget {
  const SocialMediaRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SocialButton(
            icon: FontAwesomeIcons.facebook,
            label: 'In progress',
            done: false,
          ),
          SocialButton(
            icon: FontAwesomeIcons.google,
            label: 'In progress',
            done: true,
          ),
        ],
      ),
    );
  }
}
