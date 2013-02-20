Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934463Ab3BTJ3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:29:37 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:20425 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934014Ab3BTJ3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:29:31 -0500
X-AuditID: cbfee68e-b7fc26d000001938-c2-5124977ae34f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000f01ce0f4c$7c1d01d0$74570570$%han@samsung.com>
In-reply-to: <000f01ce0f4c$7c1d01d0$74570570$%han@samsung.com>
Subject: [PATCH V2 4/9] mfd: omap-usb-host: use devm_gpio_request_one()
Date: Wed, 20 Feb 2013 18:29:30 +0900
Message-id: <001201ce0f4c$c9143940$5b3cabc0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PTHvvVazquf7TSyaZqgztkH4/LAAADZ6A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zQ92q6SqBBntvG1pc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MVb/msxVcFqg4/6CFtYHxAW8XIweHhICJxIkF2V2MnECmmMSF
	e+vZQGwhgWWMEr9+CUPETST65/5i7GLkAopPZ5Q4eK+FDcKZzSTxdcUUFpAqNgE1iS9fDrOD
	2CICWhLdx86zgSxgFnCRODpNBGKorcSjrq3MIDangJ1Ey7V5YLawgLtE6/lbTCA2i4CqxPll
	08FsXqD6hYv3sEDYghI/Jt8Ds5mBxq/feZwJwpaX2LzmLTPEL+oSj/7qQlxgJPH2+hpmiBIR
	iX0v3oHdLyGwiF1i5bedbBC7BCS+TT7EAtErK7HpADPEv5ISB1fcYJnAKDELyeZZSDbPQrJ5
	FpIVCxhZVjGKphYkFxQnpRcZ6RUn5haX5qXrJefnbmKERFXfDsabB6wPMSYDrZ/ILCWanA+M
	yrySeENjYxMzE1MTc0tTc1PShJXEeeUvyQQKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYJwR
	d2mDiEbmqqcNTyPX75YJnHSYwS+4O9r+RtLr64UnvG67WE9YwdJu/lTd6SGrim62RNW73/PM
	Cx485a90E1pwcd1qoektmYscGU0+r79edI132Qq5u9ICpSZZ+6I5LVMqujy36/sn3LE4uzN6
	mu3hPME5IfqLVLOiv8zy2reUcUKCuvH3G0osxRmJhlrMRcWJAFObWgXAAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xoG7VdJVAg8fXdSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxqpf89kKLgtUnH/QwtrA
	+IC3i5GTQ0LARKJ/7i9GCFtM4sK99WxdjFwcQgLTGSUO3muBcmYzSXxdMYUFpIpNQE3iy5fD
	7CC2iICWRPex80BFHBzMAi4SR6eJgISFBGwlHnVtZQaxOQXsJFquzQOzhQXcJVrP32ICsVkE
	VCXOL5sOZvMC1S9cvIcFwhaU+DH5HpjNDDR+/c7jTBC2vMTmNW+ZQVZJCKhLPPqrC3GBkcTb
	62uYIUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn
	525iBMftM6kdjCsbLA4xCnAwKvHwasxXDhRiTSwrrsw9xCjBwawkwvuzQyVQiDclsbIqtSg/
	vqg0J7X4EGMy0KMTmaVEk/OBKSWvJN7Q2MTMyNLIzMLIxNycNGElcV7GU08ChATSE0tSs1NT
	C1KLYLYwcXBKNTDK57kv/FMTtr/I3fxcaPmBGo5Tk32cP11zX67wiIerVduRnXEmV0Snz545
	7j1HNYUrrE3cFtVOc52oV1c1k3ltR9vzBVvLF/1t38dTdO/wv7wr+4MVvna37zTp7dp3xfNf
	7zO79AYVKVurSiaLO0IX3fzmvgzcYbct6Xoyx8tzOZPTntTbaymxFGckGmoxFxUnAgBUG1NN
	HwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_gpio_request_one() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
No changes since v1:

 drivers/mfd/omap-usb-host.c |   23 ++---------------------
 1 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 6b5edf6..2104d66 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -437,11 +437,11 @@ static void omap_usbhs_init(struct device *dev)
 
 	if (pdata->phy_reset) {
 		if (gpio_is_valid(pdata->reset_gpio_port[0]))
-			gpio_request_one(pdata->reset_gpio_port[0],
+			devm_gpio_request_one(dev, pdata->reset_gpio_port[0],
 					 GPIOF_OUT_INIT_LOW, "USB1 PHY reset");
 
 		if (gpio_is_valid(pdata->reset_gpio_port[1]))
-			gpio_request_one(pdata->reset_gpio_port[1],
+			devm_gpio_request_one(dev, pdata->reset_gpio_port[1],
 					 GPIOF_OUT_INIT_LOW, "USB2 PHY reset");
 
 		/* Hold the PHY in RESET for enough time till DIR is high */
@@ -492,21 +492,6 @@ static void omap_usbhs_init(struct device *dev)
 	}
 }
 
-static void omap_usbhs_deinit(struct device *dev)
-{
-	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
-	struct usbhs_omap_platform_data	*pdata = omap->pdata;
-
-	if (pdata->phy_reset) {
-		if (gpio_is_valid(pdata->reset_gpio_port[0]))
-			gpio_free(pdata->reset_gpio_port[0]);
-
-		if (gpio_is_valid(pdata->reset_gpio_port[1]))
-			gpio_free(pdata->reset_gpio_port[1]);
-	}
-}
-
-
 /**
  * usbhs_omap_probe - initialize TI-based HCDs
  *
@@ -709,8 +694,6 @@ static int usbhs_omap_probe(struct platform_device *pdev)
 	return 0;
 
 err_alloc:
-	omap_usbhs_deinit(&pdev->dev);
-
 	for (i = 0; i < omap->nports; i++) {
 		if (!IS_ERR(omap->utmi_clk[i]))
 			clk_put(omap->utmi_clk[i]);
@@ -755,8 +738,6 @@ static int usbhs_omap_remove(struct platform_device *pdev)
 	struct usbhs_hcd_omap *omap = platform_get_drvdata(pdev);
 	int i;
 
-	omap_usbhs_deinit(&pdev->dev);
-
 	for (i = 0; i < omap->nports; i++) {
 		if (!IS_ERR(omap->utmi_clk[i]))
 			clk_put(omap->utmi_clk[i]);
-- 
1.7.2.5


