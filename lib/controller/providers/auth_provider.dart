import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taxverse/view/mainscreens/navigate_screen.dart';
import 'package:taxverse/view/otp_screen.dart';
import 'package:taxverse/utils/utils.dart';
import 'package:taxverse/view/sign_option.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _fb;

  FirebaseAuth auth = FirebaseAuth.instance;

  AuthProvider(this._fb);

  bool _isLoading = false;

  Stream<User?> stream() => _fb.authStateChanges();

  bool get loading => _isLoading;

  set setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String? _uid;

  String get uid => _uid!;

  Future<void> logOut(BuildContext context) async {
    await _fb.signOut();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SignOption(),
        ),
        (route) => false);
  }

  Future<String> signIn(String email, String password, BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _fb.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // _isLoading = false;
      // notifyListeners();

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNav(guest: false),
          ),
          (route) => false);

      // _isLoading = false;
      // notifyListeners();

      return Future.value('');
    } on FirebaseAuthException catch (ex) {
      _isLoading = false;
      notifyListeners();
      return Future.value(ex.message);
    }
  }

  Future<String> signOut(String email, String password, BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _fb.createUserWithEmailAndPassword(email: email.trim(), password: password.trim());

      // _isLoading = false;
      // notifyListeners();

      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const BottomNav(guest: false),
          ),
          (route) => false);

      return Future.value('');
    } on FirebaseAuthException catch (ex) {
      _isLoading = false;
      notifyListeners();
      return Future.value(ex.message);
    }
  }

  Future<String> resetPassword(String email) async {
    // await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
    try {
      _isLoading = true;
      notifyListeners();

      await _fb.sendPasswordResetEmail(email: email.trim());

      _isLoading = false;
      notifyListeners();

      return Future.value('');
    } on FirebaseAuthException catch (ex) {
      _isLoading = false;
      notifyListeners();
      log('${ex.message} favad');
      return Future.value(ex.message);
    }
  }

  Future<String> signInWithPhoneNumber(String phoneNumber, BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      verificationCompleted(phoneAuthCredential) async {
        await auth.signInWithCredential(phoneAuthCredential);
        
      }

      verificationFailed(FirebaseAuthException error) {
        log('Error ==================================   $error');
        

        return 'Error To send OTP';
      }

      codeSent(verificationId, forceResendingToken) {
       
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(verificationId: verificationId),
          ),
        );
      }

      codeAutoRetrievalTimeout(verificationId) {}

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber.trim(),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );

      return '';
    } on FirebaseAuthException catch (ex) {
      _isLoading = false;
      notifyListeners();
      return ex.message ?? 'An Error occured during phone verification.';
    }
  }

  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOtp,
      );

      User? user = (await FirebaseAuth.instance.signInWithCredential(credential)).user;

      if (user != null) {
        _uid = user.uid;

        onSuccess();
      }

      _isLoading = false;

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());

      _isLoading = false;

      notifyListeners();
    }
  }
}
