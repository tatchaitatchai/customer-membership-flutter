import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import '../../../../common/widgets/premium_card.dart';

class RankPrivilegesScreen extends StatelessWidget {
  const RankPrivilegesScreen({super.key});

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
                        'สิทธิพิเศษแต่ละแรงค์',
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
                      // Current rank highlight
                      _buildCurrentRankCard(),

                      const SizedBox(height: 24),

                      // All ranks
                      _buildRankCard(
                        rankName: 'BRONZE',
                        rankColor: PointsMeTheme.rankBronze,
                        icon: Icons.workspace_premium,
                        requirement: 'เริ่มต้น',
                        pointsRange: '0 - 499 แต้ม',
                        privileges: [
                          'รับแต้ม 1 แต้ม ต่อทุก ฿10',
                          'ส่วนลด 5% สำหรับทุกการสั่งซื้อ',
                        ],
                        isCurrent: false,
                      ),

                      const SizedBox(height: 12),

                      _buildRankCard(
                        rankName: 'SILVER',
                        rankColor: PointsMeTheme.rankSilver,
                        icon: Icons.workspace_premium,
                        requirement: 'สะสม 500 แต้ม',
                        pointsRange: '500 - 999 แต้ม',
                        privileges: [
                          'รับแต้ม 1.5 แต้ม ต่อทุก ฿10',
                          'ส่วนลด 8% สำหรับทุกการสั่งซื้อ',
                          'เครื่องดื่มฟรี 1 แก้ว ทุกเดือน',
                        ],
                        isCurrent: false,
                      ),

                      const SizedBox(height: 12),

                      _buildRankCard(
                        rankName: 'GOLD',
                        rankColor: PointsMeTheme.rankGold,
                        icon: Icons.workspace_premium,
                        requirement: 'สะสม 1,000 แต้ม',
                        pointsRange: '1,000 - 1,999 แต้ม',
                        privileges: [
                          'รับแต้ม 2 แต้ม ต่อทุก ฿10',
                          'ส่วนลด 10% สำหรับทุกการสั่งซื้อ',
                          'เครื่องดื่มฟรี 2 แก้ว ทุกเดือน',
                          'ของขวัญวันเกิดพิเศษ',
                        ],
                        isCurrent: true,
                      ),

                      const SizedBox(height: 12),

                      _buildRankCard(
                        rankName: 'PLATINUM',
                        rankColor: PointsMeTheme.rankPlatinum,
                        icon: Icons.diamond_outlined,
                        requirement: 'สะสม 2,000 แต้ม',
                        pointsRange: '2,000 - 4,999 แต้ม',
                        privileges: [
                          'รับแต้ม 2.5 แต้ม ต่อทุก ฿10',
                          'ส่วนลด 15% สำหรับทุกการสั่งซื้อ',
                          'เครื่องดื่มฟรี 3 แก้ว ทุกเดือน',
                          'ของขวัญวันเกิดพิเศษ',
                          'เข้าถึงเมนูพิเศษก่อนใคร',
                        ],
                        isCurrent: false,
                      ),

                      const SizedBox(height: 12),

                      _buildRankCard(
                        rankName: 'DIAMOND',
                        rankColor: PointsMeTheme.rankDiamond,
                        icon: Icons.diamond,
                        requirement: 'สะสม 5,000 แต้ม',
                        pointsRange: '5,000+ แต้ม',
                        privileges: [
                          'รับแต้ม 3 แต้ม ต่อทุก ฿10',
                          'ส่วนลด 20% สำหรับทุกการสั่งซื้อ',
                          'เครื่องดื่มฟรี 5 แก้ว ทุกเดือน',
                          'ของขวัญวันเกิดพิเศษ',
                          'เข้าถึงเมนูพิเศษก่อนใคร',
                          'บริการจัดส่งฟรี',
                          'เชิญเข้าร่วมอีเวนท์พิเศษ',
                        ],
                        isCurrent: false,
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

  Widget _buildCurrentRankCard() {
    return GoldGradientCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: PointsMeTheme.rankGold.withOpacity(0.2),
              border: Border.all(color: PointsMeTheme.rankGold, width: 2),
            ),
            child: const Icon(Icons.workspace_premium, color: PointsMeTheme.rankGold, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'แรงค์ปัจจุบันของคุณ',
                  style: TextStyle(fontSize: 12, color: PointsMeTheme.textSecondary),
                ),
                const SizedBox(height: 4),
                const Text(
                  'GOLD',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: PointsMeTheme.rankGold,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '1,250 แต้ม • อีก 750 แต้มเลื่อนขั้น',
                  style: TextStyle(fontSize: 12, color: PointsMeTheme.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankCard({
    required String rankName,
    required Color rankColor,
    required IconData icon,
    required String requirement,
    required String pointsRange,
    required List<String> privileges,
    required bool isCurrent,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: PointsMeTheme.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent ? rankColor.withOpacity(0.5) : PointsMeTheme.dividerColor.withOpacity(0.3),
          width: isCurrent ? 1.5 : 1,
        ),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: rankColor.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: rankColor, size: 24),
              const SizedBox(width: 8),
              Text(
                rankName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: rankColor,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              if (isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: rankColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'ปัจจุบัน',
                    style: TextStyle(
                      fontSize: 11,
                      color: rankColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              Text(
                requirement,
                style: TextStyle(fontSize: 12, color: PointsMeTheme.textMuted),
              ),
              const SizedBox(width: 8),
              Container(width: 3, height: 3, decoration: BoxDecoration(shape: BoxShape.circle, color: PointsMeTheme.textMuted)),
              const SizedBox(width: 8),
              Text(
                pointsRange,
                style: TextStyle(fontSize: 12, color: PointsMeTheme.textMuted),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ...privileges.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle, color: rankColor, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        p,
                        style: const TextStyle(
                          fontSize: 13,
                          color: PointsMeTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
