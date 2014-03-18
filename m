Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbaCRMGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 08:06:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59268 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364AbaCRME4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 08:04:56 -0400
X-AuditID: cbfee690-b7f266d00000287c-cf-5328365e86e0
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org, balbi@ti.com, myungjoo.ham@samsung.com
Cc: kishon@ti.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 2/2] extcon: Move OF helper function to extcon core and change
 function name
Date: Tue, 18 Mar 2014 21:04:40 +0900
Message-id: <1395144280-23240-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1395144280-23240-1-git-send-email-cw00.choi@samsung.com>
References: <1395144280-23240-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsWyRsSkQDfOTCPY4OAiQ4uD9+strn95zmrR
	vHg9m8WFpz1sFpd3zWGzmL2kn8Vi0bJWZovbjSvYHDg89s9dw+7Rt2UVo8fxG9uZPD5vkgtg
	ieKySUnNySxLLdK3S+DK+H5oA3PBW7uK1zcLGxh/GXcxcnJICJhI7L3xkgnCFpO4cG89Wxcj
	F4eQwFJGiW0bjrHBFB1aNIEFIrGIUeLPlFuMEE4jk8TCuycZQarYBLQk9r+4AdYhIuAmsafh
	ODNIEbNAH6PExMdrwHYIC8RJPH95DaiIg4NFQFViz2wTkDCvgKvEtO75UNvkJD7secQOYnMC
	zTmw/hFYqxBQzb7bLawgMyUE5rFLLN67AayIRUBA4tvkQywgMyUEZCU2HWCGmCMpcXDFDZYJ
	jMILGBlWMYqmFiQXFCelF5noFSfmFpfmpesl5+duYgQG+el/zybsYLx3wPoQYzLQuInMUqLJ
	+cAoySuJNzQ2M7IwNTE1NjK3NCNNWEmcV+1RUpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkG
	xkVdPN+n2kVt3bbfMHJ/zYQePZ/HJ+u+CF/Y3lL/QlRmw+n+HNlORhd2kzrjU1sWSs2MMFjy
	5/Bb18Y5j5SMOLeqx+6bUpzwWGtFSZ2r8jID3Y/i1nN1L9oHqj48UBQ7ZYkpx7Jki4CD3GXb
	JHkY8jK2nbF+I3xovukr38NvO49vfXuE8XObqRJLcUaioRZzUXEiABoVd5KIAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jAd04M41gg7dr1S0O3q+3uP7lOatF
	8+L1bBYXnvawWVzeNYfNYvaSfhaLRctamS1uN65gc+Dw2D93DbtH35ZVjB7Hb2xn8vi8SS6A
	JaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6Awl
	hbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8b3QxuYC97aVby+WdjA+Mu4
	i5GTQ0LAROLQogksELaYxIV769m6GLk4hAQWMUr8mXKLEcJpZJJYePckI0gVm4CWxP4XN9hA
	bBEBN4k9DceZQYqYBfoYJSY+XsMEkhAWiJN4/vIaUBEHB4uAqsSe2SYgYV4BV4lp3fPZILbJ
	SXzY84gdxOYEmnNg/SOwViGgmn23W1gnMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7
	iREcQ8+kdjCubLA4xCjAwajEw/uCTT1YiDWxrLgy9xCjBAezkgjvfh2NYCHelMTKqtSi/Pii
	0pzU4kOMyUBHTWSWEk3OB8Z3Xkm8obGJmZGlkbmhhZGxOWnCSuK8B1qtA4UE0hNLUrNTUwtS
	i2C2MHFwSjUwxnvVnS8/cn8P17JJulMXFc6Y2/L4wtmdl8WCX7n2txkoWW67LR//5JOq4suC
	fm1vFSXdx5x2CpWehXnv24/Fy5RY13qfeb5mztwjS2J/FkvLuqX4qPnNZHy+YvmT2QddHjGv
	Ntn3yLDjkrbWWxu5sm6+25yh3xs+MXwwNwwSy0y6WHv22odqJZbijERDLeai4kQAduRFOuUC	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch move simply OF helper function to extcon core and change function
