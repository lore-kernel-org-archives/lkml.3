Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbaDQKPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 06:15:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63751 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161254AbaDQKKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 06:10:14 -0400
X-AuditID: cbfee690-b7f266d00000287c-e4-534fa87aeff4
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv2 2/8] extcon: adc-jack: Use devm_extcon_dev_register()
Date: Thu, 17 Apr 2014 19:09:57 +0900
Message-id: <1397729403-32045-3-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397729403-32045-1-git-send-email-sangjung.woo@samsung.com>
References: <1397729403-32045-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWyRsSkRLdqhX+wwdPbGhbXvzxntXj9wtDi
	8q45bBa3G1ewWSzYU2IxY/JLNgc2j74tqxg9Pm+SC2CK4rJJSc3JLEst0rdL4Mr4tO8gS8Fb
	8Yrn03ayNjBuF+5i5OSQEDCR+N/9gRHCFpO4cG89WxcjF4eQwFJGiSVvl7LDFO1bfxoqMZ1R
	YuWZCSwQThuTxJ+105hBqtgEdCWeHLgMZosIBEt0nDzOBFLELLCEUeLfyVtsIAlhAXeJw9OO
	sILYLAKqEtsXbwBbwSvgIXHlyDsgmwNonYLEnEk2IGFOAU+JPVvPgp0nBFSyddkNVpCZEgK/
	2SQOvl/BCDFHQOLb5EMsEL2yEpsOMENcLSlxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXmegVJ+YW
	l+al6yXn525iBAbv6X/PJuxgvHfA+hBjMtC4icxSosn5wODPK4k3NDYzsjA1MTU2Mrc0I01Y
	SZxX7VFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGlTohLBsEm7cdSLe/W3bMqKd9VeyS
	itsCkx70TdbYZjrtVY/Vov3H91zuEt0tYGSj6mPecd4pPTLhiBH3y5uHb5e0r7cwWOxikWFw
	WX/hfqPj0xszpmxwLT5W1rbUyHju4YStD7xCWEu5f+mt477490WTcs+11VPZz2zjD4hSNvD9
	dXGW55UtSizFGYmGWsxFxYkAeIqFEHQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t9jQd2qFf7BBn8bFC2uf3nOavH6haHF
	5V1z2CxuN65gs1iwp8RixuSXbA5sHn1bVjF6fN4kF8AU1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvh2lCaIibrgVM
	Y4Sub0gQXI+RARpIWMOY8WnfQZaCt+IVz6ftZG1g3C7cxcjJISFgIrFv/Wk2CFtM4sK99UA2
	F4eQwHRGiZVnJrBAOG1MEn/WTmMGqWIT0JV4cuAymC0iECzRcfI4E0gRs8ASRol/J2+BjRIW
	cJc4PO0IK4jNIqAqsX3xBnYQm1fAQ+LKkXdANgfQOgWJOZNsQMKcAp4Se7aeZQSxhYBKti67
	wTqBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjODYeCa9g3FVg8UhRgEORiUeXs7f
	fsFCrIllxZW5hxglOJiVRHglgJElxJuSWFmVWpQfX1Sak1p8iDEZ6KiJzFKiyfnAuM0riTc0
	NjEzsjQyN7QwMjYnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBkbjbcwBe5tUy841ngmb
	ZTqzkSfst8q38PR6GSaHS/lCVo2FCjOZZohdecw6K1Lwwe8kJY9Afr+ceL0HmzynCE6o0ndc
	Vz3ho0n6YpkWcX935a4b8edDj0YrO7Ov7iuMmXT0usTHyzNmJp66wqE54XC657LqKI5TudJF
	hkZbLPQDWEXeKVyJU2Ipzkg01GIuKk4EAHSBW2zRAgAA
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

