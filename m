Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbaDUKNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 06:13:16 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11066 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaDUKKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 06:10:19 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-d4-5354ee89f452
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv4 2/8] extcon: adc-jack: Use devm_extcon_dev_register()
Date: Mon, 21 Apr 2014 19:10:09 +0900
Message-id: <1398075015-19211-3-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398075015-19211-1-git-send-email-sangjung.woo@samsung.com>
References: <1398075015-19211-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsWyRsSkULfzXUiwQesuPovrX56zWrx+YWhx
	edccNovbjSvYLBbsKbGYMfklmwObR9+WVYwenzfJBTBFcdmkpOZklqUW6dslcGV82neQpeCt
	eMXzaTtZGxi3C3cxcnJICJhIXJn5khXCFpO4cG89G4gtJLCUUeL0ZekuRg6wmrcT/bsYuYDC
	ixgl9ndOYodw2pgkplxtZwRpYBPQlXhy4DIziC0iECzRcfI4E0gRs8ASRol/J2+xgUwSFnCX
	eP4qGKSGRUBV4sOePrB6XgEPiZafzxghlilIzJlkAxLmFPCUWDR1ISPEPR4Spz/NZwYZKSHw
	n01iSfN0Zog5AhLfJh9igeiVldh0gBniF0mJgytusExgFF7AyLCKUTS1ILmgOCm9yFSvODG3
	uDQvXS85P3cTIzBsT/97NnEH4/0D1ocYk4HGTWSWEk3OB4Z9Xkm8obGZkYWpiamxkbmlGWnC
	SuK86Y+SgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwTtE9JTjZkjVMPXT5g4Wfv+q1CIeZ
	Ki7UL+zSn+rUmr2/5btu9l3GC0/LV7dd5n6953Lyi3B3Q072q0vZGee1aKXkaAf7RRrkckUv
	cPhz5rNQ1hqzymfrypv4zh3IWldz5nZFRODcaumFzDNYRefJbN+lx5LitGvb4VuyC5ZZmQQ/
	PBL7ME1NiaU4I9FQi7moOBEA3a0WZ3ECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jAd3OdyHBBhums1pc//Kc1eL1C0OL
	y7vmsFncblzBZrFgT4nFjMkv2RzYPPq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYx49O+gywFb8Urnk/bydrAuF24i5GDQ0LAROLtRP8uRk4gU0ziwr31
	bF2MXBxCAosYJfZ3TmKHcNqYJKZcbWcEqWIT0JV4cuAyM4gtIhAs0XHyOBNIEbPAEkaJfydv
	sYFMFRZwl3j+KhikhkVAVeLDnj6wel4BD4mWn88YIRYrSMyZZAMS5hTwlFg0dSHYeCGgktOf
	5jNPYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Lp5J72Bc1WBxiFGAg1GJh/dF
	fkiwEGtiWXFl7iFGCQ5mJRHeiPVAId6UxMqq1KL8+KLSnNTiQ4zJQEdNZJYSTc4HxmxeSbyh
	sYmZkaWRuaGFkbE5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTBaHTm0+t/s1afapt3J
	z09dwDBfrkZzSXTor/dCwXdP9e1/Xfva54q0YIQSd+aPo7ZMT6tazt/tvL0xR2/7TIvGXyGb
	rJSt+V4EvZ9z6Mv6vGS5uuaV376JNko+ufToHNfCLfdb5PyP5O0KNK70VbKYIDn7Rd2KW6/V
	Zj/12fTasNW5SNv9SeoZJZbijERDLeai4kQAZkguxc8CAAA=
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
 drivers/extcon/extcon-adc-jack.c |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
index e23f1c2..549d820 100644
--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -105,9 +105,8 @@ static int adc_jack_probe(struct platform_device *pdev)
 	data->edev.name = pdata->name;
 
 	if (!pdata->cable_names) {
-		err = -EINVAL;
 		dev_err(&pdev->dev, "error: cable_names not defined.\n");
-		goto out;
+		return -EINVAL;
 	}
 
 	data->edev.dev.parent = &pdev->dev;
@@ -117,18 +116,16 @@ static int adc_jack_probe(struct platform_device *pdev)
 	for (i = 0; data->edev.supported_cable[i]; i++)
 		;
 	if (i == 0 || i > SUPPORTED_CABLE_MAX) {
-		err = -EINVAL;
 		dev_err(&pdev->dev, "error: pdata->cable_names size = %d\n",
 				i - 1);
-		goto out;
+		return -EINVAL;
 	}
 	data->num_cables = i;
 
 	if (!pdata->adc_conditions ||
 			!pdata->adc_conditions[0].state) {
-		err = -EINVAL;
 		dev_err(&pdev->dev, "error: adc_conditions not defined.\n");
-		goto out;
+		return -EINVAL;
 	}
 	data->adc_conditions = pdata->adc_conditions;
 
@@ -138,10 +135,8 @@ static int adc_jack_probe(struct platform_device *pdev)
 	data->num_conditions = i;
 
 	data->chan = iio_channel_get(&pdev->dev, pdata->consumer_channel);
-	if (IS_ERR(data->chan)) {
-		err = PTR_ERR(data->chan);
-		goto out;
-	}
+	if (IS_ERR(data->chan))
+		return PTR_ERR(data->chan);
 
 	data->handling_delay = msecs_to_jiffies(pdata->handling_delay_ms);
 
@@ -149,15 +144,14 @@ static int adc_jack_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, data);
 
-	err = extcon_dev_register(&data->edev);
+	err = devm_extcon_dev_register(&pdev->dev, &data->edev);
 	if (err)
-		goto out;
+		return err;
 
 	data->irq = platform_get_irq(pdev, 0);
 	if (!data->irq) {
 		dev_err(&pdev->dev, "platform_get_irq failed\n");
-		err = -ENODEV;
-		goto err_irq;
+		return -ENODEV;
 	}
 
 	err = request_any_context_irq(data->irq, adc_jack_irq_thread,
@@ -165,15 +159,10 @@ static int adc_jack_probe(struct platform_device *pdev)
 
 	if (err < 0) {
 		dev_err(&pdev->dev, "error: irq %d\n", data->irq);
-		goto err_irq;
+		return err;
 	}
 
 	return 0;
-
-err_irq:
-	extcon_dev_unregister(&data->edev);
-out:
-	return err;
 }
 
 static int adc_jack_remove(struct platform_device *pdev)
@@ -182,7 +171,6 @@ static int adc_jack_remove(struct platform_device *pdev)
 
 	free_irq(data->irq, data);
 	cancel_work_sync(&data->handler.work);
-	extcon_dev_unregister(&data->edev);
 
 	return 0;
 }
-- 
1.7.9.5

