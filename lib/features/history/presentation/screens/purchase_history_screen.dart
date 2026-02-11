import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'bill_detail_screen.dart';

class PurchaseHistoryScreen extends StatelessWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: PointsMeTheme.darkGradient,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ประวัติการซื้อ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: PointsMeTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'รายการซื้อสินค้าทั้งหมดของคุณ',
                    style: TextStyle(
                      fontSize: 13,
                      color: PointsMeTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Month filter chips
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildFilterChip('ทั้งหมด', true),
                  _buildFilterChip('ก.พ. 2026', false),
                  _buildFilterChip('ม.ค. 2026', false),
                  _buildFilterChip('ธ.ค. 2025', false),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Transaction list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildDateHeader('10 กุมภาพันธ์ 2026'),
                  _buildTransactionTile(
                    context,
                    storeName: 'The Coffee House - สาขาสยาม',
                    amount: '฿350',
                    points: '+35 แต้ม',
                    time: '14:30',
                    items: 3,
                    orderId: 'ORD-20260210-001',
                  ),
                  _buildTransactionTile(
                    context,
                    storeName: 'The Coffee House - สาขาสยาม',
                    amount: '฿120',
                    points: '+12 แต้ม',
                    time: '09:15',
                    items: 1,
                    orderId: 'ORD-20260210-002',
                  ),

                  _buildDateHeader('8 กุมภาพันธ์ 2026'),
                  _buildTransactionTile(
                    context,
                    storeName: 'The Coffee House - สาขาลาดพร้าว',
                    amount: '฿520',
                    points: '+52 แต้ม',
                    time: '18:45',
                    items: 4,
                    orderId: 'ORD-20260208-001',
                  ),

                  _buildDateHeader('5 กุมภาพันธ์ 2026'),
                  _buildTransactionTile(
                    context,
                    storeName: 'The Coffee House - สาขาสยาม',
                    amount: '฿180',
                    points: '+18 แต้ม',
                    time: '12:00',
                    items: 2,
                    orderId: 'ORD-20260205-001',
                  ),

                  _buildDateHeader('1 กุมภาพันธ์ 2026'),
                  _buildTransactionTile(
                    context,
                    storeName: 'The Coffee House - สาขาเซ็นทรัล',
                    amount: '฿890',
                    points: '+89 แต้ม',
                    time: '16:20',
                    items: 6,
                    orderId: 'ORD-20260201-001',
                  ),
                  _buildTransactionTile(
                    context,
                    storeName: 'The Coffee House - สาขาสยาม',
                    amount: '฿250',
                    points: '+25 แต้ม',
                    time: '10:00',
                    items: 2,
                    orderId: 'ORD-20260201-002',
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isSelected ? PointsMeTheme.darkBg : PointsMeTheme.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        selected: isSelected,
        onSelected: (_) {},
        backgroundColor: PointsMeTheme.darkCard,
        selectedColor: PointsMeTheme.primaryGold,
        side: BorderSide(
          color: isSelected ? PointsMeTheme.primaryGold : PointsMeTheme.dividerColor,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  Widget _buildDateHeader(String date) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        date,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: PointsMeTheme.textMuted,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTransactionTile(
    BuildContext context, {
    required String storeName,
    required String amount,
    required String points,
    required String time,
    required int items,
    required String orderId,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BillDetailScreen(orderId: orderId),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: PointsMeTheme.darkCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: PointsMeTheme.dividerColor.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: PointsMeTheme.primaryGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.receipt_outlined, color: PointsMeTheme.primaryGold, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    storeName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: PointsMeTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        time,
                        style: TextStyle(fontSize: 12, color: PointsMeTheme.textMuted),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 3,
                        height: 3,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: PointsMeTheme.textMuted,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$items รายการ',
                        style: TextStyle(fontSize: 12, color: PointsMeTheme.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: PointsMeTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  points,
                  style: const TextStyle(
                    fontSize: 12,
                    color: PointsMeTheme.successColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, color: PointsMeTheme.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
