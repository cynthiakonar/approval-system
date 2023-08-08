import 'package:approval_system/utils/responsive.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

// ignore: must_be_immutable
class Header extends StatelessWidget {
  Header({
    Key? key,
    required this.role,
  }) : super(key: key);
  final String role;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 30,
        ),
        SizedBox(width: defaultPadding),
        Text(
          "Dashboard",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        ProfileCard(role: role)
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
    required this.role,
  }) : super(key: key);
  final String role;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Image.asset(
            "assets/images/profile_pic.png",
            height: 38,
          ),
          if (!Responsive.isMobile(context))
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text(role),
            ),
          Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}
