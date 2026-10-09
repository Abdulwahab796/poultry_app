import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBdpwSYUrNasbejdrq3aUD...",
      appId: "1:305820268623:web:9f439bed...",
      messagingSenderId: "305820268623",
      projectId: "poultryapp-e0efb",
      authDomain: "poultryapp-e0efb.firebaseapp.com",
      storageBucket: "poultryapp-e0efb.appspot.com",
      measurementId: "G-3PXHK0EJZN",
    ),
  );
  
  runApp(const PoultryApp());
}

class PoultryApp extends StatefulWidget {
  const PoultryApp({super.key});

  @override
  State<PoultryApp> createState() => _PoultryAppState();
}

class _PoultryAppState extends State<PoultryApp> {
  bool isPashto = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(isPashto ? 'د چرګانو ناروغۍ' : 'Poultry Diseases'),
          centerTitle: true,
          backgroundColor: Colors.teal,
          actions: [
            TextButton.icon(
              onPressed: () {
                setState(() {
                  isPashto = !isPashto;
                });
              },
              icon: const Icon(Icons.language, color: Colors.white),
              label: Text(
                isPashto ? 'English' : 'پښتو',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('diseases').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(isPashto ? 'ستونزه رامنځته شوه!' : 'Error loading data!'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data?.docs ?? [];

            if (docs.isEmpty) {
              return Center(
                child: Text(isPashto ? 'هیڅ ناروغي ونه موندل شوه.' : 'No diseases found.'),
              );
            }

            return ListView.builder(
              itemCount: docs.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;

                final name = isPashto 
                    ? (data['name_ps'] ?? docs[index].id) 
                    : (data['name_en'] ?? docs[index].id);

                final category = isPashto 
                    ? (data['category_ps'] ?? '') 
                    : (data['category_en'] ?? '');

                final description = isPashto 
                    ? (data['description_ps'] ?? '') 
                    : (data['description_en'] ?? '');

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (category.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Chip(
                              label: Text(category, style: const TextStyle(fontSize: 12)),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        Text(description),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
