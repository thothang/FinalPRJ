import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'package:app/models/folder.dart';
import 'package:app/services/create_folder_firebase.dart';
import 'package:app/services/create_topic_firebase.dart';

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Folder> folderList = [];
  final formkey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('folders')
        .snapshots()
        .listen((querySnapshot) {
      getFolder();
    });
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCreateFolderDialog() {
    String folderName = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tạo thư mục'),
          content: Form(
            key: formkey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Không được để trống!';
                    }
                  },
                  onChanged: (value) {
                    folderName = value;
                  },
                  decoration: InputDecoration(hintText: "Nhập tên thư mục"),
                ),
                TextFormField(
                  controller: descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Không được để trống!';
                    }
                  },
                  onChanged: (value) {
                    folderName = value;
                  },
                  decoration: InputDecoration(hintText: "Mô tả"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (formkey.currentState!.validate()) {
                  String id = const Uuid().v4();
                  Folder folder = Folder(
                      id: id,
                      name: nameController.text,
                      userId: FirebaseAuth.instance.currentUser!.uid,
                      description: descriptionController.text,
                      listTopicId: []);
                  addFolder(folder);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Tạo'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Hủy'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thư viện'),
        backgroundColor: Color(0xFFFFFF66),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.folder), text: 'Thư mục'),
            Tab(icon: Icon(Icons.topic), text: 'Chủ đề'),
            Tab(icon: Icon(Icons.group), text: 'Lớp'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showCreateFolderDialog,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFolderTab(),
          _buildTopicTab(),
          _buildClassTab(),
        ],
      ),
    );
  }

  Widget _buildFolderTab() {
    return loading
        ? Center(child: CircularProgressIndicator())
        : folderList.isNotEmpty
            ? _headfolder()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Chưa có thư mục nào', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _showCreateFolderDialog,
                    child: Text('Tạo thư mục'),
                  ),
                ],
              );
  }

  Widget _buildTopicTab() {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('topics').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
                  return ListTile(
                    title: Text(documentSnapshot['name']),
                    subtitle: Text(documentSnapshot['description']),
                  );
                },
              );
            },
          ),
          flex: 1,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                // Hiển thị AlertDialog để thêm chủ đề
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    String topicName = '';
                    String topicDescription = '';
                    return AlertDialog(
                      title: Text('Thêm chủ đề'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            onChanged: (value) {
                              topicName = value;
                            },
                            decoration: InputDecoration(hintText: 'Tên chủ đề'),
                          ),
                          TextField(
                            onChanged: (value) {
                              topicDescription = value;
                            },
                            decoration: InputDecoration(hintText: 'Nghĩa của chủ đề'),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Lưu chủ đề vào Firebase
                            FirebaseFirestore.instance.collection('topics').add({
                              'name': topicName,
                              'description': topicDescription,
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text('Lưu'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Thêm chủ đề'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClassTab() {
    return Center(
      child: Text('Chưa có lớp nào', style: TextStyle(fontSize: 18)),
    );
  }

  Future<void> addFolder(Folder folder) async {
    await CreateFolderFireBase.createFolder(folder);
  }

  Future<void> getFolder() async {
    setState(() {
      loading = true;
    });
    List<Folder> aFolder = await CreateFolderFireBase.getFolderData();
    aFolder
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    setState(() {
      folderList = aFolder;
      loading = false;
    });
  }

  Widget _headfolder() {
    return ListView.builder(
      itemCount: folderList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          elevation: 5,
          child: ListTile(
            contentPadding: EdgeInsets.all(10),
            leading: Icon(Icons.folder, size: 40, color: Colors.yellow[700]),
            title: Text(
              folderList[index].name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              folderList[index].description,
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Handle onTap event here
            },
          ),
        );
      },
    );
  }
}
