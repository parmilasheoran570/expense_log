import 'package:expense_logo/login/model/user_model.dart';
import 'package:expense_logo/login/ui/login_screen.dart';
import 'package:expense_logo/provider/auth_provider.dart';
import 'package:expense_logo/util/app_color.dart';
import 'package:expense_logo/util/app_string.dart';
import 'package:expense_logo/util/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
      body: Consumer<AuthProvider>(builder: (context, authProvider, widget) {
        return Center(child: SingleChildScrollView(
          child: Center(child: SizedBox(
            height: MediaQuery
                .of(context)
                .size
                .height, child: Padding(
            padding: const EdgeInsets.all(16), child: Stack(
            alignment: Alignment.center, children: [
            Column(mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ const Spacer(),
                const Text(register,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ), const SizedBox(
                  height: 8,),
                const Text(createAccount,
                  style: TextStyle(fontSize: 14),),
                const SizedBox(height: 16,
                ), const Text(
                  userName, style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),),
                const SizedBox(height: 8,
                ), AppTextField(
                  controller: nameController, hintText: nameFieldHint,
                ), const SizedBox(
                  height: 16,),
                const Text(email,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ), const SizedBox(
                  height: 8,),
                AppTextField(controller: emailController,
                  hintText: emailFieldHint,),
                const SizedBox(height: 16,
                ), const Text(
                  Password, style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),),


                const SizedBox(

                 height: 8,
                ),
                 AppTextField(
                   controller: passwordController, obscureText: true,
                  hintText: passwordFieldHint,),



                const SizedBox(height: 16,
                ), const Text(
                  confirmPassword, style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),),
                const SizedBox(height: 8,
                ), AppTextField(
                  controller: confirmPasswordController,
                  obscureText:
                  authProvider.isVisible ? false : true,
                  hintText: reconfirmPassword,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.remove_red_eye),
                    onPressed: () {
                      authProvider.setPasswordFieldStatus();
                    },),
                ), const SizedBox(
                  height: 24,
                ), InkWell(
                  onTap: () {
                    registerUser();
                  }, child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(color: textButtonColor,
                    borderRadius: BorderRadius.circular(24),),
                  child: const Text(register,
                    style: TextStyle(color: buttonTextColor),),
                ),),
                const Spacer(), Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  const Text(alreadyAccount), const SizedBox(
                    width: 4,),
                  TextButton(onPressed: () {
                    loginUserScreen();
                  },
                    child: const Text(login,
                      style: TextStyle(color: textButtonColor),),
                  ),
                ],
                )
              ],
            ), authProvider.isLoading
                ? const CircularProgressIndicator() : const SizedBox(),
          ],),
          ),),
          ),),
        );
      },
      ),);
  }

  Future registerUser() async {
    User user = User(
      email: emailController.text, password: passwordController.text,
      name: nameController.text,);
    AuthProvider provider = Provider.of<AuthProvider>(context, listen: false);
    await provider.registerUser(user);
    if (mounted && provider.error == null) {
      Navigator.pop(context);
    }
  }

  void loginUserScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context)
    {
      return const LoginScreen();
    }));
  }
}