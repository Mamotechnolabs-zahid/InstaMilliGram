import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instamilligram/utils/colors.dart';
import 'package:instamilligram/utils/global_variable.dart';
import 'package:instamilligram/widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
        appBar: width > webScreenSize
            ? null
            : AppBar(
                backgroundColor: mobileBackgroundColor,
                centerTitle: false,
                title: SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  color: primaryColor,
                  height: 32,
                ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.messenger_outline,
                      color: primaryColor,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
       body: StreamBuilder(
  stream: FirebaseFirestore.instance.collection('posts').snapshots(),
  builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    // Check for errors in the snapshot
    if (snapshot.hasError) {
      return Center(
        child: Text('Something went wrong!'),
      );
    }

    // Check if data is still loading
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Check if snapshot has data and that the document list is not empty
    if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
      return Center(
        child: Text('No posts available'),
      );
    }

    // If we have data, build the ListView
    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (ctx, index) => Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > webScreenSize
              ? MediaQuery.of(context).size.width * 0.3
              : 0,
          vertical: MediaQuery.of(context).size.width > webScreenSize ? 15 : 0,
        ),
        child: PostCard(
          snap: snapshot.data!.docs[index].data(),
        ),
      ),
    );
  },
));

  }
}
