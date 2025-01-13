import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mamopay_clone/presentation/auth/core/auth_cubit.dart';
import 'package:mamopay_clone/presentation/auth/core/auth_state.dart';
import 'package:mamopay_clone/presentation/dashboard/view/dashboard_screen.dart';
import 'package:mamopay_clone/utils/colors/colors.dart';
import 'package:mamopay_clone/utils/spacing/spacing.dart';
import 'package:mamopay_clone/utils/widgets/button.dart';

class AuthScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        backgroundColor: AppColors.baseColor,
        title: const Text(
          'Mamo Auth',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: BlocProvider(
          create: (context) =>
              AuthCubit(FirebaseAuth.instance, FirebaseFirestore.instance),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (authListenerContext, state) {
              if (state is AuthLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                );
              } else if (state is AuthSuccess) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Authentication Successful!')),
                );
              } else if (state is AuthError) {
                Navigator.of(context).pop(); // Remove loading indicator
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (BuildContext authContext, AuthState state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(
                                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    MySpacing.spacingMH,
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    MySpacing.spacingMH,
                    SizedBox(
                      width: double.infinity,
                      child: MyButtons().largeButton(
                          text: 'Login',
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();
                              authContext
                                  .read<AuthCubit>()
                                  .loginUser(email, password);
                            }
                          },
                          btnColor: AppColors.baseColor,
                          txtColor: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
