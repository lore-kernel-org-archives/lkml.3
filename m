Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab3AYLPL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:15:11 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:18936 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395Ab3AYLPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:15:01 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-d5-510269333118
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com
Subject: [PATCH 1/2] usb: dwc3: exynos/omap: Change platform device IDs for
 no_op_xceive to AUTO
Date: Fri, 25 Jan 2013 16:52:01 +0530
Message-id: <1359112922-2247-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1359112922-2247-1-git-send-email-gautam.vivek@samsung.com>
References: <1359112922-2247-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsWyRsSkWtc4kynQYEaPmcXlXXPYLGYv6Wex
	WLSsldmB2ePzJrkAxigum5TUnMyy1CJ9uwSujFtT1rEWbOWv6L54jqWB8SNPFyMnh4SAicS8
	3g2MELaYxIV769m6GLk4hASWMko0Nn1jgSk6tWw+I0RiEaPE7tsroKomM0m0/ZnIDFLFJqAr
	0fR2F9goEQFZicNXfgPFOTiYBTIkZlxgBQkLCyRJnLwIsoGTg0VAVeJU4ycmEJtXwF3ix6ul
	bBDLFCTe3H4G1sop4CGx9H8gSFgIqOT2gU2sECWP2STOHZWFGCMg8W3yIRaQcgmgrZsOMEOU
	SEocXHGDZQKj8AJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYgSF5+t8z6R2MqxosDjEK
	cDAq8fA+SGYMFGJNLCuuzD3EKMHBrCTCK2PCFCjEm5JYWZValB9fVJqTWnyIMRlo+URmKdHk
	fGC85JXEGxqbmJsam1oaGZmZmpImrCTOy3jqSYCQQHpiSWp2ampBahHMFiYOTqkGRkWNwGuz
	RSSmXF1/9PvZz1yLAndx/Hqs7nDu42VfZrdJLIEBs3gm2+qwBPBc1Xq/+W3Mq6K1Wx6JP3/F
	rqzR1jjDUdNG2NVx97yY9iu6W5xUPhau+e15SXHNb4V5d6tnbMxcqaI3d4bSCh6OmFLlNpau
	G/4ztK+Im/mYGNyWbH/90HyRkfimp0osxRmJhlrMRcWJAHD1LOWNAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t9jAV3jTKZAg3sTNCwu75rDZjF7ST+L
	xaJlrcwOzB6fN8kFMEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam
	2iq5+AToumXmAM1XUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGbcmrKO
	tWArf0X3xXMsDYwfeboYOTkkBEwkTi2bzwhhi0lcuLeerYuRi0NIYBGjxO7bK6CcyUwSbX8m
	MoNUsQnoSjS93QXWISIgK3H4ym+gOAcHs0CGxIwLrCBhYYEkiZMXQQZxcrAIqEqcavzEBGLz
	CrhL/Hi1lA1imYLEm9vPwFo5BTwklv4PBAkLAZXcPrCJdQIj7wJGhlWMoqkFyQXFSem5RnrF
	ibnFpXnpesn5uZsYwSH/THoH46oGi0OMAhyMSjy8D5IZA4VYE8uKK3MPMUpwMCuJ8MqYMAUK
	8aYkVlalFuXHF5XmpBYfYkwGOmois5Rocj4wHvNK4g2NTcxNjU0tTSxMzCxJE1YS52U89SRA
	SCA9sSQ1OzW1ILUIZgsTB6dUA2Paav+wZR4nuVds2Lio68zXaF79ys1RnOIyDa9XPz/X5drd
	s+7CCs+tzy9NYD3Vpfftp8/E9lbNXLbN5xb5HFFrYihaGKA4L3KDdHyyrcB7zuQ31o7B3C7B
	+iUlm/+GzOjoiwrLu910QGNL6I/PBjHzstc4WNwTvXFMeYPziYIJ+3kZO/Q5/yixFGckGmox
	FxUnAgCLdBKzvQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multiple dwc3 probe calls try to allocate no_op_xceive platform
device. Having static IDs for these will throw sysfs error -EEXIST.
Changing these static platform device IDs to AUTO to enable
multiple dwc3 controller support on a SoC.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/dwc3/dwc3-exynos.c |    4 ++--
 drivers/usb/dwc3/dwc3-omap.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index 1e95551..b50da53 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -42,7 +42,7 @@ static int dwc3_exynos_register_phys(struct dwc3_exynos *exynos)
 
 	memset(&pdata, 0x00, sizeof(pdata));
 
-	pdev = platform_device_alloc("nop_usb_xceiv", 0);
+	pdev = platform_device_alloc("nop_usb_xceiv", PLATFORM_DEVID_AUTO);
 	if (!pdev)
 		return -ENOMEM;
 
@@ -53,7 +53,7 @@ static int dwc3_exynos_register_phys(struct dwc3_exynos *exynos)
 	if (ret)
 		goto err1;
 
-	pdev = platform_device_alloc("nop_usb_xceiv", 1);
+	pdev = platform_device_alloc("nop_usb_xceiv", PLATFORM_DEVID_AUTO);
 	if (!pdev) {
 		ret = -ENOMEM;
 		goto err1;
diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 831b75f..22f337f 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -203,7 +203,7 @@ static int dwc3_omap_register_phys(struct dwc3_omap *omap)
 
 	memset(&pdata, 0x00, sizeof(pdata));
 
-	pdev = platform_device_alloc("nop_usb_xceiv", 0);
+	pdev = platform_device_alloc("nop_usb_xceiv", PLATFORM_DEVID_AUTO);
 	if (!pdev)
 		return -ENOMEM;
 
@@ -214,7 +214,7 @@ static int dwc3_omap_register_phys(struct dwc3_omap *omap)
 	if (ret)
 		goto err1;
 
-	pdev = platform_device_alloc("nop_usb_xceiv", 1);
+	pdev = platform_device_alloc("nop_usb_xceiv", PLATFORM_DEVID_AUTO);
 	if (!pdev) {
 		ret = -ENOMEM;
 		goto err1;
-- 
1.7.6.5

