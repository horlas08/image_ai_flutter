import 'dart:async';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:image_ai/config/env.dart';
import 'package:flutter/material.dart';
import 'package:image_ai/data/token_storage.dart';
import 'package:image_ai/controllers/Auth/auth_controller.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final ids = <String>{Env.productWeekly, Env.productYearly, Env.productTrialWeekly};
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
    ProductDetails? selected;
    bool trialToggle = true;
    await Get.bottomSheet(
      SafeArea(
        child: StatefulBuilder(builder: (context, setLocal) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Obx(() {
              final list = products;
              ProductDetails? yearly;
              ProductDetails? weekly;
              ProductDetails? trialWeekly;
              try { yearly = list.firstWhere((p) => p.id == Env.productYearly); } catch (_) { yearly = null; }
              try { weekly = list.firstWhere((p) => p.id == Env.productWeekly); } catch (_) { weekly = null; }
              try { trialWeekly = list.firstWhere((p) => p.id == Env.productTrialWeekly); } catch (_) { trialWeekly = null; }

              Widget planCard({required String title, required String subtitle, required String trailing, required ProductDetails? product, String? badge}) {
              final isSelected = selected?.id == product?.id;
              return GestureDetector(
                onTap: product == null ? null : () { setLocal(() { selected = product; }); },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFF2ECFF) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSelected ? const Color(0xFF7C4DFF) : const Color(0xFFE3E6EA)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0,2))],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                              const SizedBox(width: 8),
                              if (badge != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: const Color(0xFF2E2EFC), borderRadius: BorderRadius.circular(8)),
                                  child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                                ),
                            ]),
                            const SizedBox(height: 6),
                            Text(subtitle, style: const TextStyle(color: Colors.black54)),
                          ],
                        ),
                      ),
                      Text(trailing, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              );
              }

              // Prefer trial plan by default when toggle is on
              if (trialToggle && selected == null && trialWeekly != null) {
                selected = trialWeekly;
              }

              return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(children: [
                  Expanded(child: Text('unlimited_access_title'.tr, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900))),
                  IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close)),
                ]),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.spaceBetween,
                  children: const [
                    _FeatureChip(icon: Icons.lock_outline, labelKey: 'locked_transformations'),
                    _FeatureChip(icon: Icons.hd_outlined, labelKey: 'high_quality'),
                    _FeatureChip(icon: Icons.bolt_outlined, labelKey: 'fast_generation'),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2ECFF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text('free_trial_enabled'.tr, style: const TextStyle(fontWeight: FontWeight.w700))),
                      Switch(
                        value: trialToggle,
                        activeColor: const Color(0xFF7C4DFF),
                        onChanged: (v) {
                          setLocal(() { trialToggle = v; if (v && trialWeekly != null) selected = trialWeekly; });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                if (list.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('please_wait'.tr, textAlign: TextAlign.center),
                  ),
                if (yearly != null)
                  planCard(
                    title: 'yearly_plan'.tr,
                    subtitle: '${yearly.title}\n${yearly.description}',
                    trailing: yearly.price,
                    product: yearly,
                    badge: 'best_offer'.tr,
                  ),
                if (weekly != null)
                  planCard(
                    title: 'weekly_plan'.tr,
                    subtitle: '${weekly.title}\n${weekly.description}',
                    trailing: weekly.price,
                    product: weekly,
                  ),
                if (trialWeekly != null)
                  planCard(
                    title: 'three_day_trial'.tr,
                    subtitle: trialWeekly.description, // e.g., "then weekly"
                    trailing: 'free'.tr,
                    product: trialWeekly,
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.verified, size: 18, color: Color(0xFF7C4DFF)),
                    const SizedBox(width: 6),
                    Text('no_payment_now'.tr, style: const TextStyle(color: Colors.black54)),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    if (selected != null) buy(selected!);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C4DFF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('buy_now'.tr, style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded),
                    ],
                  ),
                ),
                TextButton(onPressed: restore, child: Text('restore_purchases'.tr)),
              ],
            );
            }),
          );
        }),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
    if(products.isEmpty) await queryProducts();
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

  Future<void> openManageSubscription() async {
    final androidUrl = Uri.parse(
        'https://play.google.com/store/account/subscriptions?package=${Env.androidPackageName}');
    // Apple uses a universal subscriptions management page
    final iosUrl = Uri.parse('https://apps.apple.com/account/subscriptions');
    final target = GetPlatform.isAndroid ? androidUrl : iosUrl;
    if (!await launchUrl(target, mode: LaunchMode.externalApplication)) {
      Get.snackbar('error'.tr, 'Could not open subscriptions page');
    }
  }
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String labelKey;
  const _FeatureChip({required this.icon, required this.labelKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE3E6EA)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black87),
          const SizedBox(width: 6),
          Text(labelKey.tr, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
