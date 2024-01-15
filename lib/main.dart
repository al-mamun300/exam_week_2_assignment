import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Bag',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 34,
            ),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        body: const CartPage(),
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [
    CartItem(
      productName: 'Pullover',
      price: 51,
      imageUrl:
          'https://static-01.daraz.com.bd/p/4b943529b32095aab69fed586d357a9b.jpg_750x400.jpg_.webp',
      color: 'Black',
      size: 'L',
    ),
    CartItem(
      productName: 'T-Shirt',
      price: 30,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcREbuDysOPks6iJoMTUbSfg89b1Qz089V0Rgg&usqp=CAU',
      color: 'Green',
      size: 'XL',
    ),
    CartItem(
      productName: 'Sweater',
      price: 43,
      imageUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSvn_phawJf4hfHLCPu731xGr3SXcM0Z9bD3Q&usqp=CAU',
      color: 'Olive',
      size: 'M',
    ),
  ];

  int totalAmount = 0;
  @override
  void initState() {
    super.initState();
    totalAmount = cartItems.fold(0, (sum, item) => sum + item.price);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          for (var item in cartItems)
            CartItemWidget(
              item: item,
              onItemAdded: (quantity) {
                setState(() {
                  if (quantity > item.quantity) {
                    item.quantity = quantity;
                  } else {
                    totalAmount -= item.price;
                    item.quantity = quantity;
                  }
                });
      
                if (quantity == 5) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Congratulations!'),
                          content: Text(
                              'You have added $quantity ${item.productName} to your bag!'),
                          actions: <Widget>[
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.red),
                                shadowColor: MaterialStateProperty.all(
                                    Colors.red.withOpacity(0.5)),
                                elevation: MaterialStateProperty.all(5),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.all(16.0)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OKAY',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        );
                      });
                }
      
                updateTotalAmount();
              },
            ),
          const SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                const Expanded(flex: 3, child: Text('Total Amount:')),
                const Spacer(),
                Expanded(
                  child: Text(
                    '\$$totalAmount',
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shadowColor:
                    MaterialStateProperty.all(Colors.red.withOpacity(0.5)),
                elevation: MaterialStateProperty.all(5),
                padding: MaterialStateProperty.all(const EdgeInsets.all(16.0)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                minimumSize:
                    MaterialStateProperty.all(const Size(double.infinity, 50)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Congratulations! Your order has been placed.'),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              child:
                  const Text('CHECK OUT', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  void updateTotalAmount() {
    totalAmount = getTotalPrice();
  }

  int getTotalPrice() {
    return cartItems.fold(0, (sum, item) => sum + item.quantity * item.price);
  }
}

class CartItem {
  String productName;
  int price;
  int quantity;
  String imageUrl;
  String color;
  String size;

  CartItem({
    required this.productName,
    required this.price,
    this.quantity = 1,
    required this.imageUrl,
    required this.color,
    required this.size,
  });
}

class CartItemWidget extends StatefulWidget {
  final CartItem item;
  final ValueChanged<int> onItemAdded;

  const CartItemWidget(
      {Key? key, required this.item, required this.onItemAdded})
      : super(key: key);

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      shadowColor: const Color(0x60FFFFFF),
      margin: const EdgeInsets.all(16.0),
      child: Container(
        color: Colors.white,
        child: Row(
          children: [
            Image.network(
              widget.item.imageUrl,
              width: 104,
              height: 104,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.productName,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Color: ',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                            TextSpan(
                              text: widget.item.color,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20.0),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Size: ',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 11),
                            ),
                            TextSpan(
                              text: widget.item.size,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.remove),
                          color: const Color(0xFF9B9B9B),
                          onPressed: () {
                            setState(() {
                              if (widget.item.quantity > 1) {
                                widget.item.quantity--;
                                widget.onItemAdded(widget.item.quantity);
                              }
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15, left: 15),
                        child: Text(
                          '${widget.item.quantity}',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          color: const Color(0xFF9B9B9B),
                          onPressed: () {
                            setState(() {
                              widget.item.quantity++;
                              widget.onItemAdded(widget.item.quantity);
                            });
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Column(
                children: [
                  const SizedBox(height: 8.0),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    color: const Color(0xFF9B9B9B),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    '\$${widget.item.price * widget.item.quantity}',
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
