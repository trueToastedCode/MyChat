import 'dart:io';

import 'package:any1/colors.dart';
import 'package:any1/states_management/onboarding/profile_image_cubit.dart';
import 'package:any1/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileUpload extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 126.0,
      width: 126.0,
      child: Material(
        color: isLightTheme(context) ? Color(0xfff2f2f2) : Color(0xff211e1e),
        borderRadius: BorderRadius.circular(126.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(126.0),
          onTap: () async {
            await context.read<ProfileImageCubit>().getImage();
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: BlocBuilder<ProfileImageCubit, File?>(
                  builder: (context, state) {
                    return state == null
                        ? Icon(
                            Icons.person_outline_rounded,
                            size: 126.0,
                            color: isLightTheme(context)  ? kIconLight : Colors.black
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(126.0),
                            child: Image.file(
                              state,
                              width: 126, height: 126, fit: BoxFit.fill
                            ),
                          );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.add_circle_rounded,
                  color: kPrimary,
                  size: 38.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
