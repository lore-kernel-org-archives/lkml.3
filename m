Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab3AVMzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 07:55:50 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:54314 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951Ab3AVMzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 07:55:46 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-20-50fe8c507db5
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, stern@rowland.harvard.edu, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        dianders@chromium.org, jg1.han@samsung.com, p.paneri@samsung.com
Subject: [PATCH v8 1/4] ARM: EXYNOS: Update & move usb-phy types to generic
 include layer
Date: Tue, 22 Jan 2013 18:30:40 +0530
Message-id: <1358859643-5030-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1358859643-5030-1-git-send-email-gautam.vivek@samsung.com>
References: <1358859643-5030-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkTjeg51+AwYP5xhaXd81hs5hxfh+T
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZby71MVYcFGp4sraz6wNjBNkuxg5OSQETCSu
	rXjACmGLSVy4t56ti5GLQ0hgKaPE+Vc3WLoYOcCKTh4JgYhPZ5TYenATVNFkJonpPVtZQLrZ
	BHQlmt7uYgSxRQRkJQ5f+c0MUsQs8JdJ4vGqfnaQhLBAtETn9I9gNouAqsSl9d/ZQGxeAXeJ
	JV0LWCDOUJB4c/sZM4jNKeAh8eHAabB6IaCa1m/vwTZLCDxnk7gw7ygTxCABiW+TD0GdKiux
	6QAzxBxJiYMrbrBMYBRewMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyMwME//eya9g3FV
	g8UhRgEORiUe3gf3/wYIsSaWFVfmHmKU4GBWEuHVrf8XIMSbklhZlVqUH19UmpNafIgxGWj5
	RGYp0eR8YNTklcQbGpuYmxqbWhoZmZmakiasJM7LeOpJgJBAemJJanZqakFqEcwWJg5OqQbG
	8DSfzacj7R9WVL2eLcw+Nfq9CaNzj45J9kUzyUWn/DuOzahRzMvTvhSZ8lDqjs+xZV/bb01O
	tBB/xpl89/lL03UZK0yurVBlu2N6N5Q/oJd1wYa8hk37k4OWhqYt3JU9mVMhJOvf9L8/n5md
	2jnryJqgs49yVnY7lvUr+D+4eu4Za2xiUt5OJZbijERDLeai4kQAwxwK+5ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t9jQd2Ann8BBsuvqFhc3jWHzWLG+X1M
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jx7lIX
	Y8FFpYoraz+zNjBOkO1i5OCQEDCROHkkpIuRE8gUk7hwbz1bFyMXh5DAdEaJrQc3QTmTmSSm
	92xlAaliE9CVaHq7ixHEFhGQlTh85TczSBGzwF8micer+tlBEsIC0RKd0z+C2SwCqhKX1n9n
	A7F5BdwllnQtYIFYpyDx5vYzZhCbU8BD4sOB02D1QkA1rd/es01g5F3AyLCKUTS1ILmgOCk9
	10ivODG3uDQvXS85P3cTIzjsn0nvYFzVYHGIUYCDUYmH98H9vwFCrIllxZW5hxglOJiVRHh1
	6/8FCPGmJFZWpRblxxeV5qQWH2JMBrpqIrOUaHI+MCbzSuINjU3MTY1NLU0sTMwsSRNWEudl
	PPUkQEggPbEkNTs1tSC1CGYLEwenVANjiI/X7iUmURwXOTYkCfU3cTL7Lizg3VssXnXzmc2e
	AN813nVsBk4WKpe+12ua7uNd+FCEJSNjJdupl4X/9h2v+JCmP3X1Q4a1TKpLEkommhazODw9
	q+V4tyhyj/x2B9HbP0pX2j+12y2wNb+l/fWFl7auTr6CTVHly0wfnAjsODVbpWJVhYYSS3FG
	oqEWc1FxIgB9eXaivwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updating the names of usb-phy types to more generic names:
USB_PHY_TYPE_DEIVCE & USB_PHY_TYPE_HOST; and further update
its dependencies.

Signed-off-by: Praveen Paneri <p.paneri@samsung.com>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Acked-by: Kukjin Kim <kgene.kim@samsung.com>
---
 drivers/usb/host/ehci-s5p.c         |    9 +++++----
 drivers/usb/host/ohci-exynos.c      |    9 +++++----
 include/linux/usb/samsung_usb_phy.h |   16 ++++++++++++++++
 3 files changed, 26 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/usb/samsung_usb_phy.h

diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 319dcfa..46ca5ef 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -17,6 +17,7 @@
 #include <linux/platform_device.h>
 #include <linux/of_gpio.h>
 #include <linux/platform_data/usb-ehci-s5p.h>
+#include <linux/usb/samsung_usb_phy.h>
 #include <plat/usb-phy.h>
 
 #define EHCI_INSNREG00(base)			(base + 0x90)
@@ -164,7 +165,7 @@ static int s5p_ehci_probe(struct platform_device *pdev)
 	}
 
 	if (pdata->phy_init)
-		pdata->phy_init(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
 
 	ehci = hcd_to_ehci(hcd);
 	ehci->caps = hcd->regs;
@@ -198,7 +199,7 @@ static int s5p_ehci_remove(struct platform_device *pdev)
 	usb_remove_hcd(hcd);
 
 	if (pdata && pdata->phy_exit)
-		pdata->phy_exit(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
 
 	clk_disable_unprepare(s5p_ehci->clk);
 
@@ -229,7 +230,7 @@ static int s5p_ehci_suspend(struct device *dev)
 	rc = ehci_suspend(hcd, do_wakeup);
 
 	if (pdata && pdata->phy_exit)
-		pdata->phy_exit(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
 
 	clk_disable_unprepare(s5p_ehci->clk);
 
@@ -246,7 +247,7 @@ static int s5p_ehci_resume(struct device *dev)
 	clk_prepare_enable(s5p_ehci->clk);
 
 	if (pdata && pdata->phy_init)
-		pdata->phy_init(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
 
 	/* DMA burst Enable */
 	writel(EHCI_INSNREG00_ENABLE_DMA_BURST, EHCI_INSNREG00(hcd->regs));
diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index aa3b884..804fb62 100644
--- a/drivers/usb/host/ohci-exynos.c
+++ b/drivers/usb/host/ohci-exynos.c
@@ -15,6 +15,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/usb-exynos.h>
+#include <linux/usb/samsung_usb_phy.h>
 #include <plat/usb-phy.h>
 
 struct exynos_ohci_hcd {
@@ -153,7 +154,7 @@ static int exynos_ohci_probe(struct platform_device *pdev)
 	}
 
 	if (pdata->phy_init)
-		pdata->phy_init(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
 
 	ohci = hcd_to_ohci(hcd);
 	ohci_hcd_init(ohci);
@@ -184,7 +185,7 @@ static int exynos_ohci_remove(struct platform_device *pdev)
 	usb_remove_hcd(hcd);
 
 	if (pdata && pdata->phy_exit)
-		pdata->phy_exit(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
 
 	clk_disable_unprepare(exynos_ohci->clk);
 
@@ -229,7 +230,7 @@ static int exynos_ohci_suspend(struct device *dev)
 	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
 
 	if (pdata && pdata->phy_exit)
-		pdata->phy_exit(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_exit(pdev, USB_PHY_TYPE_HOST);
 
 	clk_disable_unprepare(exynos_ohci->clk);
 
@@ -249,7 +250,7 @@ static int exynos_ohci_resume(struct device *dev)
 	clk_prepare_enable(exynos_ohci->clk);
 
 	if (pdata && pdata->phy_init)
-		pdata->phy_init(pdev, S5P_USB_PHY_HOST);
+		pdata->phy_init(pdev, USB_PHY_TYPE_HOST);
 
 	ohci_resume(hcd, false);
 
diff --git a/include/linux/usb/samsung_usb_phy.h b/include/linux/usb/samsung_usb_phy.h
new file mode 100644
index 0000000..9167826
--- /dev/null
+++ b/include/linux/usb/samsung_usb_phy.h
@@ -0,0 +1,16 @@
+/*
+ * Copyright (C) 2012 Samsung Electronics Co.Ltd
+ *		http://www.samsung.com/
+ *
+ * Defines phy types for samsung usb phy controllers - HOST or DEIVCE.
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+enum samsung_usb_phy_type {
+	USB_PHY_TYPE_DEVICE,
+	USB_PHY_TYPE_HOST,
+};
-- 
1.7.6.5

