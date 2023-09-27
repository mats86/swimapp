import 'package:flutter/material.dart';

class Customer {
  final String name;
  final String status;

  Customer(this.name, this.status);
}

class CustomerList extends StatefulWidget {
  final List<Customer> customers;

  const CustomerList(this.customers, {Key? key}) : super(key: key);

  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  String filterStatus = 'Alle';
  String searchText = '';

  List<Customer> get filteredCustomers {
    return widget.customers
        .where((customer) =>
            filterStatus == 'Alle' || customer.status == filterStatus)
        .where((customer) =>
            searchText.isEmpty ||
            customer.name.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
  }

  Icon getStatusIcon(String status) {
    IconData iconData;
    Color iconColor;

    switch (status) {
      case 'Aktiv':
        iconData = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case 'Inaktiv':
        iconData = Icons.cancel;
        iconColor = Colors.red;
        break;
      default:
        iconData = Icons.info;
        iconColor = Colors.blue;
        break;
    }

    return Icon(
      iconData,
      color: iconColor,
    );
  }

  void _onListItemTap(Customer customer) {
    // Hier kannst du die Aktion ausführen, die du bei Klick auf ein Listenelement ausführen möchtest.
    // Zum Beispiel: Navigieren zu einer Detailseite oder etwas anderes.
    print('Tapped on customer: ${customer.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kundenverwaltung'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: filterStatus,
            onChanged: (newValue) {
              setState(() {
                filterStatus = newValue!;
              });
            },
            items: const [
              DropdownMenuItem<String>(
                value: 'Alle',
                child: Text('Alle anzeigen'),
              ),
              DropdownMenuItem<String>(
                value: 'Aktiv',
                child: Text('Aktive Kunden'),
              ),
              DropdownMenuItem<String>(
                value: 'Inaktiv',
                child: Text('Inaktive Kunden'),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Suche nach Kunden',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = filteredCustomers[index];
                final backgroundColor =
                    index % 2 == 0 ? Colors.white : Colors.grey.shade100;
                return InkWell(
                  onTap: () {
                    _onListItemTap(customer); // Hier wird die Aktion ausgelöst
                  },
                  child: Card(
                    color: backgroundColor,
                    child: ListTile(
                      title: Text(
                        customer.name,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: getStatusIcon(customer.status),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
