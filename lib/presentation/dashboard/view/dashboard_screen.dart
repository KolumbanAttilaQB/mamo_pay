import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamopay_clone/presentation/dashboard/core/balance_cubit.dart';
import 'package:mamopay_clone/presentation/dashboard/view/send_money/view/send_money_screen.dart';
import 'package:mamopay_clone/presentation/onboarding/view/onboarding_screen.dart';
import 'package:mamopay_clone/utils/colors/colors.dart';
import 'package:mamopay_clone/utils/constants.dart';
import 'package:mamopay_clone/utils/spacing/spacing.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Mamo Pay balance',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
        centerTitle: false,
        backgroundColor: AppColors.baseColor,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: GestureDetector(
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const OnboardingScreen(),
                  ),
                      (Route<dynamic> route) => false,
                );
              },
              child: Container(
                height: 40,
                width: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColors.avatarBgColor, shape: BoxShape.circle),
                child: const Text('A',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.baseColor,
      body: BlocProvider(
        create: (context) =>
        BalanceCubit(FirebaseFirestore.instance, FirebaseAuth.instance)
          ..fetchUserData(),
        child: Stack(
          children: [
            SizedBox(
              height: screenHeight * 1,
              child: SizedBox(
                height: screenHeight * 0.4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: BlocBuilder<BalanceCubit, BalanceState>(
                    builder: (BuildContext balanceContext, balanceState) {
                      return Column(
                        children: [
                          MySpacing.spacingSH,
                          _balance(balanceState, context),
                          MySpacing.spacingMH,
                          _buttons(balanceState, balanceContext)
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                height: screenHeight * 0.6,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0))),
                child: _history(),
              ),
            )
          ],
        ),
      ),
    );
  }

  _balance(BalanceState balanceState, BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    if (balanceState is BalanceLoading ||
        balanceState is BalanceAddMoneyLoading) {
      return SizedBox(
        height: screenHeight * .1,
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    } else if (balanceState is BalanceFailure) {
      return const Center(
        child: Text('Error occurred, please try again later.'),
      );
    } else if (balanceState is BalanceLoaded) {
      return SizedBox(
        height: screenHeight * .1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Text(
                'AED ${balanceState.userData.money}',
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  _buttons(BalanceState balanceState, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _button(
              title: 'Add Money',
              icon: balanceState is BalanceAddMoneyLoading
                  ? Padding(
                padding: const EdgeInsets.all(5.0),
                child: CircularProgressIndicator(
                  color: AppColors.baseColor,
                ),
              )
                  : const Icon(
                Icons.add,
                color: Colors.black,
                size: 25,
              ),
              onTap: () {
                context.read<BalanceCubit>().addMoney(100.0, context);
              }),
          _button(
              title: 'Send Money',
              icon: const Icon(
                Icons.send,
                color: Colors.black,
                size: 25,
              ),
              onTap: () async {
                if (balanceState is BalanceLoaded) {
                 await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SendMoneyScreen(userModel: balanceState.userData,)),
                  ).then((c) {
                    if(!context.mounted) return;
                    context.read<BalanceCubit>().fetchUserData();

                    if(c == true) {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: const Text('Mamo Pay'),
                            content: const Text('Money sent.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(dialogContext)
                                      .pop(); // Dismiss alert dialog
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else if(c == false){
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: const Text('Mamo Pay'),
                            content: const Text('Error occurred, please try again later.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(dialogContext)
                                      .pop(); // Dismiss alert dialog
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                 });
                }
              }),
          _button(
              title: 'More',
              icon: const Icon(
                Icons.more_horiz,
                color: Colors.black,
                size: 25,
              ),
              onTap: () {})
        ],
      ),
    );
  }

  _button({required String title,
    required Widget icon,
    required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: const BoxDecoration(
                color: Colors.white, shape: BoxShape.circle),
            child: icon,
          ),
          MySpacing.spacingMH,
          Text(title, style: const TextStyle(fontSize: 16, color: Colors.white))
        ],
      ),
    );
  }

  _history() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            _historySearchLine(),
            _historyTile(
                avatar: Constants.dummyPerson,
                type: 'Sent',
                name: 'Hayfa Saliba',
                money: 350),
            _historyTile(
                avatar: Constants.dummyPerson,
                type: 'Sent',
                name: 'Hayfa Saliba',
                money: 4440),
            _historyTile(
                avatar: Constants.dummyPerson,
                type: 'Sent',
                name: 'Hayfa Saliba',
                money: 31250)
          ],
        ),
      ),
    );
  }

  _historySearchLine() {
    return ListTile(
      title: const Text('28 October'),
      trailing: Container(
          height: 40,
          width: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: AppColors.lightBtnColor, shape: BoxShape.circle),
          child: Icon(
            Icons.search,
            color: AppColors.baseColor,
          )),
    );
  }

  _dateTile() {
    return const ListTile(
      title: Text('20 October'),
    );
  }

  _historyTile({required String avatar,
    required String name,
    required String type,
    required double money}) {
    return ListTile(
      leading: Stack(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: CachedNetworkImage(
              imageUrl: avatar,
              imageBuilder: (context, imageProvider) =>
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fill,
                        )),
                  ),
              placeholder: (context, url) => const SizedBox(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
                height: 20,
                width: 20,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: const Icon(
                  Icons.arrow_downward,
                  color: Colors.green,
                )),
          )
        ],
      ),
      title: Text(
        name,
        style: const TextStyle(fontSize: 16),
      ),
      subtitle: Text(
        type,
        style: TextStyle(fontSize: 14, color: AppColors.grey),
      ),
      trailing: Text(
        'AED $money',
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
