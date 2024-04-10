import 'package:expense_logo/deshbord/ui/add_money_record_screen.dart';
import 'package:expense_logo/deshbord/ui/money_record_chart_screen.dart';
import 'package:expense_logo/login/ui/money_record_screen.dart';
import 'package:expense_logo/util/app_string.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}
class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final List<Widget> _tabScreenList = [
    const MoneyRecordListScreen(),
    const MoneyRecordChartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
  appBar: AppBar(title: Text("Add Record"),),
        floatingActionButton: FloatingActionButton(onPressed: () {
          openAddTranscationScreen();
        },
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              setState(() {

              });
            });
          },

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              label: 'Money Record',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Chart',
            ),
          ],

        ),
        body: _tabScreenList[_selectedIndex],
      ),
    );
  }
  void openAddTranscationScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddMoneyRecordScreen();
    }));
  }
}

