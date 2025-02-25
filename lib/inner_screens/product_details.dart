import 'dart:ui';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sehetak2/consts/colors.dart';
import 'package:sehetak2/consts/my_icons.dart';
import 'package:sehetak2/provider/cart_provider.dart';
import 'package:sehetak2/provider/dark_theme_provider.dart';
import 'package:sehetak2/provider/favs_provider.dart';
import 'package:sehetak2/provider/products.dart';
import 'package:sehetak2/screens/cart.dart';
import 'package:sehetak2/screens/wishlist.dart';
import 'package:sehetak2/services/payment.dart';
import 'package:sehetak2/widget/feeds_products.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';
import 'package:sehetak2/widget/popular_products.dart';
import 'package:progress_dialog/progress_dialog.dart';
class ProductDetails extends StatefulWidget {
  static const routeName = '/ProductDetails';

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {

 void payWithCard({int amount}) async {
    ProgressDialog dialog = ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var response = await StripeService.payWithNewCard(
        currency: 'USD', amount: amount.toString());
    await dialog.hide();
    print('response : ${response.message}');
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration: Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
  }


  GlobalKey previewContainer = new GlobalKey();

  get textSelectionColor => null;
 
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final productsData = Provider.of<Products>(context, listen: false);
    final productId = ModalRoute.of(context).settings.arguments as String;
    final cartProvider = Provider.of<CartProvider>(context);
     final favsProvider = Provider.of<FavsProvider>(context);

    print('productId $productId');
    final prodAttr = productsData.findById(productId);
    final productsList = productsData.products;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            foregroundDecoration: BoxDecoration(color: Colors.black12),
            height: MediaQuery.of(context).size.height * 0.45,
            width: double.infinity,
            child: Image.network(
              prodAttr.imageUrl,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 250),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.purple.shade200,
                          onTap: () {},
                          borderRadius: BorderRadius.circular(30),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.save,
                              size: 23,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.purple.shade200,
                          onTap: () {},
                          borderRadius: BorderRadius.circular(30),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.share,
                              size: 23,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  //padding: const EdgeInsets.all(16.0),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Text(
                                prodAttr.title,
                                maxLines: 2,
                                style: TextStyle(
                                  // color: Theme.of(context).textSelectionColor,
                                  color: HexColor('#25282B'),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'US \$ ${prodAttr.price}',
                              style: TextStyle(
                                  color: themeState.darkTheme
                                      ? Theme.of(context).disabledColor
                                      : ColorsConsts.subTitle,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 3.0),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          prodAttr.description,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.0,
                            color: themeState.darkTheme
                                ? Theme.of(context).disabledColor
                                : ColorsConsts.subTitle,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(
                          thickness: 1,
                          color: Colors.grey,
                          height: 1,
                        ),
                      ),
                      _details(themeState.darkTheme, 'Brand: ', prodAttr.brand),
                      _details(themeState.darkTheme, 'Quantity: ',
                          '${prodAttr.quantity}'),
                      _details(themeState.darkTheme, 'Category: ',
                          prodAttr.productCategoryName),
                      _details(themeState.darkTheme, 'Popularity: ',
                          prodAttr.isPopular ? 'Popular' : 'Barely known'),
                      SizedBox(
                        height: 15,
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey,
                        height: 1,
                      ),

                      // const SizedBox(height: 15.0),
                      Container(
                        color: Theme.of(context).backgroundColor,
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10.0),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'No reviews yet',
                                style: TextStyle(
                                    color: textSelectionColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 21.0),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                'Be the first review!',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20.0,
                                  color: themeState.darkTheme
                                      ? Theme.of(context).disabledColor
                                      : ColorsConsts.subTitle,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 70,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 100.0),
                              child: Divider(
                                thickness: 0.5,
                                color: Color.fromARGB(255, 184, 22, 22),
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 15.0),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8.0),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Text(
                    'Suggested products:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  width: double.infinity,
                  height: 340,
                  child: ListView.builder(
                    itemCount: 7,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext ctx, int index) {
                      return ChangeNotifierProvider.value(
                          value: productsList[index], child: PopularProducts());
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  "DETAIL",
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      MyAppIcons.wishlist,
                      color: ColorsConsts.favColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(WishlistScreen.routeName);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      MyAppIcons.cart,
                      color: ColorsConsts.cartColor,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(CartScreen.routeName);
                    },
                  ),
                ]),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Row(children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 50,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 100, 118, 125),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(side: BorderSide.none),
                        foregroundColor: Color.fromARGB(255, 23, 189, 255),
                      ),
                      onPressed:
                          cartProvider.getCartItems.containsKey(productId)
                              ? () {}
                              : () {
                                  cartProvider.addProductToCart(
                                      productId,
                                      prodAttr.price,
                                      prodAttr.title,
                                      prodAttr.imageUrl);
                                },
                      child: Text(
                        cartProvider.getCartItems.containsKey(productId)
                            ? 'In cart'
                            : 'Add to Cart'.toUpperCase(),
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 255, 255, 255)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 50,
                    child: TextButton(
                      style: TextButton.styleFrom(
                         backgroundColor: Color.fromARGB(255, 100, 118, 125),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(side: BorderSide.none),
                        foregroundColor: Color.fromARGB(255, 22, 45, 77),
                      ),
                      onPressed: () {
                          double amountInCents = prodAttr.price * 1000;
                        int intengerAmount = (amountInCents / 10).ceil();
                        payWithCard(amount: intengerAmount);
                      },
                      child: Row(
                        children: [
                          Text(
                            'Buy now'.toUpperCase(),
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 255, 255, 255)),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.payment,
                            color: Color.fromARGB(255, 82, 224, 89),
                            size: 19,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: themeState.darkTheme
                        ? Theme.of(context).disabledColor
                        : ColorsConsts.subTitle,
                    height: 50,
                    child: InkWell(
                      splashColor: ColorsConsts.favColor,
                      onTap: () {
                         favsProvider.addAndRemoveFromFav(
                                  productId,
                                  prodAttr.price,
                                  prodAttr.title,
                                  prodAttr.imageUrl);
                              Navigator.canPop(context)
                                  ? Navigator.pop(context)
                                  : null;
                      },
                      child: Center(
                        child: Icon(
                          MyAppIcons.wishlist,
                          color: ColorsConsts.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ]))
        ],
      ),
    );
  }

  Widget _details(bool themeState, String title, String info) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 16, right: 16),
      child: Row(
        //  mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: textSelectionColor,
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
          ),
          Text(
            info,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 18.0,
              color: themeState
                  ? Theme.of(context).disabledColor
                  : ColorsConsts.subTitle,
            ),
          ),
        ],
      ),
    );
  }
}
