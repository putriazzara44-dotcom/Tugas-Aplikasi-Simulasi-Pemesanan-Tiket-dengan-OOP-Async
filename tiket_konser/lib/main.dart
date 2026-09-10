import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TixFest - Pemesanan Tiket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFFFF5F7), // Theme Pink Soft
        fontFamily: 'Sans-Serif',
      ),
      home: const HalamanBeranda(),
    );
  }
}

// ==========================================
// MODEL DATA CONCERT / EVENT
// ==========================================
class KonserEvent {
  final String judul;
  final String tanggalLokasi;
  final String hargaMulai;
  final String imageUrl;

  KonserEvent({
    required this.judul,
    required this.tanggalLokasi,
    required this.hargaMulai,
    required this.imageUrl,
  });
}

// ==========================================
// 1. KONSEP OOP & EXCEPTIONS
// ==========================================

// Custom Exception (Error Handling Async)
class TiketHabisException implements Exception {
  final String message;
  TiketHabisException(this.message);

  @override
  String toString() => message;
}

// Mixin
mixin BisaDiskon {
  double hitungHargaDiskon(double harga, double persen) {
    return harga - (harga * (persen / 100));
  }
}

// Abstract Class
abstract class Tiket {
  final String nama;
  final double harga;

  Tiket({required this.nama, required this.harga});

  // Abstract Method
  String deskripsi();
}

// Subclass 1: Tiket Ekonomi
class TiketEkonomi extends Tiket {
  TiketEkonomi({required String nama, required double harga})
      : super(nama: nama, harga: harga);

  @override
  String deskripsi() => 'Akses tribun atas, fasilitas standar venue.';
}

// Subclass 2: Tiket VIP (Menggunakan Mixin BisaDiskon)
class TiketVIP extends Tiket with BisaDiskon {
  final String bonus;

  TiketVIP({required String nama, required double harga, required this.bonus})
      : super(nama: nama, harga: harga);

  @override
  String deskripsi() => 'Akses depan panggung, $bonus, & Fast-Track Gate.';
}

// ==========================================
// 2. FUNGSI ASYNC & SIMULASI DATA
// ==========================================

Future<List<Tiket>> ambilDaftarTiket() async {
  await Future.delayed(const Duration(seconds: 2));

  return [
    TiketEkonomi(nama: 'CAT 3 (Ekonomi)', harga: 1500000),
    TiketEkonomi(nama: 'CAT 2 (Reguler)', harga: 2500000),
    TiketVIP(
      nama: 'CAT 1 VIP (Promo)',
      harga: 4000000,
      bonus: 'Free Merchandise & Welcome Drink',
    ),
    TiketVIP(
      nama: 'Ultimate VIP',
      harga: 11000000,
      bonus: 'Soundcheck Access & Exclusive Gift',
    ),
  ];
}

Future<String> pesanTiket(Tiket tiket) async {
  await Future.delayed(const Duration(seconds: 2));

  bool isFailed = Random().nextInt(10) < 3; // 30% simulasi gagal

  if (isFailed) {
    throw TiketHabisException('Maaf, kuota tiket ${tiket.nama} baru saja habis!');
  }

  return 'BOOK-${Random().nextInt(899999) + 100000}';
}

Stream<int> hitungMundurPromoStream(int detikAwal) async* {
  for (int i = detikAwal; i >= 0; i--) {
    await Future.delayed(const Duration(seconds: 1));
    yield i;
  }
}

// ==========================================
// 3. SCREEN BARU: HALAMAN BERANDA / PILIH KONSER
// ==========================================
class HalamanBeranda extends StatefulWidget {
  const HalamanBeranda({super.key});

  @override
  State<HalamanBeranda> createState() => _HalamanBerandaState();
}

