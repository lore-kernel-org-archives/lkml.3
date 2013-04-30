Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab3D3FAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 01:00:36 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:24975 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab3D3FAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 01:00:35 -0400
X-AuditID: cbfee68f-b7f066d000003683-8c-517f4ff2cb52
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Guenter Roeck'" <linux@roeck-us.net>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V2 2/7] watchdog: bcm63xx_wdt: use devm_ioremap_nocache()
Date: Tue, 30 Apr 2013 14:00:33 +0900
Message-id: <000f01ce455f$a55a20c0$f00e6240$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5FX6KCIrfd3qA/SKK7xTQL1enSWA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zY91P/vWBBg/buSzmrF/DZnF54SVW
	i8u75rBZ3Fi3j93iycIzTBa3ZrxgdWDzuLZZzOPEjN8sHju/N7B79G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8aDk7PZC/bwVUx5/JK1gbGPp4uRk0NCwERi46vjzBC2mMSFe+vZuhi5OIQE
	ljFKtH5ezgRT1Nx+ngUisYhR4uWS9awQzi9GibP/ZoO1swmoSXz5cpi9i5GDQ0RAX6KtRQOk
	hllgA6PEyf9/2UFqhAU8JeZ8b2EEsVkEVCXOnzoDtoFXwFJi8fKtjBC2oMSPyfdYQGxmAS2J
	9TuPM0HY8hKb17yFOlVBYsfZ12D1IgJ6El92vmOFqBGR2PfiHSPIYgmBS+wSZz89ZoFYJiDx
	bfIhFpDjJARkJTYdgJojKXFwxQ2WCYxis5CsnoVk9Swkq2chWbGAkWUVo2hqQXJBcVJ6kbFe
	cWJucWleul5yfu4mRkgU9u9gvHvA+hBjMtD6icxSosn5wCjOK4k3NDYzsjA1MTU2Mrc0I01Y
	SZxXrcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPj/IQw9yhuo8tXAhObki81pF79khJv
	4PqC5VtlieOy5c2fBI46b3Jq7Y9kKKhYLh76IqFv54feBfZcdr1HruybNlvvfNNBrs8nFEyn
	SDXOM2nU8E+7dbwn9+3CmmT+hqtbXunu3Top4b4Q/0Vn/1u6ggfuTq1M13706FnA0gsK8s7H
	y7ZOCnygxFKckWioxVxUnAgAtXLWEdgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jAd1P/vWBBgda2SzmrF/DZnF54SVW
	i8u75rBZ3Fi3j93iycIzTBa3ZrxgdWDzuLZZzOPEjN8sHju/N7B79G1ZxejxeZNcAGtUA6NN
	RmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAFSgpliTml
	QKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaMBydnsxfs4auY8vglawNjH08XIyeH
	hICJRHP7eRYIW0ziwr31bF2MXBxCAosYJV4uWc8K4fxilDj7bzYzSBWbgJrEly+H2bsYOThE
	BPQl2lo0QGqYBTYwSpz8/5cdpEZYwFNizvcWRhCbRUBV4vypM0wgNq+ApcTi5VsZIWxBiR+T
	74FtZhbQkli/8zgThC0vsXnNW2aIixQkdpx9DVYvIqAn8WXnO1aIGhGJfS/eMU5gFJiFZNQs
	JKNmIRk1C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBMf5MagfjygaLQ4wCHIxK
	PLw7ltQFCrEmlhVX5h5ilOBgVhLhjXasDxTiTUmsrEotyo8vKs1JLT7EmAz06URmKdHkfGD6
	ySuJNzQ2MTOyNDKzMDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGRuvJ7xec+Hrl
	tgzTRd6jJ84Ee97QuDBpzoVtxTffmPdqlmmE/dpneH3zJv3XdfyttgIHxVl3az763pF4prbx
	enWeS0hEwE2OucYyksfiVIOqu797LVWeG2grw3j18vvebxOy/gmdyMj4NJVzWfe8gFNvpKYL
	brurpnhtS+Md4Q1Bbg07Av/XnVZiKc5INNRiLipOBACC1ydSNQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap_nocache() to make cleanup paths simpler.

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
No changes since v1:

 drivers/watchdog/bcm63xx_wdt.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/watchdog/bcm63xx_wdt.c b/drivers/watchdog/bcm63xx_wdt.c
index b2b80d4..a14a58d 100644
--- a/drivers/watchdog/bcm63xx_wdt.c
+++ b/drivers/watchdog/bcm63xx_wdt.c
@@ -16,6 +16,7 @@
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/init.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
@@ -249,7 +250,8 @@ static int bcm63xx_wdt_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	bcm63xx_wdt_device.regs = ioremap_nocache(r->start, resource_size(r));
+	bcm63xx_wdt_device.regs = devm_ioremap_nocache(&pdev->dev, r->start,
+							resource_size(r));
 	if (!bcm63xx_wdt_device.regs) {
 		dev_err(&pdev->dev, "failed to remap I/O resources\n");
 		return -ENXIO;
@@ -258,7 +260,7 @@ static int bcm63xx_wdt_probe(struct platform_device *pdev)
 	ret = bcm63xx_timer_register(TIMER_WDT_ID, bcm63xx_wdt_isr, NULL);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to register wdt timer isr\n");
-		goto unmap;
+		return ret;
 	}
 
 	if (bcm63xx_wdt_settimeout(wdt_time)) {
@@ -281,8 +283,6 @@ static int bcm63xx_wdt_probe(struct platform_device *pdev)
 
 unregister_timer:
 	bcm63xx_timer_unregister(TIMER_WDT_ID);
-unmap:
-	iounmap(bcm63xx_wdt_device.regs);
 	return ret;
 }
 
@@ -293,7 +293,6 @@ static int bcm63xx_wdt_remove(struct platform_device *pdev)
 
 	misc_deregister(&bcm63xx_wdt_miscdev);
 	bcm63xx_timer_unregister(TIMER_WDT_ID);
-	iounmap(bcm63xx_wdt_device.regs);
 	return 0;
 }
 
-- 
1.7.2.5


