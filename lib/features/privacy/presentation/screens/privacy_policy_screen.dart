import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
                        'นโยบายความเป็นส่วนตัว',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        'นโยบายความเป็นส่วนตัว',
                        'Points ME ("แอปพลิเคชัน") ให้ความสำคัญกับความเป็นส่วนตัวของผู้ใช้งาน นโยบายความเป็นส่วนตัวนี้อธิบายวิธีการเก็บรวบรวม ใช้ และปกป้องข้อมูลส่วนบุคคลของคุณ',
                      ),
                      _buildSection(
                        '1. ข้อมูลที่เราเก็บรวบรวม',
                        '• เบอร์โทรศัพท์ - ใช้สำหรับการยืนยันตัวตนและเข้าสู่ระบบ\n'
                            '• ชื่อ-นามสกุล - ใช้สำหรับแสดงในบัญชีสมาชิก\n'
                            '• ประวัติการซื้อสินค้า - ใช้สำหรับคำนวณแต้มสะสมและแสดงประวัติ\n'
                            '• ข้อมูลการใช้งานแอป - ใช้สำหรับปรับปรุงประสบการณ์การใช้งาน',
                      ),
                      _buildSection(
                        '2. วัตถุประสงค์ในการใช้ข้อมูล',
                        '• เพื่อให้บริการระบบสมาชิกและสะสมแต้ม\n'
                            '• เพื่อแสดงสิทธิพิเศษและโปรโมชั่นที่เกี่ยวข้อง\n'
                            '• เพื่อส่งการแจ้งเตือนเกี่ยวกับแต้มสะสมและสิทธิพิเศษ\n'
                            '• เพื่อปรับปรุงและพัฒนาบริการของเรา',
                      ),
                      _buildSection(
                        '3. การแบ่งปันข้อมูล',
                        'เราจะไม่แบ่งปันข้อมูลส่วนบุคคลของคุณกับบุคคลภายนอก ยกเว้นในกรณีต่อไปนี้:\n\n'
                            '• เมื่อได้รับความยินยอมจากคุณ\n'
                            '• เมื่อจำเป็นตามกฎหมาย\n'
                            '• เพื่อปกป้องสิทธิ์และความปลอดภัยของผู้ใช้งาน',
                      ),
                      _buildSection(
                        '4. การรักษาความปลอดภัย',
                        'เราใช้มาตรการรักษาความปลอดภัยที่เหมาะสมเพื่อปกป้องข้อมูลส่วนบุคคลของคุณจากการเข้าถึงโดยไม่ได้รับอนุญาต การเปลี่ยนแปลง การเปิดเผย หรือการทำลาย',
                      ),
                      _buildSection(
                        '5. สิทธิ์ของผู้ใช้งาน',
                        '• สิทธิ์ในการเข้าถึงข้อมูลส่วนบุคคลของคุณ\n'
                            '• สิทธิ์ในการแก้ไขข้อมูลที่ไม่ถูกต้อง\n'
                            '• สิทธิ์ในการลบข้อมูลส่วนบุคคล (ลบบัญชี)\n'
                            '• สิทธิ์ในการถอนความยินยอม',
                      ),
                      _buildSection(
                        '6. การลบบัญชี',
                        'คุณสามารถลบบัญชีได้ตลอดเวลาผ่านเมนู "โปรไฟล์" > "ลบบัญชี" เมื่อลบบัญชีแล้ว ข้อมูลทั้งหมดรวมถึงแต้มสะสมจะถูกลบอย่างถาวรและไม่สามารถกู้คืนได้',
                      ),
                      _buildSection(
                        '7. การเปลี่ยนแปลงนโยบาย',
                        'เราอาจปรับปรุงนโยบายความเป็นส่วนตัวนี้เป็นครั้งคราว การเปลี่ยนแปลงจะมีผลเมื่อเผยแพร่บนแอปพลิเคชัน',
                      ),
                      _buildSection(
                        '8. ติดต่อเรา',
                        'หากคุณมีคำถามเกี่ยวกับนโยบายความเป็นส่วนตัว สามารถติดต่อเราได้ที่:\n\n'
                            'อีเมล: support@pointsme.com\n'
                            'โทร: 02-XXX-XXXX',
                      ),

                      const SizedBox(height: 16),

                      Center(
                        child: Text(
                          'อัปเดตล่าสุด: กุมภาพันธ์ 2026',
                          style: TextStyle(
                            fontSize: 12,
                            color: PointsMeTheme.textMuted,
                          ),
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

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: PointsMeTheme.primaryGold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: PointsMeTheme.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
