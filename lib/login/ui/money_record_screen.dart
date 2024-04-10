import 'package:expense_logo/deshbord/model/money_record_model.dart';
import 'package:expense_logo/deshbord/provider/money_record_provider.dart';
import 'package:expense_logo/deshbord/ui/add_money_record_screen.dart';
import 'package:expense_logo/deshbord/ui/money_record_detile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../deshbord/ui/edit_money_record_screen.dart';
import '../../deshbord/ui/widgwt/money_record_list_item_widget.dart';

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
      floatingActionButton: FloatingActionButton(onPressed: () {
        openAddTranslationScreen();
      },
        child: const Icon(Icons.add),),

      body: Consumer<MoneyRecordProvider>(
        builder: (context, moneyRecordProvider, widget) {
          return Padding(padding: const EdgeInsets.all(16),
            child: ListView.separated(shrinkWrap: true,
                itemBuilder: (context, index) {
                  MoneyRecord moneyRecord =
                  moneyRecordProvider.moneyRecordList[index];
                  return Slidable(key: ValueKey(index),
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
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                }, itemCount: moneyRecordProvider.moneyRecordList.length),
          );
        },
      ),);
  }

  void showDeleteConfirmDialog(MoneyRecord moneyRecord) {
    showDialog(
        context: context, builder: (context) {
      return AlertDialog(title: const Text("Delete Alert"),
          content: const Text('Are you sure want to delete this?'),
              actions: <Widget>[
          TextButton( onPressed: ()
      {
        Navigator.of(context).pop();
      },
      child: const Text("Cancel"), ),
      TextButton( onPressed: () {
      deleteMoneyRecord(moneyRecord.id!); Navigator.of(context).pop();
      }, child: const Text('Okay'),
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

  void openAddTranslationScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddMoneyRecordScreen();
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