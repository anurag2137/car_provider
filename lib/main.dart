import 'package:car_provider/services/auth_provider.dart';
import 'package:car_provider/widgets/chat.dart';
import 'package:car_provider/widgets/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'API/favv.dart';
import 'API/function.dart';
import 'API/likehome.dart';
import 'API/model.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Car Data App ',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home:  ChatScreen(),
      ),
    );
  }
}

class CarGridScreen extends StatefulWidget {
  const CarGridScreen({Key? key}) : super(key: key);

  @override
  State<CarGridScreen> createState() => _CarGridScreenState();
}

class _CarGridScreenState extends State<CarGridScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isCommenting = false;
  late Future<List<CarData>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchData();
  }

  Future<List<CarData>> _fetchData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return authProvider.getData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _dataFuture = _fetchData();
    });
  }

  void _toggleCommenting() {
    setState(() {
      _isCommenting = !_isCommenting;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              highlightColor: Colors.redAccent,
              icon: const Icon(
                color:Colors.limeAccent,
                  Icons.car_repair

              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PostDataForm()),
                ).then((_) {
                  // Refresh data after posting
                  _refreshData();
                });
              },
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MessengerApp()),
              );
            },
            icon: const Icon(
              color:Colors.lime,
                Icons.message_outlined),
          )
        ],
        title: const Text(
          'CAR-DATA',
          style: TextStyle(color: Colors.white70),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink[900],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/download3.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: FutureBuilder<List<CarData>>(
            future: _dataFuture,
            builder: (context, AsyncSnapshot<List<CarData>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data![index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.brown[900],
                        maxRadius: 40,
                        child: Text(
                          data.car_model,
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ),
                      title: Text(
                        data.car_name,
                        style: TextStyle(color: Colors.limeAccent),
                      ),
                      subtitle: Text(
                        data.car_version,
                        style: TextStyle(color: Colors.grey[50]),
                      ),
                      trailing: SizedBox(
                        height: 100,
                        width: 160,
                        child: Row(
                          children: [
                            LikeDislikeWidget(carId: data.id),
                            IconButton(
                              color: Colors.white,
                              icon: const Icon(Icons.comment),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            controller: _commentController,
                                            decoration: const InputDecoration(
                                              hintText: 'Add a comment...',
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          IconButton(
                                            color: Colors.white,
                                            onPressed: () async {
                                              final comment =
                                                  _commentController.text;
                                              await postCommentData(
                                                comment: comment,
                                                carId: data.id,
                                              );
                                              _commentController.clear();
                                              // Refresh data after posting a comment
                                              _refreshData();
                                            },
                                            icon: const Icon(
                                              color:Colors.black,
                                                Icons.send),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              color: Colors.white,
                              onPressed: () {
                                deleteDataFromApi(id: data.id);
                                // Refresh data after deletion
                                _refreshData();
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
