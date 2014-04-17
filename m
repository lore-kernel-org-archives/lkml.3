Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161128AbaDQKQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 06:16:43 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63751 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161185AbaDQKKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 06:10:11 -0400
X-AuditID: cbfee68e-b7f566d000002344-b3-534fa87a002b
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv2 1/8] extcon: Add resource-managed extcon register function
Date: Thu, 17 Apr 2014 19:09:56 +0900
Message-id: <1397729403-32045-2-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397729403-32045-1-git-send-email-sangjung.woo@samsung.com>
References: <1397729403-32045-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWyRsSkWLdqhX+wwao+RYvrX56zWrx+YWhx
	edccNovbjSvYLBbsKbGYMfklmwObR9+WVYwenzfJBTBFcdmkpOZklqUW6dslcGU8/BpUsEGh
	4ueFy4wNjJ+kuhg5OSQETCSeHTvIAmGLSVy4t56ti5GLQ0hgKaPElBln2WCKHh7aB5WYziix
	dPo1FginjUniz9ppzCBVbAK6Ek8OXAazRQSCJTpOHmcCKWIWWMIo8e/kLbBRwgI+Em1f/jCC
	2CwCqhJNuxeDxXkFPCQW3b0E1MABtE5BYs4kG5Awp4CnxJ6tZ8HKhYBKti67wQoyU0LgO5vE
	27Mf2SHmCEh8m3yIBaJXVmLTAWaIqyUlDq64wTKBUXgBI8MqRtHUguSC4qT0IiO94sTc4tK8
	dL3k/NxNjMDQPf3vWd8OxpsHrA8xJgONm8gsJZqcDwz9vJJ4Q2MzIwtTE1NjI3NLM9KElcR5
	Fz1MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAKLreVDO4tsBVufPWz112+fyWJULvvyer
	pqzhmeYQdN3/7/G8CoNso48xE5/O4lk663PWVDGmD48UV0m6GvJ9Tp195OwC5ePHFos/CMx5
	79/8ePmJZE//2twYi/OWlfst7/MJu9X5+h2aeWJamk3ClVOvr1UWP9XQtM/00w07PYPRZ9NG
	Bc7FSizFGYmGWsxFxYkAwr5K0nMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t9jQd2qFf7BBpN3S1hc//Kc1eL1C0OL
	y7vmsFncblzBZrFgT4nFjMkv2RzYPPq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYx4+HXoIINChU/L1xmbGD8JNXFyMkhIWAi8fDQPjYIW0ziwr31QDYX
	h5DAdEaJpdOvsUA4bUwSf9ZOYwapYhPQlXhy4DKYLSIQLNFx8jgTSBGzwBJGiX8nb4GNEhbw
	kWj78ocRxGYRUJVo2r0YLM4r4CGx6O4loAYOoHUKEnMm2YCEOQU8JfZsPQtWLgRUsnXZDdYJ
	jLwLGBlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgRHxjOpHYwrGywOMQpwMCrx8E5Q9w8W
	Yk0sK67MPcQowcGsJMK7pBcoxJuSWFmVWpQfX1Sak1p8iDEZ6KiJzFKiyfnAqM0riTc0NjEz
	sjQyN7QwMjYnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBsad73Pm5LkoGB/6aCfPGln/
	8moUQ4TIRSOlqkmb9DNYnvoGLcsOyZQ3nL3pPQtHfA+bcaJ1VHbvZQOHe2tY92k/NVj26vKc
	N7vOGF1+Hy0VyOPt1NtsGdzQpuW8gTvg988nE8ssjugXP9HwnjBzccffurf+R7edET41ISNF
	yM0sL2Fe2ou/pUosxRmJhlrMRcWJAGJOc5jQAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add resource-managed extcon device register function for convenience.
