import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ticket_model.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _ticketsCollection = 'Ticket';

  // Get all tickets
  static Stream<List<Ticket>> getTickets() {
    return _firestore
        .collection(_ticketsCollection)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Ticket.fromFirestore(doc.data(), doc.id))
            .toList());
  }

  // Get ticket by ID
  static Future<Ticket?> getTicketById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_ticketsCollection)
          .doc(id)
          .get();
      
      if (doc.exists) {
        return Ticket.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting ticket: $e');
      return null;
    }
  }

  // Add new ticket
  static Future<String?> addTicket(Ticket ticket) async {
    try {
      DocumentReference docRef = await _firestore
          .collection(_ticketsCollection)
          .add(ticket.toFirestore());
      return docRef.id;
    } catch (e) {
      print('Error adding ticket: $e');
      return null;
    }
  }

  // Update ticket
  static Future<bool> updateTicket(String id, Ticket ticket) async {
    try {
      await _firestore
          .collection(_ticketsCollection)
          .doc(id)
          .update(ticket.toFirestore());
      return true;
    } catch (e) {
      print('Error updating ticket: $e');
      return false;
    }
  }

  // Delete ticket
  static Future<bool> deleteTicket(String id) async {
    try {
      await _firestore
          .collection(_ticketsCollection)
          .doc(id)
          .delete();
      return true;
    } catch (e) {
      print('Error deleting ticket: $e');
      return false;
    }
  }

  // Process payment (simulate)
  static Future<bool> processPayment({
    required String ticketId,
    required String paymentMethod,
    required int amount,
  }) async {
    try {
      // Simulate payment processing
      await Future.delayed(Duration(seconds: 2));
      
      // You can add payment logic here
      // For now, we'll just log the payment
      print('Payment processed: $paymentMethod, Amount: $amount');
      
      return true;
    } catch (e) {
      print('Error processing payment: $e');
      return false;
    }
  }
}