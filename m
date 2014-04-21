Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaDUKKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 06:10:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28482 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbaDUKKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 06:10:21 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-2c-5354ee893be3
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv4 7/8] extcon: palmas: Use devm_extcon_dev_register()
Date: Mon, 21 Apr 2014 19:10:14 +0900
Message-id: <1398075015-19211-8-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398075015-19211-1-git-send-email-sangjung.woo@samsung.com>
References: <1398075015-19211-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWyRsSkRLfzXUiwwdxpyhbXvzxntXj9wtDi
	8q45bBa3G1ewWSzYU2IxY/JLNgc2j74tqxg9Pm+SC2CK4rJJSc3JLEst0rdL4MroXXOQsWCv
	QMWWaRwNjDd5uxg5OSQETCSWTZ7KDGGLSVy4t54NxBYSWMoo8XyjCEzNgzcf2LsYuYDiixgl
	1t08ywzhtDFJXFt/EqyDTUBX4smBy2CTRASCJTpOHmcCKWIWWMIo8e/kLbAiYQFXiWV3T7OA
	2CwCqhKfOhrA4rwCHhJnLt5k7GLkAFqnIDFnkg1ImFPAU2LR1IWMEBd5SJz+NB9ssYTAfzaJ
	BXfmMELMEZD4NvkQC0SvrMSmA1DfSEocXHGDZQKj8AJGhlWMoqkFyQXFSelFRnrFibnFpXnp
	esn5uZsYgYF7+t+zvh2MNw9YH2JMBho3kVlKNDkfGPh5JfGGxmZGFqYmpsZG5pZmpAkrifMu
	epgUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoGxdHvWgymV69f5vQlVV2z/KdfNuebDMo/z
	R4/zLpq1bOLTiZy5WveebZO6GLr/+ttTWju+L9jWWTAxPMRt9tauCrafBu2zIm8bu6llyB6y
	ijHfK7PGfqbmv7MzHjjsOvWbibcx71T9nwfXHj1bvH1R7GkLv+wSNcHLGV2p7l9E4vi+m1zY
	8DjHXImlOCPRUIu5qDgRAAie7OVyAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t9jAd3OdyHBBkt7pC2uf3nOavH6haHF
	5V1z2CxuN65gs1iwp8RixuSXbA5sHn1bVjF6fN4kF8AU1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvh2lCaIibrgVM
	Y4Sub0gQXI+RARpIWMOY0bvmIGPBXoGKLdM4Ghhv8nYxcnJICJhIPHjzgR3CFpO4cG89Wxcj
	F4eQwCJGiXU3zzJDOG1MEtfWn2QDqWIT0JV4cuAyM4gtIhAs0XHyOBNIEbPAEkaJfydvgRUJ
	C7hKLLt7mgXEZhFQlfjU0QAW5xXwkDhz8SZjFyMH0DoFiTmTbEDCnAKeEoumLmQEsYWASk5/
	ms88gZF3ASPDKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgyHgmvYNxVYPFIUYBDkYlHt4X
	+SHBQqyJZcWVuYcYJTiYlUR4I9YDhXhTEiurUovy44tKc1KLDzEmAx01kVlKNDkfGLV5JfGG
	xiZmRpZG5oYWRsbmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cCovu2a8rGeuATDQ0HJ
	zy9xnGZ9wa23janv+tlLpwJXlGQJPJvGzbXo1l/HCqYQfpF8nbI1zdJyATptSX0lczJkfu9i
	LVj3JSW6sbreK7mRy2K/dVmodDfLLssDh8OzUybEL3T92aGsmcXYVfpzeWG14pa70w8+UTko
	vHVHztQWl/2qZadVryixFGckGmoxFxUnAgDmxTFz0AIAAA==
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

