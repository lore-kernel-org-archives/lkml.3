Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbaDPK1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:27:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10660 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354AbaDPK1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:27:10 -0400
X-AuditID: cbfee68f-b7f156d00000276c-4c-534e5afda774
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>
Subject: [PATCH 7/8] extcon: palmas: Use devm_extcon_dev_register()
Date: Wed, 16 Apr 2014 19:27:02 +0900
Message-id: <1397644023-32516-8-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397644023-32516-1-git-send-email-sangjung.woo@samsung.com>
References: <1397644023-32516-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsWyRsSkRPdvlF+wwYzDphbXvzxntbi8aw6b
	xe3GFWwWC/aUOLB49G1ZxejxeZNcAFMUl01Kak5mWWqRvl0CV0bvmoOMBXsFKrZM42hgvMnb
	xcjJISFgItHavpAFwhaTuHBvPVsXIxeHkMBSRomvu58wwRTd3fcHrEhIYBGjxJOtRRBFbUwS
	mzoXsYMk2AR0JZ4cuMwMYosIBEt0nDwO1sws4Ckxd3IXG4gtLOAsse/pcbBBLAKqEsfWnQKr
	5xXwkFh4+j9QPQfQMgWJOZNsQMKcQK2bX31jBgkLAZXc+2oGslZC4DWbRN+nFawQYwQkvk0+
	xALRKiux6QAzxMmSEgdX3GCZwCi8gJFhFaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZgiJ7+
	96x/B+PdA9aHGJOBxk1klhJNzgeGeF5JvKGxmZGFqYmpsZG5pRlpwkrivPcfJgUJCaQnlqRm
	p6YWpBbFF5XmpBYfYmTi4JRqYNTgFL55dMK1V0f+zVNTSJkwRfmA8ppvgraZYWta9kVJ8h/L
	bZqrPjmyf0rZnfvLRJVerXy9pShSI03iV5XYpP990bVFq11Ufi582O6wM9y4JkjY2U2ruly2
	IHiygsgOnxqByfPFTbfV5L51Tdy5uDPmBEve9E3PLC98Tz6Z+yXsXu0h97NT1imxFGckGmox
	FxUnAgBZ65IcZwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t9jAd2/UX7BBp9+6Vpc//Kc1eLyrjls
	FrcbV7BZLNhT4sDi0bdlFaPH501yAUxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6
	hpYW5koKeYm5qbZKLj4Bum6ZOUCLlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZ
	oIGENYwZvWsOMhbsFajYMo2jgfEmbxcjJ4eEgInE3X1/WCBsMYkL99azgdhCAosYJZ5sLepi
	5AKy25gkNnUuYgdJsAnoSjw5cJkZxBYRCJboOHmcCcRmFvCUmDu5C6xZWMBZYt/T42BDWQRU
	JY6tOwVWzyvgIbHw9H+geg6gZQoScybZgIQ5gVo3v/rGDBIWAiq599VsAiPvAkaGVYyiqQXJ
	BcVJ6bmGesWJucWleel6yfm5mxjBEfBMagfjygaLQ4wCHIxKPLwzcnyDhVgTy4orcw8xSnAw
	K4nwNkb6BQvxpiRWVqUW5ccXleakFh9iTAa6aSKzlGhyPjA680riDY1NzIwsjcwNLYyMzUkT
	VhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBccEuJau52Qab/VfM4N9/7sC3nk/v/52sLfbX
	zLzFlOCZ1bX3RcwzrxC2Ip6rM6Uj+sW4372aPrGo9seBxIbiFbtqpl7iON7bI7DL4vL9XI7y
	ykLln4Yi/37xxZZO4K/nu+lX8tOQuzNgtdeVv3VZL/3/9+0S6PsrVu7FUCRpN8XgY8OD98nt
	SizFGYmGWsxFxYkAAcnWrMQCAAA=
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

