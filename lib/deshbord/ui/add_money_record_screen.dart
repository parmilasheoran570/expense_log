import 'package:expense_logo/deshbord/model/money_record_model.dart';
import 'package:expense_logo/deshbord/provider/money_record_provider.dart';
import 'package:expense_logo/util/app_color.dart';
import 'package:expense_logo/util/app_constant.dart';
import 'package:expense_logo/util/app_string.dart';
import 'package:expense_logo/util/app_text_field.dart';
import 'package:expense_logo/util/apputil.dart';
import 'package:expense_logo/widget/radiobutton_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddMoneyRecordScreen extends StatefulWidget {
  @override
  _AddMoneyRecordScreenState createState() => _AddMoneyRecordScreenState();
}

class _AddMoneyRecordScreenState extends State<AddMoneyRecordScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  String? selectedCategory;

  late int _selectedDate = DateTime.now().millisecondsSinceEpoch;
  late MoneyRecordType _transactionType = MoneyRecordType.expense;

  final List<String> _categories = AppConstant.getRecordCategories();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const
        Text(addMoneyTitleText),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                controller: _titleController,
                hintText: 'Title',
              ),
              const SizedBox(height: 8),
              AppTextField(
                controller: _amountController,
                hintText: 'Amount',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: DropdownButtonFormField(
                  value: selectedCategory,
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Date:${AppUtil.formattedDate(_selectedDate).toString()}'),
                  TextButton(
                    onPressed: () {
                      // Implement date picker here
                    },
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Select Transaction Type:'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  RadioButtonWidget<MoneyRecordType>(
                    value: MoneyRecordType.income,
                    selectedValue: _transactionType,
                    onChanged: (value) {
                      setState(() {
                        _transactionType = value;
                      });
                    },
                    title: 'Income',
                  ),
                  RadioButtonWidget<MoneyRecordType>(
                    value: MoneyRecordType.expense,
                    selectedValue: _transactionType,
                    onChanged: (value) {
                      setState(() {
                        _transactionType = value;
                      });
                    },
                    title: 'Expense',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  await addMoneyRecord();
                  fetchMoneyRecord();
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: buttonBackground,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Text(
                    'Add Record ',
                    style: TextStyle(
                      color: Colors.white,
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

  Future addMoneyRecord() async {
    String category = selectedCategory ?? "Default Category";
    MoneyRecord moneyRecord = MoneyRecord(
      title: _titleController.text,
      amount: double.parse(_amountController.text),
      category: category,
      date: _selectedDate,
      type: _transactionType,
    );
    final moneyProvider =
        Provider.of<MoneyRecordProvider>(context, listen: false);
    await moneyProvider.addMoneyRecord(moneyRecord);
    if (moneyProvider.error == null) {
      if (mounted) {
        AppUtil.showToast('Record Added');
        Navigator.pop(context);
      }
    }
  }

  Future fetchMoneyRecord() async {
    final moneyProvider =
        Provider.of<MoneyRecordProvider>(context, listen: false);
    moneyProvider.getMoneyRecord();
  }
}
