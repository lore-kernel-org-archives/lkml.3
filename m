Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553AbaDPKbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:31:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12483 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbaDPK1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:27:05 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-f5-534e5af70720
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>
Subject: [PATCH 2/8] extcon: adc-jack: Use devm_extcon_dev_register()
Date: Wed, 16 Apr 2014 19:26:57 +0900
Message-id: <1397644023-32516-3-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397644023-32516-1-git-send-email-sangjung.woo@samsung.com>
References: <1397644023-32516-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsWyRsSkUPd7lF+wwYYtwhbXvzxntbi8aw6b
	xe3GFWwWC/aUOLB49G1ZxejxeZNcAFMUl01Kak5mWWqRvl0CV8anfQdZCt6KVzyftpO1gXG7
	cBcjJ4eEgInE7WtH2CFsMYkL99azdTFycQgJLGWUWDf1DTtM0eXuX1CJRYwSd3r3QjltTBJL
	N3UxgVSxCehKPDlwmRnEFhEIlug4eRwszizgKTF3chcbiC0s4Cqxf8F+MJtFQFXi7LJesHpe
	AQ+JDVvvsHYxcgBtU5CYM8kGJMwJ1Lr51TdmkLAQUMm9r2YgayUEXrNJnD95mx1ijIDEt8mH
	WCBaZSU2HWCGuFlS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAgM09P/
	nvXuYLx9wPoQYzLQuInMUqLJ+cAwzyuJNzQ2M7IwNTE1NjK3NCNNWEmcN+lhUpCQQHpiSWp2
	ampBalF8UWlOavEhRiYOTqkGxqWJTn7nqvQ3TtqwSHSfxuoXGquqP92aeOPdgrVuv8V3pN5k
	+2KlNmUhy5pSK1W3NnGXQ9YyTHlPamycsiaklhn8eSXxPPf+Jk+WnruGLEl9HDG8S4vC/yp/
	COnbu7ipyXTDmukJggv769Uds/fNWBUzfTL7paq8c++vSgV6bdLd36F/oddylhJLcUaioRZz
	UXEiADXrqrNpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t9jAd3vUX7BBlNncFtc//Kc1eLyrjls
	FrcbV7BZLNhT4sDi0bdlFaPH501yAUxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6
	hpYW5koKeYm5qbZKLj4Bum6ZOUCLlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZ
	oIGENYwZn/YdZCl4K17xfNpO1gbG7cJdjJwcEgImEpe7f7FB2GISF+6tB7K5OIQEFjFK3Ond
	C+W0MUks3dTFBFLFJqAr8eTAZWYQW0QgWKLj5HGwOLOAp8TcyV1gk4QFXCX2L9gPZrMIqEqc
	XdYLVs8r4CGxYesd1i5GDqBtChJzJtmAhDmBWje/+sYMEhYCKrn31WwCI+8CRoZVjKKpBckF
	xUnpuUZ6xYm5xaV56XrJ+bmbGMFR8Ex6B+OqBotDjAIcjEo8vDNzfIOFWBPLiitzDzFKcDAr
	ifA2RvoFC/GmJFZWpRblxxeV5qQWH2JMBrppIrOUaHI+MELzSuINjU3MjCyNzA0tjIzNSRNW
	Euc92GodKCSQnliSmp2aWpBaBLOFiYNTqoGx4ydjm8teM6OvmZOuZun9U/HTTam+JOx6u+Sx
	Rp/RyYjXJx69XrRWUulZq2f4Hv7WwuB2ZdYDfyefMqhzWDZ1xvZ1EWWLGFZ9X7XBSnPZqUMt
	6Wc5dUyn2SilqbNzaOluMkuwMrNYNLWjWG2bcfemQp7Aw7N7Drn9uWsvdzSyT27DrLwcN2Ml
	luKMREMt5qLiRAA8oT8LxgIAAA==
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

