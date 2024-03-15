import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tiktok/bottomroutes.dart';
import 'package:tiktok/playvideo.dart';
import 'package:tiktok/videoitem.dart';
import 'package:video_player/video_player.dart';

final _auth = FirebaseAuth.instance;
final _user = _auth.currentUser;
final _firestore = FirebaseFirestore.instance;
final _firebasestorage = FirebaseStorage.instance;
final _userstream = _firestore.collection('video').snapshots();

class homepage extends StatelessWidget {
  const homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _userstream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('waiting');
          }
          var docs = snapshot.data!.docs;
          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: docs.length,
            itemBuilder: (context, index) {
              String l = docs[index]['videourl'];
              String usernamee = docs[index]['username'];
              String captionn = docs[index]['caption'];
              String songname = docs[index]['songname'];
              String profile = docs[index]['profile'];
              VideoPlayerController v = VideoPlayerController.network(l);
              v.initialize();
              v.play();
              v.setVolume(1);
              v.setLooping(true);
              return Stack(
                children: [
                  VideoPlayer(v),
                  Positioned(
                      child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          usernamee,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          captionn,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.music_note,
                              size: 10,
                            ),
                            Text(
                              songname,
                              style: TextStyle(fontSize: 12),
                            ),
                            SizedBox(
                              height: 50,
                            )
                          ],
                        )
                      ],
                    ),
                  )),
                  Positioned(
                      right: 20,
                      top: 250,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(profile),
                              ),
                            ),
                            SizedBox(
                              height: 35,
                            ),
                            InkWell(
                              child: Icon(
                                Icons.favorite,
                                size: 50,
                                color: Colors.red,
                              ),
                              onTap: (() {
                                print('object');
                              }),
                            ),
                            SizedBox(
                              height: 35,
                            ),
                            Icon(
                              Icons.message,
                              size: 45,
                            ),
                            SizedBox(
                              height: 35,
                            ),
                            Icon(
                              Icons.share,
                              size: 45,
                            ),
                          ],
                        ),
                      ))
                ],
              );
            },
          );
        },
      ),
    );
  }
}
