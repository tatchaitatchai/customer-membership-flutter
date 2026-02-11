import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../../common/widgets/premium_card.dart';

class BillDetailScreen extends StatelessWidget {
  final String orderId;

  const BillDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: PointsMeTheme.darkGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios, color: PointsMeTheme.textPrimary),
                    ),
                    const Expanded(
                      child: Text(
                        'รายละเอียดบิล',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: PointsMeTheme.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Order info card
                      GoldGradientCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              color: PointsMeTheme.successColor,
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'ชำระเงินสำเร็จ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: PointsMeTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              orderId,
                              style: TextStyle(
                                fontSize: 13,
                                color: PointsMeTheme.textMuted,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Divider(color: PointsMeTheme.dividerColor),
                            const SizedBox(height: 12),
                            _buildInfoRow('ร้านค้า', 'The Coffee House'),
                            _buildInfoRow('สาขา', 'สาขาสยาม'),
                            _buildInfoRow('วันที่', '10 ก.พ. 2026'),
                            _buildInfoRow('เวลา', '14:30'),
                            _buildInfoRow('พนักงาน', 'คุณสมศรี'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Items
                      PremiumCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'รายการสินค้า',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: PointsMeTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildItemRow('Americano (Hot)', 1, '฿65'),
                            _buildItemRow('Latte (Iced)', 2, '฿160'),
                            _buildItemRow('Croissant', 1, '฿75'),
                            const SizedBox(height: 12),
                            const Divider(color: PointsMeTheme.dividerColor),
                            const SizedBox(height: 12),
                            _buildTotalRow('รวม', '฿300'),
                            _buildTotalRow('ส่วนลดสมาชิก (5%)', '-฿15', isDiscount: true),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'ยอดชำระ',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: PointsMeTheme.primaryGold,
                                  ),
                                ),
                                const Text(
                                  '฿285',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: PointsMeTheme.primaryGold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Points earned
                      PremiumCard(
                        border: Border.all(color: PointsMeTheme.primaryGold.withOpacity(0.3)),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: PointsMeTheme.primaryGold.withOpacity(0.15),
                              ),
                              child: const Icon(Icons.star, color: PointsMeTheme.primaryGold, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'แต้มที่ได้รับ',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: PointsMeTheme.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    '+35 แต้ม',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: PointsMeTheme.successColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'แต้มสะสม',
                                  style: TextStyle(fontSize: 12, color: PointsMeTheme.textMuted),
                                ),
                                const Text(
                                  '1,250',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: PointsMeTheme.primaryGold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Payment method
                      PremiumCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'วิธีชำระเงิน',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: PointsMeTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: PointsMeTheme.darkSurface,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.payments_outlined, color: PointsMeTheme.textSecondary, size: 20),
                                ),
                                const SizedBox(width: 12),
                                const Text(
                                  'เงินสด',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: PointsMeTheme.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13, color: PointsMeTheme.textSecondary),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: PointsMeTheme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(String name, int qty, String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 14, color: PointsMeTheme.textPrimary),
            ),
          ),
          Text(
            'x$qty',
            style: TextStyle(fontSize: 13, color: PointsMeTheme.textMuted),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 60,
            child: Text(
              price,
              style: const TextStyle(
                fontSize: 14,
                color: PointsMeTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 13, color: PointsMeTheme.textSecondary),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isDiscount ? PointsMeTheme.successColor : PointsMeTheme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
