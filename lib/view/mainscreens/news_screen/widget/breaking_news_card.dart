import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taxverse/utils/constant/constants.dart';
import 'package:taxverse/view/mainscreens/news_screen/widget/news_details.dart';

class BreakingNewsCard extends StatelessWidget {
  const BreakingNewsCard({super.key, required this.news});

  final DocumentSnapshot news;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsScreen(news: news),
            ));
      },
      child: Container(
        height: size.height * 0.08,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
            image: NetworkImage(news['image']),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(colors: [
              Colors.transparent,
              blackColor
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          padding: EdgeInsets.all(size.height * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                news['newsHeading'],
                style: AppStyle.poppinsBoldWhite18,
              ),
              const SizedBox(height: 8),
              Text(
                news['auther'],
                style: AppStyle.poppinsRegulargrey14,
              )
            ],
          ),
        ),
      ),
    );
  }
}
