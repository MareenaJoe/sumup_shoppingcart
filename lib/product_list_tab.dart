import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:sumupshopping/model/sale_Item.dart';

import 'model/app_state_model.dart';
import 'product_row_item.dart';

class ProductListTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, model, child) {
        List<SaleItem> products = model.getProductsBySelectedEvent();
        return CustomScrollView(
          semanticChildCount: products.length,
          slivers: <Widget>[
            const CupertinoSliverNavigationBar(
              largeTitle: Text('Products List'),
            ),
            SliverSafeArea(
              top: false,
              minimum: const EdgeInsets.only(top: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    if (index < products.length) {
                      return ProductRowItem(
                        index: index,
                        product: products[index],
                        lastItem: index == products.length - 1,
                      );
                    }

                    return null;
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }
}