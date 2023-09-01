import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:taxverse/view/authentication/otp_auth/provider/otpscreen_provider.dart';
import 'package:taxverse/utils/constant/constants.dart';
import 'package:taxverse/view/authentication/provider/auth_provider.dart';
import 'package:taxverse/utils/utils.dart';
import 'package:taxverse/view/widgets/frosted_glass/frosted_glass.dart';
import 'package:taxverse/view/mainscreens/navigate_screen.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key, required this.verificationId});

  final String verificationId;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: true);

    final isLoading = provider.loading;

    // provider.setLoading = false;

    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return StreamBuilder<User?>(
              stream: context.watch<AuthProvider>().stream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) return const BottomNav(guest: false);

                return Scaffold(
                  body: Consumer<OtpScreenProvider>(builder: (context, provider, child) {
                    return SafeArea(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 25),
                          child: Stack(
                            children: [
                              ListView(
                                children: [
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: const Icon(Icons.arrow_back),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Container(
                                    width: 200,
                                    height: 200,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: blackColor.withOpacity(0.1),
                                    ),
                                    child: SvgPicture.asset('Asset/mobile.svg'),
                                  ),
                                  const SizedBox(height: 20),
                                  Center(
                                    child: Text(
                                      "Verification",
                                      style: GoogleFonts.poppins(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Enter your otp send to your phone number",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black38,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Pinput(
                                    length: 6,
                                    showCursor: true,
                                    defaultPinTheme: PinTheme(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: blackColor.withOpacity(0.6),
                                        ),
                                      ),
                                      textStyle: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onCompleted: (value) {
                                      provider.onCompleted(value);
                                    },
                                  ),
                                  const SizedBox(height: 25),
                                  InkWell(
                                    onTap: () {
                                      if (provider.otpCode != null) {
                                        verifyOtp(context, provider.otpCode!);
                                      } else {
                                        showSnackBar(context, 'Enter 6-digit Code');
                                      }
                                    },
                                    child: SizedBox(
                                      width: double.maxFinite,
                                      height: 50,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: blackColor,
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Verify',
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: whiteColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  Text(
                                    "Didn't receive any code? ",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black38,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    "Resend New Code",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: blackColor,
                                    ),
                                  )
                                ],
                              ),
                              if (isLoading)
                                const Center(
                                  child: FrostedGlass(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Center(
                                      child: SpinKitCircle(
                                        color: blackColor,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              });
        });
  }

  void verifyOtp(BuildContext context, String userOtp) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    ap.verifyOtp(
      context: context,
      verificationId: verificationId,
      userOtp: userOtp,
      onSuccess: () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNav(guest: false),
            ),
            (route) => false);
      },
    );
  }
}
