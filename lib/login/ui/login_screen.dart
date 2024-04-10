import 'package:expense_logo/deshbord/ui/deshbord_screen.dart';
import 'package:expense_logo/login/model/user_model.dart';
import 'package:expense_logo/login/ui/rejester_screen.dart';
import 'package:expense_logo/provider/auth_provider.dart';
import 'package:expense_logo/util/app_color.dart';
import 'package:expense_logo/util/app_string.dart';
import 'package:expense_logo/util/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, widget) {
          return Center(
            child: SingleChildScrollView(child: Center(
              child: SizedBox(height: MediaQuery
                  .of(context)
                  .size
                  .height,
                child: Padding(padding: const EdgeInsets.all(16),
                  child: Stack(alignment: Alignment.center,
                    children: [ Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          'https://w7.pngwing.com/pngs/417/38/png-transparent-expense-management-finance-budget-android-thumbnail.png',),
                        const Spacer(),
                        const Text(login,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8,),
                        const Text(loginText,
                          style: TextStyle(fontSize: 14),),
                        const SizedBox(height: 16,
                        ),
                        const Text(
                          email, style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),),
                        const SizedBox(height: 8,
                        ),
                        AppTextField(controller: emailController,
                          hintText: emailFieldHint,),
                        const SizedBox(height: 16,
                        ),
                        const Text(
                          Password, style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),),
                        const SizedBox(height: 8,
                        ),
                        AppTextField(controller: passwordController,
                          obscureText: authProvider.isVisible ? false : true,
                          hintText: passwordFieldHint, suffixIcon: IconButton(
                            icon: const Icon(Icons.remove_red_eye),
                            onPressed: () {
                              authProvider.setPasswordFieldStatus();
                            },
                          ),),
                        const SizedBox(height: 24,
                        ),
                        InkWell(
                          onTap: () {
                            loginUser();
                          }, child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(color: textButtonColor,
                            borderRadius: BorderRadius.circular(24),),
                          child: const Text(login,
                            style: TextStyle(color: buttonTextColor),),
                        ),),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(noAccount), const SizedBox(
                              width: 4,),
                            TextButton(onPressed: () {
                              openRegisterUserScreen();
                            },
                                child: const Text(register,
                                  style: TextStyle(color: textButtonColor),)),
                          ],)
                      ],),
                      Positioned(child: authProvider.isLoading
                          ? const CircularProgressIndicator()
                          : const SizedBox(),
                      )
                    ],
                  ),),
              ),),
            ),);
        },),
    );
  }

  void openRegisterUserScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const RegisterScreen();
    }));
  }

  Future loginUser() async {
    User user = User(email: emailController.text,
        password: passwordController.text, name: '',
    );
    AuthProvider authProvider =
    Provider.of<AuthProvider>(context, listen: false);
    bool isExist = await authProvider.isUserExists(user);
    if (isExist) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const DashboardScreen();
      }));
    }
  }
}