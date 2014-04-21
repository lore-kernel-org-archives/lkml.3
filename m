Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaDUKNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 06:13:11 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:10471 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaDUKKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 06:10:19 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-d5-5354ee8958bc
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv4 3/8] extcon: gpio: Use devm_extcon_dev_register()
Date: Mon, 21 Apr 2014 19:10:10 +0900
Message-id: <1398075015-19211-4-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398075015-19211-1-git-send-email-sangjung.woo@samsung.com>
References: <1398075015-19211-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWyRsSkSLfzXUiwQVeDiMX1L89ZLV6/MLS4
	vGsOm8XtxhVsFgv2lFjMmPySzYHNo2/LKkaPz5vkApiiuGxSUnMyy1KL9O0SuDK2LZ3EWPCK
	r2J7Y1QD40KeLkZODgkBE4mOo3sZIWwxiQv31rN1MXJxCAksZZT4s/4NK0zR9z8bWSESixgl
	/p7YwQLhtDFJTLnaDtbOJqAr8eTAZWYQW0QgWKLj5HEmkCJmgSWMEv9O3mIDSQgLOEvMmXmY
	HcRmEVCVePz8OpDNwcEr4CGxcU80iCkhoCAxZ5INSAWngKfEoqkLwcYLAVWc/jSfGWSkhMB/
	NokJC7YyQYwRkPg2+RALRK+sxKYDzBBHS0ocXHGDZQKj8AJGhlWMoqkFyQXFSelFpnrFibnF
	pXnpesn5uZsYgYF7+t+ziTsY7x+wPsSYDDRuIrOUaHI+MPDzSuINjc2MLExNTI2NzC3NSBNW
	EudNf5QUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHRTETrzuOe5LV+2VJ7LeYX5lqXq9/p
	+FJ2evaVDLn3DNKHQzMq869lcQYVad/n9xY5950/49adsICKeZuenrqsmuf38o+29tMf01sc
	FjmKP2J9vpPx64O/Urpm2yQ1pP6/eSzQf7ZwjrhpxbKpa5ZYvzJYamMw2f8id6meytx5GmyS
	DAxS/O1KLMUZiYZazEXFiQCumQFBcgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jAd3OdyHBBl27eCyuf3nOavH6haHF
	5V1z2CxuN65gs1iwp8RixuSXbA5sHn1bVjF6fN4kF8AU1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvh2lCaIibrgVM
	Y4Sub0gQXI+RARpIWMOYsW3pJMaCV3wV2xuBDlrI08XIySEhYCLx/c9GVghbTOLCvfVsXYxc
	HEICixgl/p7YwQLhtDFJTLnazghSxSagK/HkwGVmEFtEIFii4+RxJpAiZoEljBL/Tt5iA0kI
	CzhLzJl5mB3EZhFQlXj8/DqQzcHBK+AhsXFPNIgpIaAgMWeSDUgFp4CnxKKpC8HGCwFVnP40
	n3kCI+8CRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFx8UxqB+PKBotDjAIcjEo8vDNK
	QoKFWBPLiitzDzFKcDArifBGrAcK8aYkVlalFuXHF5XmpBYfYkwGumkis5Rocj4wZvNK4g2N
	TcyMLI3MDS2MjM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgZGf1cpFaNmqDctV/Fes
	C/pR3x3ZMP/f5nrTiWqpjGsP7Tmxa+8815bjITu07C49eMputsT6n93GqCceWtMFfI0u2S1j
	qigNO+jm3XSg03/Cf+PV7PWCZvZz1GrfBi1Y9XJJxySmbKs/7MUnHKawSmVcCapP6Ej+Zv/p
	pNSC1n1H0wQM5BvfblNiKc5INNRiLipOBADadcVWzwIAAA==
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
 drivers/extcon/extcon-gpio.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 13d5222..43af34c 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -121,34 +121,27 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 				msecs_to_jiffies(pdata->debounce);
 	}
 
-	ret = extcon_dev_register(&extcon_data->edev);
+	ret = devm_extcon_dev_register(&pdev->dev, &extcon_data->edev);
 	if (ret < 0)
 		return ret;
 
 	INIT_DELAYED_WORK(&extcon_data->work, gpio_extcon_work);
 
 	extcon_data->irq = gpio_to_irq(extcon_data->gpio);
-	if (extcon_data->irq < 0) {
-		ret = extcon_data->irq;
-		goto err;
-	}
+	if (extcon_data->irq < 0)
+		return extcon_data->irq;
 
 	ret = request_any_context_irq(extcon_data->irq, gpio_irq_handler,
 				      pdata->irq_flags, pdev->name,
 				      extcon_data);
 	if (ret < 0)
-		goto err;
+		return ret;
 
 	platform_set_drvdata(pdev, extcon_data);
 	/* Perform initial detection */
 	gpio_extcon_work(&extcon_data->work.work);
 
 	return 0;
-
-err:
-	extcon_dev_unregister(&extcon_data->edev);
-
-	return ret;
 }
 
 static int gpio_extcon_remove(struct platform_device *pdev)
@@ -157,7 +150,6 @@ static int gpio_extcon_remove(struct platform_device *pdev)
 
 	cancel_delayed_work_sync(&extcon_data->work);
 	free_irq(extcon_data->irq, extcon_data);
-	extcon_dev_unregister(&extcon_data->edev);
 
 	return 0;
 }
-- 
1.7.9.5

