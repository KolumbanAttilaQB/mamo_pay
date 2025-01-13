import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mamopay_clone/presentation/auth/view/auth_screen.dart';
import 'package:mamopay_clone/presentation/auth/view/register_screen.dart';
import 'package:mamopay_clone/presentation/dashboard/view/dashboard_screen.dart';
import 'package:mamopay_clone/utils/spacing/spacing.dart';
import 'package:mamopay_clone/utils/widgets/button.dart';
import 'package:mamopay_clone/utils/colors/colors.dart';
import 'package:mamopay_clone/utils/constants.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: CarouselSlider(
                disableGesture: true,
                options: CarouselOptions(
                  height: screenHeight * 0.8,
                  aspectRatio: 16 / 9,
                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 15),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                ),
                items: _onboardingWidgets(context),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: screenWidth * 0.8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ConstrainedBox(
                        constraints:
                            BoxConstraints(minWidth: screenWidth * 0.8),
                        child: MyButtons().largeButton(
                            text: 'Large button',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DashboardScreen()),
                              );
                            },
                            btnColor: AppColors.baseColor,
                            txtColor: Colors.white),
                      )
                    ],
                  ),
                  MySpacing.spacingMH,
                  Padding(
                    padding: const EdgeInsets.only(bottom: kToolbarHeight),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: screenWidth * 0.8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: MyButtons().largeButton(
                                text: 'Login',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AuthScreen()),
                                  );
                                },
                                btnColor: AppColors.lightBtnColor,
                                txtColor: AppColors.baseColor),
                          ),
                          MySpacing.spacingMW,
                          Expanded(
                            child: MyButtons().largeButton(
                                text: 'Register',
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const RegisterScreen()),
                                  );
                                },
                                btnColor: AppColors.lightBtnColor,
                                txtColor: AppColors.baseColor),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _onboardingWidgets(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return List.generate(
      3,
      (index) => SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: screenHeight * 0.4,
              child: CachedNetworkImage(
                imageUrl: '${Constants.onboardingImageBase}${index + 1}.png',
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  )),
                ),
                placeholder: (context, url) => const SizedBox(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  Constants.onboardingText[index],
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ))
              ],
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
