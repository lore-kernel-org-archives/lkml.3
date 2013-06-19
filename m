Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab3FSF0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 01:26:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39971 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab3FSF0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 01:26:34 -0400
X-AuditID: cbfee691-b7fef6d000002d62-67-51c14108d886
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kishon@ti.com, balbi@ti.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: gregkh@linuxfoundation.org, cw00.choi@samsung.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Subject: [PATCH v3] extcon: Add an API to get extcon device from dt node
Date: Wed, 19 Jun 2013 14:26:16 +0900
Message-id: <1371619576-23628-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1370276020-17446-2-git-send-email-kishon@ti.com>
References: <1370276020-17446-2-git-send-email-kishon@ti.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsWyRsSkWJfT8WCgwYR3rBYH79dbXP/ynNXi
	wOyHrBbNi9ezWVx42sNmcbbpDbvF5V1z2CxuN65gc+Dw2D93DbvH+RkLGT36tqxi9Dh+YzuT
	x+dNcgGsUVw2Kak5mWWpRfp2CVwZyy7dYy+Yr1txYNtT9gbG46pdjJwcEgImEg+vHGCDsMUk
	LtxbD2RzcQgJLGWUODjlEQtM0fl711ghEosYJY5N3wVV9Z9RonHJe7AqNgEtif0vboCNEhFI
	kVi7di47iM0skCPx78F9MFtYwENiyoPfYDaLgKrE83YIm1fAVeJQ6yR2iG1yEh/2PAKzOQXs
	JPYt6APazAG0zBZoFwvIXgmBeewSv5a3skDMEZD4NvkQC0iNhICsxKYDzBBjJCUOrrjBMoFR
	eAEjwypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MwHA//e/ZxB2M9w9YH2JMBho3kVlKNDkf
	GC95JfGGxmZGFqYmpsZG5pZmpAkrifOqt1gHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDk
	/FwttGpC5vtDgnezEyNLnp3e+FRzjvwtHealZ1aWVEXu/Gyev9yxfk0wc9Ih668RW7WfB3eH
	lJWYe13TW6Xv3Vt0MzVWL0bUZtGKGZ0lyycprZvtOP/zh+UZ+/wL+Pzk5XfeeNvXb32Sq2n/
	x6e6Wje7bmd3nCp2MWmNWLBCsYzx8CfLmalKLMUZiYZazEXFiQDy/TF2jQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t9jAV0Ox4OBBv/aLS0O3q+3uP7lOavF
	gdkPWS2aF69ns7jwtIfN4mzTG3aLy7vmsFncblzB5sDhsX/uGnaP8zMWMnr0bVnF6HH8xnYm
	j8+b5AJYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTd
	MnOAblFSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZiy7dI+9YL5uxYFt
	T9kbGI+rdjFyckgImEicv3eNFcIWk7hwbz1bFyMXh5DAIkaJY9N3QTn/GSUal7xnAaliE9CS
	2P/iBhuILSKQIrF27Vx2EJtZIEfi34P7YLawgIfElAe/wWwWAVWJ5+0QNq+Aq8Sh1knsENvk
	JD7seQRmcwrYSexb0Ad0BQfQMlugXSwTGHkXMDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/d
	xAiOpmdSOxhXNlgcYhTgYFTi4W1YeSBQiDWxrLgy9xCjBAezkgivnsPBQCHelMTKqtSi/Pii
	0pzU4kOMyUBHTWSWEk3OB0Z6Xkm8obGJmZGlkbmhhZGxOWnCSuK8B1qtA4UE0hNLUrNTUwtS
	i2C2MHFwSjUwHj7Z55TScu7sba6Ju5KPVD3d03bI8jb3k1bD/dG52RKybD7RC4Mj9OuteFbO
	bp8rfWpvwFc5JyPx6LvPs09uXe3reu6f6sWF6wSeM9YYdzypSuFNOCGRp1PjLtJgsMBSq/BC
	6GWP13e6lij5cf4OCD8w/+7t5Xr9ojqV3eESJd6XtHuVSvuVWIozEg21mIuKEwGsSl2G6gIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kishon Vijay Abraham I <kishon@ti.com>

Added an API of_extcon_get_extcon_dev() to be used by drivers to get
extcon device in the case of dt boot (this can be used instead of
extcon_get_extcon_dev()).

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
Changes since v2:
- Add CONFIG_OF_EXTCON to Kconfig
- Use IS_ENABLED() macro to check both CONFIG_EXTCON and CONFIG_EXTCON_MODULE

Changes since v1:
- If edev->name is NULL, dev_name(dev) is used as edev->name.
- Change filename from of-extcon.* to of_extcon.*
- Fix build error when CONFIG_OF is not set
- Add header file(linux/err.h) to of_extcon.c

 drivers/extcon/Kconfig           |  4 +++
 drivers/extcon/Makefile          |  2 ++
 drivers/extcon/extcon-class.c    |  3 +-
 drivers/extcon/of_extcon.c       | 64 ++++++++++++++++++++++++++++++++++++++++
 include/linux/extcon/of_extcon.h | 31 +++++++++++++++++++
 5 files changed, 103 insertions(+), 1 deletion(-)
 create mode 100644 drivers/extcon/of_extcon.c
 create mode 100644 include/linux/extcon/of_extcon.h

