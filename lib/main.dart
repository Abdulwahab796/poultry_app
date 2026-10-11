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
  String selectedLanguage = 'ps';
  String userRole = 'farmer';

  final Map<String, Map<String, String>> localizedTexts = {
    'ps': {
      'title': 'د چرګانو ناروغۍ او مسلکي تداوي',
      'farmer_tab': 'فارمر (عام معلومات)',
      'doctor_tab': 'ډاکټر (مسلکي تداوي)',
      'error': 'د معلوماتو په لوستلو کې ستونزه!',
      'treatment_lbl': 'د تداوي لارښوونه:',
      'dosage_lbl': 'د درملو اندازه:',
      'symptoms_lbl': 'نښې نښانې:',
    },
    'en': {
      'title': 'Poultry Diseases & Treatment',
      'farmer_tab': 'Farmer View',
      'doctor_tab': 'Doctor View',
      'error': 'Error loading data!',
      'treatment_lbl': 'Treatment Guide:',
      'dosage_lbl': 'Dosage:',
      'symptoms_lbl': 'Symptoms:',
    },
    'fa': {
      'title': 'بیماری های طیور و تداوی مسلکی',
      'farmer_tab': 'بخش فارمر',
      'doctor_tab': 'بخش داکتر (مسلکی)',
      'error': 'خطا در بارگذاری معلومات!',
      'treatment_lbl': 'راهنمای تداوی:',
      'dosage_lbl': 'مقدار دوا:',
      'symptoms_lbl': 'علائم:',
    },
    'ar': {
      'title': 'أمراض الدواجن والعلاج المهني',
      'farmer_tab': 'قسم المزارع',
      'doctor_tab': 'قسم الطبيب البيطري',
      'error': 'خطأ في تحميل البيانات!',
      'treatment_lbl': 'دليل العلاج:',
      'dosage_lbl': 'الجرعة:',
      'symptoms_lbl': 'الأعراض:',
    },
    'ur': {
      'title': 'مرغیوں کی بیماریاں اور علاج',
      'farmer_tab': 'فارمر کا نقطہ نظر',
      'doctor_tab': 'ڈاکٹر کا نقطہ نظر',
      'error': 'ڈیٹا لوڈ کرنے میں خرابی!',
      'treatment_lbl': 'علاج کی رہنمائی:',
      'dosage_lbl': 'خوراک کی مقدار:',
      'symptoms_lbl': 'علامات:',
    },
    'hi': {
      'title': 'मुर्गी रोग और पेशेवर उपचार',
      'farmer_tab': 'किसान दृश्य',
      'doctor_tab': 'डॉक्टर दृश्य',
      'error': 'डेटा लोड करने में त्रुटि!',
      'treatment_lbl': 'उपचार मार्गदर्शिका:',
      'dosage_lbl': 'खुराक:',
      'symptoms_lbl': 'लक्षण:',
    },
  };

  String getText(String key) {
    return localizedTexts[selectedLanguage]?[key] ?? localizedTexts['en']![key]!;
  }

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
          title: Text(getText('title'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.teal,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: DropdownButton<String>(
                value: selectedLanguage,
                dropdownColor: Colors.teal.shade800,
                underline: const SizedBox(),
                icon: const Icon(Icons.language, color: Colors.white),
                items: const [
                  DropdownMenuItem(value: 'ps', child: Text('پښتو', style: TextStyle(color: Colors.white, fontSize: 13))),
                  DropdownMenuItem(value: 'en', child: Text('English', style: TextStyle(color: Colors.white, fontSize: 13))),
                  DropdownMenuItem(value: 'fa', child: Text('دری', style: TextStyle(color: Colors.white, fontSize: 13))),
                  DropdownMenuItem(value: 'ar', child: Text('العربية', style: TextStyle(color: Colors.white, fontSize: 13))),
                  DropdownMenuItem(value: 'ur', child: Text('اردو', style: TextStyle(color: Colors.white, fontSize: 13))),
                  DropdownMenuItem(value: 'hi', child: Text('हिन्दी', style: TextStyle(color: Colors.white, fontSize: 13))),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => selectedLanguage = val);
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              color: Colors.teal.shade50,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: userRole == 'farmer' ? Colors.teal : Colors.white,
                        foregroundColor: userRole == 'farmer' ? Colors.white : Colors.black87,
                      ),
                      onPressed: () => setState(() => userRole = 'farmer'),
                      child: Text(getText('farmer_tab'), style: const TextStyle(fontSize: 11)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: userRole == 'doctor' ? Colors.teal : Colors.white,
                        foregroundColor: userRole == 'doctor' ? Colors.white : Colors.black87,
                      ),
                      onPressed: () => setState(() => userRole = 'doctor'),
                      child: Text(getText('doctor_tab'), style: const TextStyle(fontSize: 11)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('diseases').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text(getText('error')));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data?.docs ?? [];

                  final List<Map<String, dynamic>> displayList = docs.isEmpty ? [
                    {
                      'category': 'Viral / ویروسي',
                      'name_ps': 'نیوکاسل (Newcastle Disease)',
                      'name_en': 'Newcastle Disease',
                      'name_fa': 'بیماری نیوکاسل',
                      'name_ar': 'مرض نيوكاسل',
                      'name_ur': 'نیوکاسل بیماری',
                      'name_hi': 'न्यूकैसल रोग (रानीखेत बीमारी)',
                      
                      'symptoms_ps': 'ساه لنډۍ، شنه حارقه، او د غاړې څرخېدل یا فلج.',
                      'symptoms_en': 'Respiratory distress, greenish diarrhea, and torticollis.',
                      'symptoms_fa': 'تنگی نفس، اسهال سبز، و فلج شدن گردن.',
                      'symptoms_ar': 'ضيق التنفس، إسهال أخضر، وشلل الرقبة.',
                      'symptoms_ur': 'سانس کی تکلیف، سبز اسہال، اور گردن کا فالج۔',
                      'symptoms_hi': 'सांस लेने में तकलीफ, हरा दस्त, और गर्दन का मुड़ना।',

                      'treatment_ps': 'درملنه نشته. مخنیوی یوازې په واکسین (لاسا یا کلون) سره کېږي.',
                      'treatment_en': 'No cure. Prevention via Lasota or Clone vaccines.',
                      'treatment_fa': 'تداوی ندارد. پیشگیری فقط با واکسین لاسوتا یا کلون.',
                      'treatment_ar': 'لا يوجد علاج. الوقاية عبر اللقاحات.',
                      'treatment_ur': 'علاج ممکن نہیں۔ احتیاطاً ویکسین لگائی جائے۔',
                      'treatment_hi': 'कोई इलाज नहीं है। लासोटा या क्लोन टीके से रोकथाम करें।',

                      'dosage': '۱ قطره په سترګه یا پوزه کې، یا په اوبو کې د لومړۍ او څلورمې اونۍ په ترڅ کې.'
                    },
                    {
                      'category': 'Bacterial / باکتريايي',
                      'name_ps': 'سینه بغل (CRD - مایکوپلاسما)',
                      'name_en': 'Chronic Respiratory Disease (CRD)',
                      'name_fa': 'بیماری تنفسی مزمن (CRD)',
                      'name_ar': 'مرض الجهاز التنفسي المزمن',
                      'name_ur': 'سانس کی دائمی بیماری',
                      'name_hi': 'क्रोनिक श्वसन रोग (CRD)',

                      'symptoms_ps': 'پرنجی، له پوزې اوبه راتلل او د مرغیو د ودې درېدل.',
                      'symptoms_en': 'Sneezing, nasal discharge, and reduced growth rate.',
                      'symptoms_fa': 'عطسه، ترشحات بینی و کاهش رشد مرغ‌ها.',
                      'symptoms_ar': 'عطس، إفرازات أنفية، وتراجع في النمو.',
                      'symptoms_ur': 'چھینکیں، ناک سے پانی بہنا اور افزائش میں کمی۔',
                      'symptoms_hi': 'छींक आना, नाक बहना और विकास में कमी।',

                      'treatment_ps': 'د انټي بیوتیکونو کارول لکه Tylosin یا Doxycycline.',
                      'treatment_en': 'Use antibiotics such as Tylosin or Doxycycline.',
                      'treatment_fa': 'استفاده از انتی‌بیوتیک‌ها مانند تایلوشین یا داکسی‌سایکلین.',
                      'treatment_ar': 'استخدام المضادات الحيوية مثل تايلوسين.',
                      'treatment_ur': 'ٹائلوسین یا ڈاکسی سائکلین جیسے اینٹی بائیوٹکس استعمال کریں۔',
                      'treatment_hi': 'टाइलोसिन या डॉक्सीसाइक्लिन जैसे एंटीबायोटिक्स का उपयोग करें।',

                      'dosage': '۱ ګرام په ۱ لیتر اوبو کې د ۳ څخه تر ۵ پرله پسې ورځو پورې.'
                    }
                  ] : docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

                  return ListView.builder(
                    itemCount: displayList.length,
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      final Map<String, dynamic> data = displayList[index];

                      String name = data['name_$selectedLanguage']?.toString() ?? data['name_en']?.toString() ?? data['name_ps']?.toString() ?? 'Disease';
                      String symptoms = data['symptoms_$selectedLanguage']?.toString() ?? data['symptoms_en']?.toString() ?? data['symptoms_ps']?.toString() ?? '';
                      String treatment = data['treatment_$selectedLanguage']?.toString() ?? data['treatment_en']?.toString() ?? data['treatment_ps']?.toString() ?? '';
                      String dosage = data['dosage']?.toString() ?? 'Consult vet clinic.';
                      String category = data['category']?.toString() ?? 'General';

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      name,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.teal.shade100,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(category, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.teal)),
                                  ),
                                ],
                              ),
                              const Divider(height: 16),
                              Text('${getText('symptoms_lbl')} $symptoms', style: const TextStyle(fontSize: 13, color: Colors.black87)),
                              if (userRole == 'doctor') ...[
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade50,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Colors.amber.shade300),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${getText('treatment_lbl')} $treatment', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.brown)),
                                      const SizedBox(height: 4),
                                      Text('${getText('dosage_lbl')} $dosage', style: const TextStyle(fontSize: 11, color: Colors.black87)),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
