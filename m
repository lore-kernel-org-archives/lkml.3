Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaDRAcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:32:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:30892 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaDRAco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:32:44 -0400
X-AuditID: cbfee68e-b7f566d000002344-43-535072a57211
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv3 7/8] extcon: palmas: Use devm_extcon_dev_register()
Date: Fri, 18 Apr 2014 09:32:39 +0900
Message-id: <1397781160-744-8-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397781160-744-1-git-send-email-sangjung.woo@samsung.com>
References: <1397781160-744-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWyRsSkSHdZUUCwwf9pLBbXvzxntXj9wtDi
	8q45bBa3G1ewWSzYU2IxY/JLNgc2j74tqxg9Pm+SC2CK4rJJSc3JLEst0rdL4MroXXOQsWCv
	QMWWaRwNjDd5uxg5OSQETCTeLHrOCGGLSVy4t56ti5GLQ0hgKaPEynXzmGCKuu50sEAkFjFK
	tC6ezAzhtDFJ7H92mhmkik1AV+LJgctgtohAsETHyeNMIEXMAksYJf6dvMUGkhAWcJXYO+kp
	2FgWAVWJz2cmA8U5OHgF3CQ+XlQEMSUEFCTmTLIBqeAUcJeYtWsnWLUQUMXzLVMZQUZKCPxm
	k9j/7yEbxBgBiW+TD7FA9MpKbDrADHG0pMTBFTdYJjAKL2BkWMUomlqQXFCclF5kpFecmFtc
	mpeul5yfu4kRGLin/z3r28F484D1IcZkoHETmaVEk/OBgZ9XEm9obGZkYWpiamxkbmlGmrCS
	OO+ih0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhj573q47FnxP/ZEJe/1nz3eOzjlmDbv
	/5Jt7lY/8+UT1fizdc3vlLkSKtbqRZm3LL4u4bDCLWzi9p3952bz5bNlLtvJEJaftvZPWuqM
	yrblJZf/v2jQntJvrFkccX5ZhOp5bY0TidEnKy+E/l7QlKeiKyH/mitAPtetM+BL26VXniv/
	NkupLlZiKc5INNRiLipOBAApRKEEcgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jAd2lRQHBBteOWFpc//Kc1eL1C0OL
	y7vmsFncblzBZrFgT4nFjMkv2RzYPPq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYxo3fNQcaCvQIVW6ZxNDDe5O1i5OSQEDCR6LrTwQJhi0lcuLeerYuR
	i0NIYBGjROviycwQThuTxP5np5lBqtgEdCWeHLgMZosIBEt0nDzOBFLELLCEUeLfyVtsIAlh
	AVeJvZOeMoHYLAKqEp/PTAaKc3DwCrhJfLyoCGJKCChIzJlkA1LBKeAuMWvXTrBqIaCK51um
	Mk5g5F3AyLCKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzgunkntYFzZYHGIUYCDUYmHV0Av
	IFiINbGsuDL3EKMEB7OSCO/5NKAQb0piZVVqUX58UWlOavEhxmSgmyYyS4km5wNjNq8k3tDY
	xMzI0sjc0MLI2Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGFc+m5d4iE9GdLv+8raz
	mxTXOkk4GUYf/7LozafdtS8LWDQOfY397b0uN267UbzIz+pp/zX/9GUfXCYmHMv/hL16j0pr
	Q6txuXH01QWGEVPNrc0dfx+/wH3nf9cEfY+SB0LcOTM0a6R6hfZmLNa6tPkf/+LAXNk3yQkr
	S/TymYQyj8vv+fP0nxJLcUaioRZzUXEiAIfuQejPAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the resource-managed extcon device register function (i.e.
devm_extcon_dev_register()) instead of extcon_dev_register(). If extcon device
is attached with this function, that extcon device is automatically unregistered
on driver detach. That reduces tiresome managing code.

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
---
 drivers/extcon/extcon-palmas.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index 51db5bc..1a770e0 100644
--- a/drivers/extcon/extcon-palmas.c
+++ b/drivers/extcon/extcon-palmas.c
@@ -192,7 +192,7 @@ static int palmas_usb_probe(struct platform_device *pdev)
 	palmas_usb->edev.name = kstrdup(node->name, GFP_KERNEL);
 	palmas_usb->edev.mutually_exclusive = mutually_exclusive;
 
-	status = extcon_dev_register(&palmas_usb->edev);
+	status = devm_extcon_dev_register(&pdev->dev, &palmas_usb->edev);
 	if (status) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
 		kfree(palmas_usb->edev.name);
@@ -209,7 +209,8 @@ static int palmas_usb_probe(struct platform_device *pdev)
 		if (status < 0) {
 			dev_err(&pdev->dev, "can't get IRQ %d, err %d\n",
 					palmas_usb->id_irq, status);
-			goto fail_extcon;
+			kfree(palmas_usb->edev.name);
+			return status;
 		}
 	}
 
@@ -223,26 +224,20 @@ static int palmas_usb_probe(struct platform_device *pdev)
 		if (status < 0) {
 			dev_err(&pdev->dev, "can't get IRQ %d, err %d\n",
 					palmas_usb->vbus_irq, status);
-			goto fail_extcon;
+			kfree(palmas_usb->edev.name);
+			return status;
 		}
 	}
 
 	palmas_enable_irq(palmas_usb);
 	device_set_wakeup_capable(&pdev->dev, true);
 	return 0;
-
-fail_extcon:
-	extcon_dev_unregister(&palmas_usb->edev);
-	kfree(palmas_usb->edev.name);
-
-	return status;
 }
 
 static int palmas_usb_remove(struct platform_device *pdev)
 {
 	struct palmas_usb *palmas_usb = platform_get_drvdata(pdev);
 
-	extcon_dev_unregister(&palmas_usb->edev);
 	kfree(palmas_usb->edev.name);
 
 	return 0;
-- 
1.7.9.5

