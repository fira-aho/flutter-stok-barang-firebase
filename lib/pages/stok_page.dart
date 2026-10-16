import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StokPage extends StatefulWidget {
  const StokPage({super.key});

  @override
  State<StokPage> createState() => _StokPageState();
}

class _StokPageState extends State<StokPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _tglMasukController = TextEditingController();
  final _tglKeluarController = TextEditingController();
  final _kodeController = TextEditingController();
  final _jumlahController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _namaController.dispose();
    _tglMasukController.dispose();
    _tglKeluarController.dispose();
    _kodeController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  void _clearFields() {
    _formKey.currentState!.reset();
    _namaController.clear();
    _tglMasukController.clear();
    _tglKeluarController.clear();
    _kodeController.clear();
    _jumlahController.clear();
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final int kodeBarang = int.parse(_kodeController.text.trim());
      final int jumlahStok = int.parse(_jumlahController.text.trim());

      await FirebaseFirestore.instance.collection('stok_barang').add({
        'nama_barang': _namaController.text.trim(),
        'tanggal_masuk': _tglMasukController.text.trim(),
        'tanggal_keluar': _tglKeluarController.text.trim(),
        'kode_barang': kodeBarang,
        'jumlah_stok': jumlahStok,
        'waktu': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data berhasil disimpan!'),
            backgroundColor: Colors.green,
          ),
        );
        _clearFields();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pencatatan Stok Barang')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nama Barang: diisi inisial nama depan (R)
              _buildTextField(
                controller: _namaController,
                label: 'Nama Barang (inisial nama depan)',
                keyboardType: TextInputType.text,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Nama barang wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _tglMasukController,
                label: 'Tanggal Masuk Barang',
                keyboardType: TextInputType.text,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Tanggal masuk wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _tglKeluarController,
                label: 'Tanggal Keluar Barang',
                keyboardType: TextInputType.text,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Tanggal keluar wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              // Kode Barang: min 6 angka, 2 angka terakhir = 44 (NIM genap)
              _buildTextField(
                controller: _kodeController,
                label: 'Kode Barang (min 6 digit, diakhiri 44)',
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Kode barang wajib diisi';
                  }
                  final parsed = int.tryParse(v.trim());
                  if (parsed == null) {
                    return 'Kode barang harus berupa bilangan bulat';
                  }
                  if (v.trim().length < 6) {
                    return 'Kode barang minimal 6 digit';
                  }
                  if (!v.trim().endsWith('44')) {
                    return 'Kode barang harus diakhiri 44 (2 angka terakhir NIM)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _jumlahController,
                label: 'Jumlah Stok',
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Jumlah stok wajib diisi';
                  }
                  final parsed = int.tryParse(v.trim());
                  if (parsed == null) {
                    return 'Jumlah stok harus berupa angka';
                  }
                  if (parsed < 0) {
                    return 'Jumlah stok tidak boleh negatif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _loading ? null : _simpan,
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Simpan Barang'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}
