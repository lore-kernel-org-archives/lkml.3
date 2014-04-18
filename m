Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaDRAcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:32:43 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43991 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaDRAcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:32:39 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-f1-535072a5cbf9
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv3 2/8] extcon: adc-jack: Use devm_extcon_dev_register()
Date: Fri, 18 Apr 2014 09:32:34 +0900
Message-id: <1397781160-744-3-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397781160-744-1-git-send-email-sangjung.woo@samsung.com>
References: <1397781160-744-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWyRsSkUHdpUUCwwf8b2hbXvzxntXj9wtDi
	8q45bBa3G1ewWSzYU2IxY/JLNgc2j74tqxg9Pm+SC2CK4rJJSc3JLEst0rdL4Mr4tO8gS8Fb
	8Yrn03ayNjBuF+5i5OSQEDCRaJ/zkhXCFpO4cG89WxcjF4eQwFJGibNXLrLBFN0495gJIrGI
	UWL2g4vsEE4bk8T+Z6eZQarYBHQlnhy4DGaLCARLdJw8DtbBLLCEUeLfyVtgo4QF3CWa599l
	AbFZBFQlzty7BFTEwcEr4CZxZLcriCkhoCAxZ5INSAUnUPWsXTuZQGwhoIrnW6YygoyUEPjP
	JtHWcZERYoyAxLfJh1ggemUlNh1ghjhaUuLgihssExiFFzAyrGIUTS1ILihOSi8y1StOzC0u
	zUvXS87P3cQIDN3T/55N3MF4/4D1IcZkoHETmaVEk/OBoZ9XEm9obGZkYWpiamxkbmlGmrCS
	OG/6o6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYx9H4OPef7WqtKq0FLZ8X2lUFVRp82h
	CrurYlKnNNa4p3zwav37+vdW7t25Myrz+2+yp/5dck+QKzczUuXqr3h9rtwviZuXZfllL7aV
	k9Xui1q5MjH079tn+mc/cWq8e/b3zg7zaIMCnlT98wEKU/bG3tz60OZd61/nXOOHXB1lS5v5
	Zj3nuK3EUpyRaKjFXFScCAB8Vt4WcwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t9jAd2lRQHBBvOfKVtc//Kc1eL1C0OL
	y7vmsFncblzBZrFgT4nFjMkv2RzYPPq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYx49O+gywFb8Urnk/bydrAuF24i5GTQ0LAROLGucdMELaYxIV769m6
	GLk4hAQWMUrMfnCRHcJpY5LY/+w0M0gVm4CuxJMDl8FsEYFgiY6Tx5lAipgFljBK/Dt5iw0k
	ISzgLtE8/y4LiM0ioCpx5t4loCIODl4BN4kju11BTAkBBYk5k2xAKjiBqmft2gl2hBBQxfMt
	UxknMPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcGc+kdzCuarA4xCjAwajEw3vh
	q3+wEGtiWXFl7iFGCQ5mJRHe82kBwUK8KYmVValF+fFFpTmpxYcYk4FumsgsJZqcD4zavJJ4
	Q2MTMyNLI3NDCyNjc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgdGZ6EjWl6sip5LwZ
	Uis+Xmay2p9+57D/C4/EhulKk+5Z8PkHh50M5lGNDWBs3+ke5x7B063n2f9DQeaY9SGeyrB3
	iU94vwley+C5VevgfUbie1dCzstpSibTxTTu9yhGPC6QPTehoT6mTFmT62pK4sXuX4XT2VuY
	j6vM4rx3X8nGc26s2GElluKMREMt5qLiRAAA0vY80AIAAA==
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

