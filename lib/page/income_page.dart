import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IncomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      //   padding: EdgeInsets.all(16), Padding(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 5),
        child: Column(
          children: [
            // const Text("Nhập số tiền thu nhập:",
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            const SizedBox(height: 2),
            const SizedBox(height: 30),

            // Nhập số tiền + đơn vị
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 180,
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        hintText: '0',
                        filled: true,
                        fillColor: Colors.grey.shade300,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'VND',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Tiêu đề Danh mục
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Danh mục",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),
            IconSelector(),

            const SizedBox(height: 10),

            Container(
              margin: EdgeInsets.symmetric(vertical: 0,horizontal: 0),
              child: TextField(
                controller: _dateController,
                readOnly: true,
                onTap: () {
                  _showDialogCalendar();
                },
                decoration: InputDecoration(
                  labelText: 'Thời gian',
                  labelStyle: TextStyle(
                      color: Colors.blue
                  ),
                  prefixIcon: Icon(Icons.calendar_today, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.lightBlue, width: 2),
                  ),
                ),
                style: TextStyle(fontSize: 16, color: Colors.black),
                textAlign: TextAlign.left,
              ),
            ),


            const SizedBox(height: 30),
            const Text(
              "Ghi chú",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: 'Nhập ghi chú...',
                filled: true,
                fillColor: Colors.grey.shade300,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  print('Nút được nhấn');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text('Thêm'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDialogCalendar() async {
    DateTime? _picker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (_picker != null) {
      setState(() {
        _dateController.text = _picker.toString().split(" ")[0];
      });
    }
  }
}

class IconOption {
  final IconData icon;
  final String label;

  IconOption(this.icon, this.label);
}

final List<IconOption> options = [
  IconOption(Icons.paid, "Phiếu lương"),
  IconOption(Icons.card_giftcard, "Quà tặng"),
  IconOption(Icons.interests, "Sở thích"),
  IconOption(Icons.help, "Khác"),
];

class IconSelector extends StatefulWidget {
  const IconSelector({super.key});


  @override
  State<IconSelector> createState() => _IconSelectorState();

}
class _IconSelectorState extends State<IconSelector> {
  String? selectedLabel; // giữ nhãn của icon được chọn

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Wrap(
          spacing: 24,
          runSpacing: 12,
          children: options.map((item) {
            final isSelected = selectedLabel == item.label;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedLabel = item.label;
                });
                print("Bạn chọn: ${item.label}");
              },
              child: Container(
                width: 80,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.shade100 : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item.icon,
                      size: 40,
                      color: isSelected ? Colors.blue : Colors.grey,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.blue : Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

}
