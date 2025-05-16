import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_mate/model/spend_model.dart';
import 'package:money_mate/model/spend_service.dart';
class SpendPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SpendPageState();
}

class _SpendPageState extends State<SpendPage> {
  int _selectedCategory = options[0].category;
  //controller
  TextEditingController _dateController = TextEditingController();
  TextEditingController _amountController=TextEditingController();
  TextEditingController _noteController=TextEditingController();

  //spend service
  final SpendService _spendService=SpendService();


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
                      controller: _amountController,
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
            IconSelector(onCategorySelected: (category) {
              _selectedCategory = category;
            },),

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
              controller: _noteController,
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
                onPressed:(){
                  if(_amountController.text.isEmpty || _dateController.text.isEmpty || _noteController.text.isEmpty){
                    Fluttertoast.showToast(
                        msg: "Vui lòng nhập đủ thông tin",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 13.0
                    );
                  }else{
                    // var newSpend=new SpendModel(
                    //     amount: int.parse(_amountController.text.trim().toString()),
                    //     category: _selectedCategory,
                    //     date: DateTime.parse(_dateController.text.trim().toString()),
                    //     note: _noteController.text.trim().toString());
                    // _spendService.addSpend(newSpend);
                    Fluttertoast.showToast(
                        msg: "Thêm thành công",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                        fontSize: 13.0
                    );
                    Navigator.pop(context);
                  }
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
  final int category;
  IconOption(this.icon, this.label,this.category);
}

final List<IconOption> options = [
  IconOption(Icons.fastfood, "Ăn uống",1),
  IconOption(Icons.directions_car, "Đi lại",2),
  IconOption(Icons.shopping_cart, "Mua sắm",3),
  IconOption(Icons.school, "Học tập",4),
  IconOption(Icons.healing, "Sức khỏe",5),
  IconOption(Icons.coffee, "Cafe",6),
  IconOption(Icons.movie, "Giải trí",7),
  IconOption(Icons.work, "Công việc",8),
  IconOption(Icons.help, "Khác",9),
];

class IconSelector extends StatefulWidget {

  final Function(int category) onCategorySelected; // nhận callback

  const IconSelector({super.key, required this.onCategorySelected});

  // const IconSelector({super.key});


  @override
  State<IconSelector> createState() => _IconSelectorState();

}
class _IconSelectorState extends State<IconSelector> {

  int? selectedLabel;

  @override
  void initState() {
    super.initState();
    if (options.isNotEmpty) {
      selectedLabel = options[0].category;
      widget.onCategorySelected(selectedLabel!); // Báo ngay khi mở widget
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Wrap(
          spacing: 24,
          runSpacing: 12,
          children: options.map((item) {
            final isSelected = selectedLabel == item.category;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedLabel = item.category;
                  widget.onCategorySelected(selectedLabel!);
                });
                // print("Bạn chọn: ${item.label}");
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
