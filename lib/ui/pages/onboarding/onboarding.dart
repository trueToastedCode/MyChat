import 'package:any1/colors.dart';
import 'package:any1/states_management/onboarding/onboarding_cubit.dart';
import 'package:any1/states_management/onboarding/onboarding_state.dart';
import 'package:any1/states_management/onboarding/profile_image_cubit.dart';
import 'package:any1/ui/pages/onboarding/boarding_router_contract.dart';
import 'package:any1/ui/widgets/onboarding/logo.dart';
import 'package:any1/ui/widgets/profile_upload/profile_upload.dart';
import 'package:any1/ui/widgets/shared/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Onboarding extends StatefulWidget {
  final IOnboardingRouter router;
  const Onboarding(this.router);
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  // TODO disable join button while loading is in progress
  static const _SPINKIT = SpinKitRing(
      color: kPrimary,
      size: 23.0,
      lineWidth: 2.0);
  String _username = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _logo(context),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: ProfileUpload(),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(left: 50.0, right: 50.0),
                  child: CustomTextField(
                    hint: 'What\'s u\'re name? :)',
                    height: 45.0,
                    onChanged: (str) => _username = str,
                    inputAction: TextInputAction.done,
                  ),
                ),
                SizedBox(height: 25.0),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      final error = _checkInputs();
                      if (error.isNotEmpty) {
                        _showError(error);
                        return;
                      }
                      FocusScope.of(context).unfocus();
                      final success = await _connectSession();
                      if (!success) _showError('Unable to connect');
                    },
                    child: Container(
                      height: 45.0,
                      alignment: Alignment.center,
                      child: Text('Let\'s go!',
                        style: Theme.of(context).textTheme.button!.copyWith(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: kPrimary,
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 90,
              child: _loading(context),
            ),
          ],
        ),
      ),
    );
  }

  _loading(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      builder: (context, state) => state is Loading
          ? _SPINKIT
          : Container(),
      listener: (_, state) {
        if (state is OnboardingSuccess)
          widget.router.onSessionSuccess(context, state.user);
      },
    );
  }

  _logo(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('MyChat',
          style: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 8.0),
        Logo(),
        SizedBox(width: 10.0),
        Text('Hola!',
          style: Theme.of(context)
              .textTheme
              .headline3!
              .copyWith(fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Future<bool> _connectSession() async {
    final profileImage = context.read<ProfileImageCubit>().state;
    return await context.read<OnboardingCubit>().connect(_username, profileImage!);
  }

  String _checkInputs() {
    String error = '';
    if (_username.isEmpty)
      error = 'Enter display name';
    if (context.read<ProfileImageCubit>().state == null)
      error += '\nUpload profile image';
    return error;
  }

  void _showError(String error) {
    final snackBar = SnackBar(
      content: Text(
        error, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
