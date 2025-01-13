import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamopay_clone/core/entity/user_model.dart';
import 'package:mamopay_clone/presentation/dashboard/view/send_money/core/send_money_cubit.dart';
import 'package:mamopay_clone/presentation/dashboard/view/send_money/core/send_money_state.dart';
import 'package:mamopay_clone/utils/colors/colors.dart';
import 'package:mamopay_clone/utils/spacing/spacing.dart';
import 'package:mamopay_clone/utils/widgets/button.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key, required this.userModel});

  final UserModel userModel;

  @override
  _SendMoneyScreenState createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  bool isNextEnabled = false;

  List<String> categories = ['Family', 'School', 'Food', 'Transport'];
  String selectedCategory = '';
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();
  String? _errorText;

  void _validateAmount(String value) {
    setState(() {
      if (value.isEmpty) {
        _errorText = null;
      } else {
        double amount = double.tryParse(value) ?? 0.0;
        if (amount > widget.userModel.money) {
          _errorText = 'Please add money to your wallet.';
        } else {
          _errorText = null;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text('Enter amount'),
      ),
      body: BlocProvider(
        create: (context) =>
            SendMoneyCubit(FirebaseFirestore.instance, FirebaseAuth.instance),
        child: BlocConsumer<SendMoneyCubit, SendMoneyState>(
          builder: (BuildContext sendContext, sendState) {
              return Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Mamo Pay balance',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                      MySpacing.spacingSH,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'AED ${widget.userModel.money}',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: _errorText != null
                                      ? Colors.red
                                      : Colors.black),
                            ),
                          ),
                        ],
                      ),
                      MySpacing.spacingFH,
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          suffixText: 'AED',
                          hintText: '0',
                          labelStyle:
                              const TextStyle(fontSize: 24, color: Colors.grey),
                          suffixStyle:
                              const TextStyle(fontSize: 24, color: Colors.grey),
                          errorText: _errorText,
                        ),
                        readOnly: false,
                        controller: _controller,
                        onChanged: _validateAmount,
                        validator: (value) {
                          if (value != null && double.tryParse(value) != null) {
                            if (double.parse(value) > widget.userModel.money) {
                              return 'Please add money to your wallet.';
                            }
                          }
                          return null;
                        },
                      ),
                      MySpacing.spacingFH,
                      SizedBox(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: categories
                              .map((category) => Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text(category)),
                                  ))
                              .toList(),
                        ),
                      ),
                      MySpacing.spacingFH,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: screenWidth / 2,
                            child: sendState is SendMoneyLoading
                                ? SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: LinearProgressIndicator(
                                      color: AppColors.baseColor,
                                    ),
                                  )
                                : MyButtons().largeButton(
                                    text: _errorText == null
                                        ? 'Next'
                                        : 'Top-up wallet',
                                    onTap: () {
                                      /// NOTE ///
                                      /// If you press next, the entered amount will be sent to attila+2@mamo.com / pw: admin1234
                                      if(_errorText == null) {
                                        sendContext
                                            .read<SendMoneyCubit>()
                                            .sendMoney(
                                            double.parse(_controller.text),
                                            'bzzJKvldNJaCkT2IlRheJS0wDQA3');
                                      }
                                    },
                                    btnColor: AppColors.baseColor,
                                    txtColor: Colors.white),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
          }, listener: (BuildContext context, SendMoneyState sendListenerState) {
          if (sendListenerState is SendMoneySuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context, true);
            });
          } else if (sendListenerState is SendMoneyFailure) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pop(context, false);
            });
          }
        }
        ),
      ),
    );
  }
}
