import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ringworm_admin/constraints.dart';
import 'package:ringworm_admin/detail_doctor.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

String status = "All";

class _HomeScreensState extends State<HomeScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Home",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF6F35A5)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: kPrimaryColor),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton(
                        value: status,
                        items: [
                          DropdownMenuItem(value: "All", child: Text("All")),
                          DropdownMenuItem(
                              value: "active", child: Text("Active")),
                          DropdownMenuItem(
                              value: "non-active", child: Text("Non Active")),
                        ],
                        onChanged: (value) {
                          setState(() {
                            status = value.toString();
                          });
                        }),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              StreamBuilder(
                stream: status != "All"
                    ? FirebaseFirestore.instance
                        .collection("akun")
                        .where("role", isEqualTo: "doctor")
                        .where("status", isEqualTo: status)
                        .orderBy("createdAt", descending: true)
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection("akun")
                        .where("role", isEqualTo: "doctor")
                        .orderBy("createdAt", descending: true)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.error != null) {
                    print(snapshot.error);
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text("tidak ada Doctor"),
                    );
                  }
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var doc = snapshot.data!.docs;

                      return InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DoctorDetail(id: doc[index]['uid']))),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24, right: 24),
                          child: Container(
                            height: 72,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: NetworkImage(doc[index]
                                              ["img"] ==
                                          ""
                                      ? 'https://i.stack.imgur.com/l60Hf.png'
                                      : doc[index]["img"]),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  height: 72,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        doc[index]["nama"],
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        (snapshot.data! as dynamic).docs[index]
                                            ['status'],
                                        style: TextStyle(
                                            color:
                                                doc[index]["status"] == "active"
                                                    ? Colors.green
                                                    : Colors.red,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
