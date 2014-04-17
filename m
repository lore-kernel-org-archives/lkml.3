Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161412AbaDQKKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 06:10:35 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28855 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161179AbaDQKKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 06:10:08 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-4c-534fa87a6d56
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv2 7/8] extcon: palmas: Use devm_extcon_dev_register()
Date: Thu, 17 Apr 2014 19:10:02 +0900
Message-id: <1397729403-32045-8-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397729403-32045-1-git-send-email-sangjung.woo@samsung.com>
References: <1397729403-32045-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWyRsSkULd6hX+wwadpjBbXvzxntXj9wtDi
	8q45bBa3G1ewWSzYU2IxY/JLNgc2j74tqxg9Pm+SC2CK4rJJSc3JLEst0rdL4MroXXOQsWCv
	QMWWaRwNjDd5uxg5OSQETCTO3HrKDmGLSVy4t56ti5GLQ0hgKaPEybPXmGCKjkx4CmYLCUxn
	lDh+UgaiqI1J4s/aacwgCTYBXYknBy6D2SICwRIdJ48zgRQxCyxhlPh38hYbSEJYwFXi2tR3
	jCA2i4CqxKy1t8BsXgEPictLGlm6GDmAtilIzJlkAxLmFPCU2LP1LCPEYg+JrctusILMlBD4
	zybx6m4/K8QcAYlvkw9B9cpKbDrADHG0pMTBFTdYJjAKL2BkWMUomlqQXFCclF5kqlecmFtc
	mpeul5yfu4kRGLin/z2buIPx/gHrQ4zJQOMmMkuJJucDAz+vJN7Q2MzIwtTE1NjI3NKMNGEl
	cd70R0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhi3eb14uudprrEya7jQQV6vjdvzOmy3
	8ou8tO5lnBqnPGPn14dlSf0vzcJjIxu43sa+vfvy/iPxa195NX7Jv3K89nnrPf9WoRkTjbR/
	2Xn+rivaf71gxdS7iRMNZmUJqB7pE1ad/y/xj1nHhb8TWVgU462qTiWsalHoNN6uKrO2NsUt
	pKf/BIMSS3FGoqEWc1FxIgBIUBNCcgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jQd2qFf7BBv+/m1lc//Kc1eL1C0OL
	y7vmsFncblzBZrFgT4nFjMkv2RzYPPq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYxo3fNQcaCvQIVW6ZxNDDe5O1i5OSQEDCRODLhKROELSZx4d56NhBb
	SGA6o8TxkzJdjFxAdhuTxJ+105hBEmwCuhJPDlwGs0UEgiU6Th5nAiliFljCKPHv5C2wbmEB
	V4lrU98xgtgsAqoSs9beArN5BTwkLi9pZOli5ADapiAxZ5INSJhTwFNiz9azjBCLPSS2LrvB
	OoGRdwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Lh4Jr2DcVWDxSFGAQ5GJR5ezt9+
	wUKsiWXFlbmHGCU4mJVEeCWAUSXEm5JYWZValB9fVJqTWnyIMRnoqInMUqLJ+cCYzSuJNzQ2
	MTOyNDI3tDAyNidNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGRm7TzT+XBrScYutWtXxY
	t3XXuvaN83I2SCxJLXwidnnd3tJczQU7JiwzO6KafMjv4aSlitoclVvupa55HpqtfWHSZhY/
	dr+XMf7dH4L99jDdONvXOmFzwi2mslVWBycKvnjUZdQRLXYlQ/XhlgXF8mxMvxef8Jg+4z7j
	7jf8PNtKnHtmR5q9y1diKc5INNRiLipOBABteFt3zwIAAA==
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

