import 'package:flutter/material.dart';
import '../models/ticket_model.dart';
import '../service/firestore_service.dart';
import '../widgets/payment_method_card.dart';
import 'payment_success_view.dart';

class PaymentView extends StatefulWidget {
  final Ticket ticket;

  const PaymentView({Key? key, required this.ticket}) : super(key: key);

  @override
  _PaymentViewState createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  String selectedPaymentMethod = '';
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pembayaran',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Ticket Info
          Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.ticket.formattedPrice,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4285F4),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text('Nama Pembayaran: '),
                    Text(
                      widget.ticket.namaTicket,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Tanggal: '),
                    Text('29 Mei 2025'),
                  ],
                ),
              ],
            ),
          ),

          // Payment Methods
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pilih Metode Pembayaran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  PaymentMethodCard(
                    title: 'Tunai (Cash)',
                    subtitle: 'Bayar dengan uang tunai',
                    icon: Icons.money,
                    iconColor: Colors.green,
                    isSelected: selectedPaymentMethod == 'cash',
                    onTap: () => setState(() => selectedPaymentMethod = 'cash'),
                  ),
                  
                  PaymentMethodCard(
                    title: 'Kartu Kredit',
                    subtitle: 'Bayar dengan kartu kredit',
                    icon: Icons.credit_card,
                    iconColor: Colors.blue,
                    isSelected: selectedPaymentMethod == 'credit',
                    onTap: () => setState(() => selectedPaymentMethod = 'credit'),
                  ),
                  
                  PaymentMethodCard(
                    title: 'QRIS / QR Pay',
                    subtitle: 'Bayar dengan scan QR code',
                    icon: Icons.qr_code_scanner,
                    iconColor: Colors.purple,
                    isSelected: selectedPaymentMethod == 'qris',
                    onTap: () => setState(() => selectedPaymentMethod = 'qris'),
                  ),
                ],
              ),
            ),
          ),

          // Payment Button
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: selectedPaymentMethod.isEmpty || isProcessing
                        ? null
                        : _processPayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4285F4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: isProcessing
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Bayar Sekarang',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _processPayment() async {
    setState(() => isProcessing = true);

    bool success = await FirestoreService.processPayment(
      ticketId: widget.ticket.id,
      paymentMethod: selectedPaymentMethod,
      amount: widget.ticket.harga,
    );

    setState(() => isProcessing = false);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentSuccessView(
            ticket: widget.ticket,
            paymentMethod: selectedPaymentMethod,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pembayaran gagal, coba lagi')),
      );
    }
  }
}