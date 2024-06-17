import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MobileLoginPage extends StatefulWidget {
  @override
  State<MobileLoginPage> createState() => _MobileLoginPageState();
}

class _MobileLoginPageState extends State<MobileLoginPage> {
  var mobileNoController=TextEditingController();

  var otpController=TextEditingController();

  String? mVerificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mobile Login"),),
      body: Column(
        children: [
          TextField(
            controller: mobileNoController,
          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: () async {
            await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: '+91${mobileNoController.text}',
              verificationCompleted: (PhoneAuthCredential credential) {
                print("verification completed");
              },
              verificationFailed: (FirebaseAuthException e) {
                print("verification failed:${e.message}");
              },
              codeSent: (String verificationId, int? resendToken) {
                mVerificationId=verificationId;
                setState(() {

                });
              },
              codeAutoRetrievalTimeout: (String verificationId) {},
            );
          }, child: Text("Send OTP")),
          SizedBox(height: 20,),
          TextField(
            controller: otpController,
          ),
          SizedBox(height: 20,),
          AnimatedOpacity(opacity: mVerificationId!=null ? 1:0, duration: Duration(seconds: 2),
            child: ElevatedButton(onPressed: () async {
              String smsCode = otpController.text;

              // Create a PhoneAuthCredential with the code
              PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: mVerificationId!, smsCode: smsCode);

              // Sign the user in (or link) with the credential
              var cred=await FirebaseAuth.instance.signInWithCredential(credential);
              print("Login Credential: ${cred.user!.uid}");
            }, child: Text("Submit OTP")),),
        ],
      ),
    );
  }
}