name as following:
- of_extcon_get_extcon_dev() -> extcon_get_edev_by_phandle()

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/Kconfig           |  4 ---
 drivers/extcon/Makefile          |  2 --
 drivers/extcon/extcon-class.c    | 43 ++++++++++++++++++++++++++++++
 drivers/extcon/of_extcon.c       | 56 ----------------------------------------
 drivers/usb/dwc3/dwc3-omap.c     |  3 +--
 include/linux/extcon.h           | 12 +++++++++
 include/linux/extcon/of_extcon.h | 31 ----------------------
 7 files changed, 56 insertions(+), 95 deletions(-)
 delete mode 100644 drivers/extcon/of_extcon.c
 delete mode 100644 include/linux/extcon/of_extcon.h

diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index bdb5a00..be56e8a 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -14,10 +14,6 @@ if EXTCON
 
 comment "Extcon Device Drivers"
 
-config OF_EXTCON
-	def_tristate y
-	depends on OF
-
 config EXTCON_GPIO
 	tristate "GPIO extcon support"
 	depends on GPIOLIB
diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
index 43eccc0..bf7861e 100644
--- a/drivers/extcon/Makefile
+++ b/drivers/extcon/Makefile
@@ -2,8 +2,6 @@
 # Makefile for external connector class (extcon) devices
 #
 
-obj-$(CONFIG_OF_EXTCON)		+= of_extcon.o
-
 obj-$(CONFIG_EXTCON)		+= extcon-class.o
 obj-$(CONFIG_EXTCON_GPIO)	+= extcon-gpio.o
 obj-$(CONFIG_EXTCON_ADC_JACK)	+= extcon-adc-jack.o
diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 7632233..bc4c789 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -31,6 +31,7 @@
 #include <linux/extcon.h>
 #include <linux/slab.h>
 #include <linux/sysfs.h>