For example, if a extcon device is attached with new
devm_extcon_dev_register(), that extcon device is automatically
unregistered on driver detach.

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
---
 drivers/extcon/extcon-class.c |   83 +++++++++++++++++++++++++++++++++++++++++
 include/linux/extcon.h        |    8 ++++
 2 files changed, 91 insertions(+)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 7ab21aa..accb49c 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -32,6 +32,7 @@
 #include <linux/slab.h>
 #include <linux/sysfs.h>
 #include <linux/of.h>
+#include <linux/gfp.h>
 
 /*
  * extcon_cable_name suggests the standard cable names for commonly used
@@ -819,6 +820,88 @@ void extcon_dev_unregister(struct extcon_dev *edev)
 }
 EXPORT_SYMBOL_GPL(extcon_dev_unregister);
 
+
+/*
+ * Device resource management
+ */
+
+struct extcon_devres {
+	struct extcon_dev *edev;
+};
+
+static void devm_extcon_release(struct device *dev, void *res)
+{
+	struct extcon_devres *dr = (struct extcon_devres *)res;
+
+	extcon_dev_unregister(dr->edev);
+}
+
+static int devm_extcon_match(struct device *dev, void *res, void *data)
+{
+	struct extcon_devres *dr = (struct extcon_devres *)res;
+	struct extcon_devres *match = (struct extcon_devres *)data;
+
+	return dr->edev == match->edev;
+}
+
+/**
+ * devm_extcon_dev_register() - Resource-managed extcon_dev_register()
+ * @dev:	device to allocate extcon device
+ * @edev:	the new extcon device to register
+ *
+ * Managed extcon_dev_register() function. If extcon device is attached with
+ * this function, that extcon device is automatically unregistered on driver
+ * detach. Internally this function calls extcon_dev_register() function.
+ * To get more information, refer that function.
+ *
+ * If extcon device is registered with this function and the device needs to be
+ * unregistered separately, devm_extcon_dev_unregister() should be used.
+ *
+ * RETURNS:
+ * 0 on success, negative error number on failure.
+ */
+int devm_extcon_dev_register(struct device *dev, struct extcon_dev *edev)
+{
+	struct extcon_devres *dr;
+	int rc;
+
+	dr = devres_alloc(devm_extcon_release, sizeof(struct extcon_devres),
+			GFP_KERNEL);
+	if (!dr)
+		return -ENOMEM;
+
+	rc = extcon_dev_register(edev);
+	if (rc) {
+		devres_free(dr);
+		return rc;
+	}
+
+	dr->edev = edev;
+	devres_add(dev, dr);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devm_extcon_dev_register);
+
+/**
+ * devm_extcon_dev_unregister() - Resource-managed extcon_dev_unregister()
+ * @dev:	device the extcon belongs to
+ * @edev:	the extcon device to unregister
+ *
+ * Unregister extcon device that is registered with devm_extcon_dev_register()
+ * function.
+ */
+void devm_extcon_dev_unregister(struct device *dev, struct extcon_dev *edev)
+{
+	struct extcon_devres match_dr = { edev };
+
+	WARN_ON(devres_destroy(dev, devm_extcon_release,
+			devm_extcon_match, &match_dr));
+
+	extcon_dev_unregister(edev);
+}
+EXPORT_SYMBOL_GPL(devm_extcon_dev_unregister);
+
 #ifdef CONFIG_OF
 /*
  * extcon_get_edev_by_phandle - Get the extcon device from devicetree
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index f488145..e1e85a1 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -188,6 +188,14 @@ extern void extcon_dev_unregister(struct extcon_dev *edev);
 extern struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name);
 
 /*
+ * Resource-managed extcon device register function.
+ */
+extern int devm_extcon_dev_register(struct device *dev,
+				struct extcon_dev *edev);
+extern void devm_extcon_dev_unregister(struct device *dev,
+				struct extcon_dev *edev);
+
+/*
  * get/set/update_state access the 32b encoded state value, which represents
  * states of all possible cables of the multistate port. For example, if one
  * calls extcon_set_state(edev, 0x7), it may mean that all the three cables
-- 
1.7.9.5

