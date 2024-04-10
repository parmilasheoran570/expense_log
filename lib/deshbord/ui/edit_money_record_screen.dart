import 'package:expense_logo/deshbord/model/money_record_model.dart';
import 'package:expense_logo/deshbord/provider/money_record_provider.dart';
import 'package:expense_logo/deshbord/ui/add_money_record_screen.dart';
import 'package:expense_logo/deshbord/ui/money_record_detile_screen.dart';
import 'package:expense_logo/deshbord/ui/widgwt/money_record_list_item_widget.dart';
import 'package:expense_logo/util/app_color.dart';
import 'package:expense_logo/util/app_constant.dart';
import 'package:expense_logo/util/app_string.dart';
import 'package:expense_logo/util/app_text_field.dart';
import 'package:expense_logo/util/apputil.dart';
import 'package:expense_logo/widget/radiobutton_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class MoneyRecordListScreen extends StatefulWidget {
  const MoneyRecordListScreen({super.key});

  @override State<MoneyRecordListScreen> createState() =>
      _MoneyRecordListScreenState();
}

class _MoneyRecordListScreenState extends State<MoneyRecordListScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      fetchMoneyRecord();
    });
    super.initState();
  }

  Future fetchMoneyRecord() async {
    final moneyProvider =
    Provider.of<MoneyRecordProvider>(context, listen: false);
    moneyProvider.getMoneyRecord();
  }

  Widget build(BuildContext context) {
    return Scaffold(


      body: Consumer<MoneyRecordProvider>(
        builder: (context, moneyRecordProvider, widget) {
          return Padding(padding: const EdgeInsets.all(16),
            child: ListView.separated(shrinkWrap: true,
                itemBuilder: (context, index) {
                  MoneyRecord moneyRecord =
                  moneyRecordProvider.moneyRecordList[index];
                  return Slidable(key: ValueKey(index),
                    child: GestureDetector(onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return MoneyRecordDetailScreen(
                              moneyRecord: moneyRecord,
                            );
                          }));
                    },
                        child: MoneyRecordListItemWidget(
                            moneyRecord: moneyRecord)),
                    endActionPane: ActionPane(motion: const ScrollMotion(),
                      children: [ SlidableAction(
                        onPressed: (context) {
                          showDeleteConfirmDialog(moneyRecord);
                        },
                        icon: Icons.delete, borderRadius: BorderRadius.circular(
                          16),
                      ), SlidableAction(
                        onPressed: (context) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return EditMoneyRecordScreen(
                                  moneyRecord: moneyRecord,
                                );
                              }));
                        },
                        icon: Icons.edit,
                        borderRadius: BorderRadius.circular(16),),
                      ],),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                }, itemCount: moneyRecordProvider.moneyRecordList.length),
          );
        },
      ),);
  }

  void showDeleteConfirmDialog(MoneyRecord moneyRecord) {
    showDialog(
        context: context, builder: (context) {
      return AlertDialog(title: Text("Delete Alert"),
        content: Text('Are you sure want to delete this?'),


        actions: <Widget>[
          TextButton(onPressed: () {
            Navigator.of(context).pop();
          },
            child: Text("Cancel"),),
          TextButton(onPressed: () {
            deleteMoneyRecord(moneyRecord.id!);
            Navigator.of(context).pop();
          }, child: Text('Okay'),
          )
          ,
        ]
        ,
      );
    });
  }

  void openEditMoneyRecordScreen(MoneyRecord moneyRecord) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditMoneyRecordScreen(moneyRecord: moneyRecord);
    }));
  }


  Future deleteMoneyRecord(int id) async {
    MoneyRecordProvider moneyRecordProvider = Provider.of<MoneyRecordProvider>(
        context, listen: false);
    await moneyRecordProvider.deleteMoneyRecord(id);
    if (moneyRecordProvider.error == null) {
      moneyRecordProvider.getMoneyRecord();
    }
  }
}


class EditMoneyRecordScreen extends StatefulWidget {
  final MoneyRecord moneyRecord;

  const EditMoneyRecordScreen({super.key, required this.moneyRecord});

  @override
  _EditMoneyRecordScreenState createState() => _EditMoneyRecordScreenState();
}

class _EditMoneyRecordScreenState extends State<EditMoneyRecordScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  String? selectedCategory;
  late int _selectedDate = DateTime
      .now()
      .millisecondsSinceEpoch;
  late MoneyRecordType _transactionType = MoneyRecordType.expense;

  List<String> _categories = AppConstant.getRecordCategories();

  @override void initState() {
    selectedCategory = widget.moneyRecord.category;
    _titleController.text = widget.moneyRecord.title;
    _amountController.text = widget.moneyRecord.amount.toString();
    _selectedDate = widget.moneyRecord.date;
    _transactionType = widget.moneyRecord.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(editMoneyTitleText),
      ), body: Padding(
      padding: const EdgeInsets.all(16.0), child: SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [ AppTextField(
          controller: _titleController, hintText: 'Title',
        ), SizedBox(height: 8),
          AppTextField(controller: _amountController,
            hintText: 'Amount',
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ), SizedBox(height: 8),
          Container(padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),),
            child: DropdownButtonFormField(value: selectedCategory,
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category, child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value as String?;
                });
              }, decoration: InputDecoration(
                labelText: 'Category', border: InputBorder.none,
              ),),
          ), SizedBox(
            height: 16,),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  'Date:${AppUtil.formattedDate(_selectedDate).toString()}'),
              TextButton(
                onPressed: () { // Implement date picker here
                }, child: Text('Select Date'),
              ),
            ],
          ), SizedBox(height: 16),
          Text('Select Transaction Type:'), Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            RadioButtonWidget<MoneyRecordType>(value: MoneyRecordType.income,


              selectedValue: _transactionType, onChanged: (value) {
                setState(() {
                  _transactionType = value as MoneyRecordType;
                });
              },
              title: 'Income',),
            RadioButtonWidget<MoneyRecordType>(value: MoneyRecordType.expense,
              selectedValue: _transactionType,
              onChanged: (value) {
                setState(() {
                  _transactionType = value as MoneyRecordType;
                });
              }, title: 'Expense',
            ),
          ],
          ), SizedBox(height: 16),
          InkWell(onTap: () async {
            await editMoneyRecord();
            fetchMoneyRecord();
          },
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: buttonBackground,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                'Add Record ', style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold,
              ),),
            ),),
        ],),
    ),),
    );
  }

  Future editMoneyRecord() async {
    String category = selectedCategory ?? "Default Category";
    MoneyRecord moneyRecord = MoneyRecord(
      id: widget.moneyRecord.id,
      title: _titleController.text,
      amount: double.parse(_amountController.text),
      category: category,
      date: _selectedDate,
      type: _transactionType,);
    final moneyProvider = Provider.of<MoneyRecordProvider>(
        context, listen: false);
    await moneyProvider.editMoneyRecord(moneyRecord);
    await moneyProvider.getMoneyRecord();
    if (moneyProvider.error == null) {
      if (mounted) {
        AppUtil.showToast(recordEditMsg);
        Navigator.pop(context);
      }
    }
  }

  Future fetchMoneyRecord() async {
    final moneyProvider = Provider.of<MoneyRecordProvider>(
        context, listen: false);
    moneyProvider.getMoneyRecord();
  }
}