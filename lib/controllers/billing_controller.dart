import 'dart:async';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:image_ai/config/env.dart';
import 'package:flutter/material.dart';
import 'package:image_ai/data/token_storage.dart';
import 'package:image_ai/controllers/Auth/auth_controller.dart';

class BillingController extends GetxController {
  final RxBool isPro = false.obs;
  final RxBool storeAvailable = false.obs;
  final RxList<ProductDetails> products = <ProductDetails>[].obs;
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final _storage = TokenStorage();

  @override
  void onInit() {
    super.onInit();
    _hydratePro();
    _initStore();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  Future<void> _initStore() async {
    final available = await _iap.isAvailable();
    storeAvailable.value = available;
    if (!available) return;

    _subscription = _iap.purchaseStream.listen(_onPurchaseUpdated, onDone: () {
      _subscription?.cancel();
    }, onError: (Object error) {
      // handle error if needed
    });

    await queryProducts();
  }

  Future<void> queryProducts() async {
    final ids = <String>{Env.productWeekly, Env.productYearly};
    final response = await _iap.queryProductDetails(ids);
    products.assignAll(response.productDetails);
  }

  Future<void> buy(ProductDetails product) async {
    final param = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchases) async {
    for (final p in purchases) {
      switch (p.status) {
        case PurchaseStatus.pending:
          break;
        case PurchaseStatus.error:
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          // TODO: verify on backend if needed
          isPro.value = true;
          await _storage.saveIsPro(true);
          // Sync to backend (optional but recommended)
          try {
            final auth = Get.find<AuthController>();
            await auth.api.dio.post('/api/subscription/sync/', data: {
              'active': true,
              'product_id': p.productID,
              'platform': GetPlatform.isAndroid ? 'android' : 'ios',
            });
          } catch (_) {}
          if (p.pendingCompletePurchase) {
            await _iap.completePurchase(p);
          }
          break;
        case PurchaseStatus.canceled:
          break;
      }
    }
  }

  Future<void> restore() async {
    await _iap.restorePurchases();
  }

  Future<void> showPaywall() async {
    // Minimal bottom sheet paywall
    await Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Obx(() {
            final list = products;
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text('go_pro'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 8),
                if (list.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('please_wait'.tr, textAlign: TextAlign.center),
                  ),
                for (final p in list)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ElevatedButton(
                      onPressed: () => buy(p),
                      child: Text('${p.title} • ${p.price}'),
                    ),
                  ),
                TextButton(onPressed: restore, child: Text('restore_purchases'.tr)),
              ],
            );
          }),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> _hydratePro() async {
    final saved = await _storage.getIsPro();
    isPro.value = saved;
  }

  Future<void> syncFromServer() async {
    try {
      final auth = Get.find<AuthController>();
      final res = await auth.api.dio.get('/api/subscription/');
      final isProFromServer = res.data['is_pro'] == true;
      isPro.value = isProFromServer;
      await _storage.saveIsPro(isProFromServer);
    } catch (_) {}
  }
}