class _HalamanBerandaState extends State<HalamanBeranda> {
  final List<KonserEvent> daftarKonser = [
    KonserEvent(
      judul: 'BLACKPINK WORLD TOUR BORN PINK Jakarta',
      tanggalLokasi: '11 Mei 2025 • GBK, Jakarta',
      hargaMulai: 'Rp 1.850.000',
      imageUrl: 'https://picsum.photos/id/1025/100/100',
    ),
    KonserEvent(
      judul: 'Sheila On 7 Live in Concert Tunggu Aku di Jakarta',
      tanggalLokasi: '17 Mei 2025 • JIExpo, Jakarta',
      hargaMulai: 'Rp 750.000',
      imageUrl: 'https://picsum.photos/id/1084/100/100',
    ),
    KonserEvent(
      judul: 'NCT DREAM SHOW 3 THE DREAM SHOW',
      tanggalLokasi: '26 Mei 2025 • ICE BSD, Tangerang',
      hargaMulai: 'Rp 1.250.000',
      imageUrl: 'https://picsum.photos/id/1062/100/100',
    ),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.black87),
                        onPressed: () {},
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Halo, Azzahra ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('✨', style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          Text(
                            'Mau ke event apa hari ini?',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded,
                        color: Colors.black87),
                    onPressed: () {},
                  )
                ],
              ),
              const SizedBox(height: 16),

              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari konser, artis, atau venue...',
                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search, color: Color(0xFFC71585)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Category Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCategoryItem(Icons.music_note_outlined, 'Konser'),
                  _buildCategoryItem(Icons.crop_original_outlined, 'Pameran'),
                  _buildCategoryItem(Icons.queue_music_outlined, 'Festival Musik'),
                  _buildCategoryItem(Icons.favorite_border_rounded, 'Fan Meeting'),
                ],
              ),
              const SizedBox(height: 20),

              // Promo Early Bird Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFB6C1), Color(0xFFFFC0CB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Promo Early Bird',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '30% OFF',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFC71585),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Beli lebih awal,\nharga lebih hemat!',
                            style: TextStyle(fontSize: 10, color: Colors.black87),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Beli Sekarang',
                              style: TextStyle(
                                color: Color(0xFFC71585),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.confirmation_number_outlined,
                      size: 90,
                      color: Color(0xFFC71585),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Event Populer Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Event Populer ✨',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // List Event Populer
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: daftarKonser.length,
                itemBuilder: (context, index) {
                  final event = daftarKonser[index];
                  return GestureDetector(
                    onTap: () {
                      // Pindah ke Halaman Daftar Tiket
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HalamanDaftarTiket(
                            namaKonser: event.judul,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              width: 60,
                              height: 60,
                              color: const Color(0xFFFFE4E1),
                              child: const Icon(
                                Icons.music_note,
                                color: Color(0xFFC71585),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.judul,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  event.tanggalLokasi,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  event.hargaMulai,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFC71585),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.favorite_border,
                            color: Colors.grey,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFFC71585),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontSize: 10),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number_outlined),
            label: 'Tiket Saya',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Icon(icon, color: const Color(0xFFC71585), size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

// ==========================================
// 4. SCREEN 2: DAFTAR TIKET (FutureBuilder & StreamBuilder)
// ==========================================
class HalamanDaftarTiket extends StatefulWidget {
  final String namaKonser;

  const HalamanDaftarTiket({super.key, this.namaKonser = 'TixFest Ticket'});

  @override
  State<HalamanDaftarTiket> createState() => _HalamanDaftarTiketState();
}

class _HalamanDaftarTiketState extends State<HalamanDaftarTiket> {
  late Future<List<Tiket>> _futureTiket;

  @override
  void initState() {
    super.initState();
    _futureTiket = ambilDaftarTiket();
  }

  void _muatUlangData() {
    setState(() {
      _futureTiket = ambilDaftarTiket();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.namaKonser,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        backgroundColor: const Color(0xFFC71585),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // (BONUS) StreamBuilder: Hitung Mundur Waktu Tersisa Promo Tiket
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: const Color(0xFFFFE4E1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer_outlined,
                    color: Color(0xFFC71585), size: 18),
                const SizedBox(width: 8),
                const Text(
                  'Waktu tersisa untuk memesan tiket promo: ',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                ),
                StreamBuilder<int>(
                  stream: hitungMundurPromoStream(300), // Countdown 5 Menit
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Text('--:--');
                    }
                    int detik = snapshot.data!;
                    int menit = detik ~/ 60;
                    int sisaDetik = detik % 60;
                    String timeStr =
                        '${menit.toString().padLeft(2, '0')}:${sisaDetik.toString().padLeft(2, '0')}';

                    return Text(
                      timeStr,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC71585),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          Expanded(
            // Penanganan FutureBuilder
            child: FutureBuilder<List<Tiket>>(
              future: _futureTiket,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Color(0xFFC71585)),
                        SizedBox(height: 12),
                        Text(
                          'Memuat daftar tiket...',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 12),
                        Text(
                          'Terjadi Kesalahan:\n${snapshot.error}',
                          textAlign: TextAlign.center,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC71585),
                          ),
                          onPressed: _muatUlangData,
                          child: const Text('Coba Lagi',
                              style: TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  );
                }

                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final listTiket = snapshot.data!;
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: listTiket.length,
                    itemBuilder: (context, index) {
                      final tiket = listTiket[index];
                      double hargaFinal = tiket.harga;

                      if (tiket is TiketVIP) {
                        hargaFinal =
                            tiket.hitungHargaDiskon(tiket.harga, 10); // Diskon 10%
                      }

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: const BorderSide(color: Color(0xFFFFE4E1)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    tiket.nama,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  if (tiket is TiketVIP)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFE4E1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'PROMO 10%',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFC71585),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                tiket.deskripsi(),
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.grey),
                              ),
                              const Divider(height: 18),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (tiket is TiketVIP)
                                        Text(
                                          'Rp ${tiket.harga.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      Text(
                                        'Rp ${hargaFinal.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFC71585),
                                        ),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFC71585),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HalamanPembayaran(
                                            tiket: tiket,
                                            hargaBeli: hargaFinal,
                                            namaKonser: widget.namaKonser,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Pesan',
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.white),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                return const Center(child: Text('Data tiket kosong.'));
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 5. SCREEN 5: HALAMAN PEMBAYARAN (Try/Catch/Finally)
// ==========================================
class HalamanPembayaran extends StatefulWidget {
  final Tiket tiket;
  final double hargaBeli;
  final String namaKonser;

  const HalamanPembayaran({
    super.key,
    required this.tiket,
    required this.hargaBeli,
    required this.namaKonser,
  });

  @override
  State<HalamanPembayaran> createState() => _HalamanPembayaranState();
}

class _HalamanPembayaranState extends State<HalamanPembayaran> {
  String _metodeSelected = 'Virtual Account';
  bool _isProcessing = false;

  Future<void> _eksekusiBayar() async {
    setState(() => _isProcessing = true);

    try {
      String kodeBooking = await pesanTiket(widget.tiket);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HalamanETiketSukses(
            tiket: widget.tiket,
            kodeBooking: kodeBooking,
            total: widget.hargaBeli,
            namaKonser: widget.namaKonser,
          ),
        ),
      );
    } on TiketHabisException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pembayaran Tiket',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: const Color(0xFFC71585),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFFE4E1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ringkasan Pesanan',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.tiket.nama,
                            style: const TextStyle(fontSize: 11)),
                        Text(
                          'Rp ${widget.hargaBeli.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Metode Pembayaran',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildPaymentOption(
                title: 'Virtual Account',
                subtitle: 'BCA, Mandiri, BRI, BNI',
                icon: Icons.account_balance_outlined,
              ),
              _buildPaymentOption(
                title: 'E-Wallet',
                subtitle: 'GoPay, OVO, Dana, ShopeePay',
                icon: Icons.account_balance_wallet_outlined,
              ),
              _buildPaymentOption(
                title: 'Kartu Kredit / Debit',
                subtitle: 'Visa, Mastercard, JCB',
                icon: Icons.credit_card_outlined,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC71585),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _isProcessing ? null : _eksekusiBayar,
                  child: _isProcessing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Bayar Sekarang',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    bool isSelected = _metodeSelected == title;

    return GestureDetector(
      onTap: () => setState(() => _metodeSelected = title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFC71585)
                : const Color(0xFFFFE4E1),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFC71585), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: title,
              groupValue: _metodeSelected,
              activeColor: const Color(0xFFC71585),
              onChanged: (val) {
                if (val != null) setState(() => _metodeSelected = val);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 6. SCREEN 6: HALAMAN E-TIKET SUKSES
// ==========================================
class HalamanETiketSukses extends StatelessWidget {
  final Tiket tiket;
  final String kodeBooking;
  final double total;
  final String namaKonser;

  const HalamanETiketSukses({
    super.key,
    required this.tiket,
    required this.kodeBooking,
    required this.total,
    required this.namaKonser,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFFC71585),
                size: 70,
              ),
              const SizedBox(height: 12),
              const Text(
                'Pembayaran Berhasil! 🎉',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'E-Tiket kamu sudah terbit dan siap digunakan',
                style: TextStyle(fontSize: 11, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFFE4E1)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TIXFEST E-TICKET',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFC71585),
                            letterSpacing: 1,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'CONFIRMED',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Text(
                      namaKonser,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Gelora Bung Karno / JIExpo, Jakarta',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Kategori Tiket',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              tiket.nama,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Kode Booking',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              kodeBooking,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFC71585),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            height: 45,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(Icons.qr_code_2, size: 36),
                                Text(
                                  'SCAN AT VENUE',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFC71585)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(
                      color: Color(0xFFC71585),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}