+#include <linux/of.h>
 
 /*
  * extcon_cable_name suggests the standard cable names for commonly used
@@ -818,6 +819,48 @@ void extcon_dev_unregister(struct extcon_dev *edev)
 }
 EXPORT_SYMBOL_GPL(extcon_dev_unregister);
 
+#ifdef CONFIG_OF
+/*
+ * extcon_get_edev_by_phandle - Get the extcon device from devicetree
+ * @dev - instance to the given device
+ * @index - index into list of extcon_dev
+ *
+ * return the instance of extcon device
+ */
+struct extcon_dev *extcon_get_edev_by_phandle(struct device *dev, int index)
+{
+	struct device_node *node;
+	struct extcon_dev *edev;
+
+	if (!dev->of_node) {
+		dev_err(dev, "device does not have a device node entry\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	node = of_parse_phandle(dev->of_node, "extcon", index);
+	if (!node) {
+		dev_err(dev, "failed to get phandle in %s node\n",
+			dev->of_node->full_name);
+		return ERR_PTR(-ENODEV);
+	}
+
+	edev = extcon_get_extcon_dev(node->name);
+	if (!edev) {
+		dev_err(dev, "unable to get extcon device : %s\n", node->name);
+		return ERR_PTR(-ENODEV);
+	}
+
+	return edev;
+}
+#else
+static inline struct extcon_dev *extcon_get_edev_by_phandle(struct device *dev,
+							    int index)
+{
+	return ERR_PTR(-ENOSYS);
+}
+#endif /* CONFIG_OF */
+EXPORT_SYMBOL_GPL(extcon_get_edev_by_phandle);
+
 static int __init extcon_class_init(void)
 {
 	return create_extcon_class();
diff --git a/drivers/extcon/of_extcon.c b/drivers/extcon/of_extcon.c
deleted file mode 100644
index 0a29f82..0000000
--- a/drivers/extcon/of_extcon.c
+++ /dev/null
@@ -1,56 +0,0 @@
-/*
- * OF helpers for External connector (extcon) framework
- *
- * Copyright (C) 2013 Texas Instruments, Inc.
- * Kishon Vijay Abraham I <kishon@ti.com>
- *
- * Copyright (C) 2013 Samsung Electronics
- * Chanwoo Choi <cw00.choi@samsung.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#include <linux/module.h>
-#include <linux/slab.h>
-#include <linux/err.h>
-#include <linux/extcon.h>
-#include <linux/of.h>
-#include <linux/of_platform.h>
-#include <linux/extcon/of_extcon.h>
-
-/*
- * of_extcon_get_extcon_dev - Get the name of extcon device from devicetree
- * @dev - instance to the given device
- * @index - index into list of extcon_dev
- *
- * return the instance of extcon device
- */
-struct extcon_dev *of_extcon_get_extcon_dev(struct device *dev, int index)
-{
-	struct device_node *node;
-	struct extcon_dev *edev;
-
-	if (!dev->of_node) {
-		dev_dbg(dev, "device does not have a device node entry\n");
-		return ERR_PTR(-EINVAL);
-	}
-
-	node = of_parse_phandle(dev->of_node, "extcon", index);
-	if (!node) {
-		dev_dbg(dev, "failed to get phandle in %s node\n",
-			dev->of_node->full_name);
-		return ERR_PTR(-ENODEV);
-	}
-
-	edev = extcon_get_extcon_dev(node->name);
-	if (!edev) {
-		dev_dbg(dev, "unable to get extcon device : %s\n", node->name);
-		return ERR_PTR(-ENODEV);
-	}
-
-	return edev;
-}
-EXPORT_SYMBOL_GPL(of_extcon_get_extcon_dev);
diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index b269dbd..b1d7ee6 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -29,7 +29,6 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/extcon.h>
-#include <linux/extcon/of_extcon.h>
 #include <linux/regulator/consumer.h>
 
 #include <linux/usb/otg.h>
@@ -522,7 +521,7 @@ static int dwc3_omap_probe(struct platform_device *pdev)
 	dwc3_omap_enable_irqs(omap);
 
 	if (of_property_read_bool(node, "extcon")) {
-		edev = of_extcon_get_extcon_dev(dev, 0);
+		edev = extcon_get_edev_by_phandle(dev, 0);
 		if (IS_ERR(edev)) {
 			dev_vdbg(dev, "couldn't get extcon device\n");
 			ret = -EPROBE_DEFER;
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 21c59af..f488145 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -240,6 +240,12 @@ extern int extcon_register_notifier(struct extcon_dev *edev,
 				    struct notifier_block *nb);
 extern int extcon_unregister_notifier(struct extcon_dev *edev,
 				      struct notifier_block *nb);
+
+/*
+ * Following API get the extcon device from devicetree.
+ * This function use phandle of devicetree to get extcon device directly.
+ */
+extern struct extcon_dev *extcon_get_edev_by_phandle(struct device *dev, int index);
 #else /* CONFIG_EXTCON */
 static inline int extcon_dev_register(struct extcon_dev *edev)
 {
@@ -324,5 +330,11 @@ static inline int extcon_unregister_interest(struct extcon_specific_cable_nb
 {
 	return 0;
 }
+
+static inline struct extcon_dev *extcon_get_edev_by_phandle(struct device *dev,
+							    int index)
+{
+	return ERR_PTR(-ENODEV);
+}
 #endif /* CONFIG_EXTCON */
 #endif /* __LINUX_EXTCON_H__ */
diff --git a/include/linux/extcon/of_extcon.h b/include/linux/extcon/of_extcon.h
deleted file mode 100644
index 0ebfeff..0000000
--- a/include/linux/extcon/of_extcon.h
+++ /dev/null
@@ -1,31 +0,0 @@
-/*
- * OF helpers for External connector (extcon) framework
- *
- * Copyright (C) 2013 Texas Instruments, Inc.
- * Kishon Vijay Abraham I <kishon@ti.com>
- *
- * Copyright (C) 2013 Samsung Electronics
- * Chanwoo Choi <cw00.choi@samsung.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- */
-
-#ifndef __LINUX_OF_EXTCON_H
-#define __LINUX_OF_EXTCON_H
-
-#include <linux/err.h>
-
-#if IS_ENABLED(CONFIG_OF_EXTCON)
-extern struct extcon_dev
-	*of_extcon_get_extcon_dev(struct device *dev, int index);
-#else
-static inline struct extcon_dev
-	*of_extcon_get_extcon_dev(struct device *dev, int index)
-{
-	return ERR_PTR(-ENOSYS);
-}
-#endif /* CONFIG_OF_EXTCON */
-#endif /* __LINUX_OF_EXTCON_H */
-- 
1.8.0