diff --git a/drivers/extcon/Kconfig b/drivers/extcon/Kconfig
index 63f454e..f1d54a3 100644
--- a/drivers/extcon/Kconfig
+++ b/drivers/extcon/Kconfig
@@ -14,6 +14,10 @@ if EXTCON
 
 comment "Extcon Device Drivers"
 
+config OF_EXTCON
+	def_tristate y
+	depends on OF
+
 config EXTCON_GPIO
 	tristate "GPIO extcon support"
 	depends on GPIOLIB
diff --git a/drivers/extcon/Makefile b/drivers/extcon/Makefile
index 540e2c3..759fdae 100644
--- a/drivers/extcon/Makefile
+++ b/drivers/extcon/Makefile
@@ -2,6 +2,8 @@
 # Makefile for external connector class (extcon) devices
 #
 
+obj-$(CONFIG_OF_EXTCON)		+= of_extcon.o
+
 obj-$(CONFIG_EXTCON)		+= extcon-class.o
 obj-$(CONFIG_EXTCON_GPIO)	+= extcon-gpio.o
 obj-$(CONFIG_EXTCON_ADC_JACK)	+= extcon-adc-jack.o
diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 23f11ea..08509ea 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -602,7 +602,8 @@ int extcon_dev_register(struct extcon_dev *edev, struct device *dev)
 	edev->dev->class = extcon_class;
 	edev->dev->release = extcon_dev_release;
 
-	dev_set_name(edev->dev, edev->name ? edev->name : dev_name(dev));
+	edev->name = edev->name ? edev->name : dev_name(dev);
+	dev_set_name(edev->dev, edev->name);
 
 	if (edev->max_supported) {
 		char buf[10];
diff --git a/drivers/extcon/of_extcon.c b/drivers/extcon/of_extcon.c
new file mode 100644
index 0000000..72173ec
--- /dev/null
+++ b/drivers/extcon/of_extcon.c
@@ -0,0 +1,64 @@
+/*
+ * OF helpers for External connector (extcon) framework
+ *
+ * Copyright (C) 2013 Texas Instruments, Inc.
+ * Kishon Vijay Abraham I <kishon@ti.com>
+ *
+ * Copyright (C) 2013 Samsung Electronics
+ * Chanwoo Choi <cw00.choi@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/extcon.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/extcon/of_extcon.h>
+
+/*
+ * of_extcon_get_extcon_dev - Get the name of extcon device from devicetree
+ * @dev - instance to the given device
+ * @index - index into list of extcon_dev
+ *
+ * return the instance of extcon device
+ */
+struct extcon_dev *of_extcon_get_extcon_dev(struct device *dev, int index)
+{
+	struct device_node *node;
+	struct extcon_dev *edev;
+	struct platform_device *extcon_parent_dev;
+
+	if (!dev->of_node) {
+		dev_dbg(dev, "device does not have a device node entry\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	node = of_parse_phandle(dev->of_node, "extcon", index);
+	if (!node) {
+		dev_dbg(dev, "failed to get phandle in %s node\n",
+			dev->of_node->full_name);
+		return ERR_PTR(-ENODEV);
+	}
+
+	extcon_parent_dev = of_find_device_by_node(node);
+	if (!extcon_parent_dev) {
+		dev_dbg(dev, "unable to find device by node\n");
+		return ERR_PTR(-EPROBE_DEFER);
+	}
+
+	edev = extcon_get_extcon_dev(dev_name(&extcon_parent_dev->dev));
+	if (!edev) {
+		dev_dbg(dev, "unable to get extcon device : %s\n",
+				dev_name(&extcon_parent_dev->dev));
+		return ERR_PTR(-ENODEV);
+	}
+
+	return edev;
+}
+EXPORT_SYMBOL_GPL(of_extcon_get_extcon_dev);
diff --git a/include/linux/extcon/of_extcon.h b/include/linux/extcon/of_extcon.h
new file mode 100644
index 0000000..0ebfeff
--- /dev/null
+++ b/include/linux/extcon/of_extcon.h
@@ -0,0 +1,31 @@
+/*
+ * OF helpers for External connector (extcon) framework
+ *
+ * Copyright (C) 2013 Texas Instruments, Inc.
+ * Kishon Vijay Abraham I <kishon@ti.com>
+ *
+ * Copyright (C) 2013 Samsung Electronics
+ * Chanwoo Choi <cw00.choi@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef __LINUX_OF_EXTCON_H
+#define __LINUX_OF_EXTCON_H
+
+#include <linux/err.h>
+
+#if IS_ENABLED(CONFIG_OF_EXTCON)
+extern struct extcon_dev
+	*of_extcon_get_extcon_dev(struct device *dev, int index);
+#else
+static inline struct extcon_dev
+	*of_extcon_get_extcon_dev(struct device *dev, int index)
+{
+	return ERR_PTR(-ENOSYS);
+}
+#endif /* CONFIG_OF_EXTCON */
+#endif /* __LINUX_OF_EXTCON_H */
-- 
1.8.0

