Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab3AUNxy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 08:53:54 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:50203 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab3AUNxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 08:53:52 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-1d-50fd486e5e19
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, p.paneri@samsung.com
Subject: [PATCH] usb: phy: samsung: Remove __devinit,
 __devexit_p and __exit annotations
Date: Mon, 21 Jan 2013 19:30:12 +0530
Message-id: <1358776812-14158-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWyRsSkWjff42+AwdtDjBaXd81hs5i9pJ/F
	Ysb5fUwWi5a1MjuweHzeJBfAGMVlk5Kak1mWWqRvl8CV8XXqHKaCLp6Kha+usDQwruDqYuTk
	kBAwkfgw8xorhC0mceHeerYuRi4OIYGljBLPd89jgSl6N3cdC0RiOqPElJ1TGCGcyUwSe+Zv
	AWtnE9CVaHq7ixHEFhGQlTh85TczSBGzwGJGiS03V4MlhAWiJBovbgcbyyKgKtH4eBlYnFfA
	Q+Lb41tMEOsUJN7cfgbWLCFwmU1i09W57BANAhLfJh8CauYASshKbDrADFEvKXFwxQ2WCYyC
	CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEBt3pf8+kdzCuarA4xCjAwajEw5vQ9ydA
	iDWxrLgy9xCjBAezkgivgP3fACHelMTKqtSi/Pii0pzU4kOMyUDLJzJLiSbnAyMiryTe0NjE
	3NTY1NLIyMzUlDRhJXFexlNPAoQE0hNLUrNTUwtSi2C2MHFwSjUw6s1r8nbXi39wnaPmYEjC
	lmPnMp5uDX+4tUkqYOHtd4JnRBt38Cj7uJqJu92adsX2WmfE9CncXnsvyJWmzbo98cizKOZv
	lnoXQjrP3nm/r8pTft7WXZLJJ55J8q1Zypk5pf9sfVFu3w7Vde93Ls8rb9ift5PvzNXk3SKr
	/pi+Pdyo2mNePGWCnRJLcUaioRZzUXEiANL8O6x+AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t9jQd08j78BBm9azCwu75rDZjF7ST+L
	xYzz+5gsFi1rZXZg8fi8SS6AMaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJc
	SSEvMTfVVsnFJ0DXLTMHaImSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCG
	MePr1DlMBV08FQtfXWFpYFzB1cXIySEhYCLxbu46FghbTOLCvfVsXYxcHEIC0xklpuycwgjh
	TGaS2DN/CytIFZuArkTT212MILaIgKzE4Su/mUGKmAUWM0psubkaLCEsECXReHE72FgWAVWJ
	xsfLwOK8Ah4S3x7fYoJYpyDx5vYz5gmM3AsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525i
	BIf0M+kdjKsaLA4xCnAwKvHwJvT9CRBiTSwrrsw9xCjBwawkwitg/zdAiDclsbIqtSg/vqg0
	J7X4EGMy0PaJzFKiyfnAeMsriTc0NjE3NTa1NLEwMbMkTVhJnJfx1JMAIYH0xJLU7NTUgtQi
	mC1MHJxSDYxb96y6I3gmjfcn9xGRg0vqvb8cvLOsoD2MnWfOzAaxgjvP81Mm3lky2frh1vjD
	7MIF7nXrdWy8+S5zXVhwfGO2bYY79yHG2WVzLfXyBFzSLlWvXTWL2WjmweD1VzMmZpyTOhro
	f/B4cUJOXUiKzNk9rHf+3l/z4FDyFQW9ZWsvLDvSX6OZsYpfiaU4I9FQi7moOBEAfpBgAa0C	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dropping __devinit, __devexit_p, __exit annotations since they are
nop and no longer supported.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/phy/samsung-usbphy.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/phy/samsung-usbphy.c b/drivers/usb/phy/samsung-usbphy.c
index 30aebb5..6b30809 100644
--- a/drivers/usb/phy/samsung-usbphy.c
+++ b/drivers/usb/phy/samsung-usbphy.c
@@ -343,7 +343,7 @@ static inline const struct samsung_usbphy_drvdata
 				platform_get_device_id(pdev)->driver_data;
 }
 
-static int __devinit samsung_usbphy_probe(struct platform_device *pdev)
+static int samsung_usbphy_probe(struct platform_device *pdev)
 {
 	struct samsung_usbphy *sphy;
 	struct samsung_usbphy_data *pdata = pdev->dev.platform_data;
@@ -405,7 +405,7 @@ static int __devinit samsung_usbphy_probe(struct platform_device *pdev)
 	return usb_add_phy(&sphy->phy, USB_PHY_TYPE_USB2);
 }
 
-static int __exit samsung_usbphy_remove(struct platform_device *pdev)
+static int samsung_usbphy_remove(struct platform_device *pdev)
 {
 	struct samsung_usbphy *sphy = platform_get_drvdata(pdev);
 
@@ -456,7 +456,7 @@ MODULE_DEVICE_TABLE(platform, samsung_usbphy_driver_ids);
 
 static struct platform_driver samsung_usbphy_driver = {
 	.probe		= samsung_usbphy_probe,
-	.remove		= __devexit_p(samsung_usbphy_remove),
+	.remove		= samsung_usbphy_remove,
 	.id_table	= samsung_usbphy_driver_ids,
 	.driver		= {
 		.name	= "samsung-usbphy",
-- 
1.7.6.5

