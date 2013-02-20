Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934556Ab3BTJa1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:30:27 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:20575 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933163Ab3BTJaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:30:22 -0500
X-AuditID: cbfee68d-b7f4f6d000004209-8c-512497adf386
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000f01ce0f4c$7c1d01d0$74570570$%han@samsung.com>
In-reply-to: <000f01ce0f4c$7c1d01d0$74570570$%han@samsung.com>
Subject: [PATCH V2 6/9] mfd: twl6040: use devm_*() functions
Date: Wed, 20 Feb 2013 18:30:21 +0900
Message-id: <001401ce0f4c$e77aa9f0$b66ffdd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PTHvvVazquf7TSyaZqgztkH4/LAAAFwOA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zQ92101UCDV78MLS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZsx9eYS54LVfx8+FlxgbGx5JdjJwcEgImEp9+nmWEsMUkLtxb
	z9bFyMUhJLCMUeLqvCtsMEXn17YxQiQWMUocvfKbGSQhJDCbSeLdKQ8Qm01ATeLLl8PsILaI
	gJZE97HzQM0cHMwCLhJHp4lAlNtKPOraCtbKKWAn0XJtHpgtLGAj8fzLMTCbRUBVYveFJUwg
	Ni9Q/cofx1khbEGJH5PvsYDYzEDj1+88zgRhy0tsXvOWGWSVhIC6xKO/uiCmiICRxOOjhhAV
	IhL7XrwDu15CYBG7xNKlW1ggVglIfJt8iAWiVVZi0wFmiG8lJQ6uuMEygVFiFpLFs5AsnoVk
	8SwkKxYwsqxiFE0tSC4oTkovMtQrTswtLs1L10vOz93ECImq3h2Mtw9YH2JMBlo/kVlKNDkf
	GJV5JfGGxsYmZiamJuaWpuampAkrifPKXZIJFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cC4
	LFfmSgPPXZ66lNjW/smVn68/eT9zio7VxLlR3+pe3y46mWIe4vNoyyzXWJt0D2Fn35XrM/Q8
	/5Xv9+234r7JsXOzzonZ60utHmzRUsyoPaDjk52921VGSna3yYvy6rfCi4ILY/lU8gSaeVTl
	hA/3i7x48apiWVfDkQViU73y+Sqmc/wzjVZiKc5INNRiLipOBADDUUUMwAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgO7a6SqBBpd+6lpc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjNkPrzAXvJar+PnwMmMD
	42PJLkZODgkBE4nza9sYIWwxiQv31rN1MXJxCAksYpQ4euU3M0hCSGA2k8S7Ux4gNpuAmsSX
	L4fZQWwRAS2J7mPngRo4OJgFXCSOThOBKLeVeNS1FayVU8BOouXaPDBbWMBG4vmXY2A2i4Cq
	xO4LS5hAbF6g+pU/jrNC2IISPybfYwGxmYHGr995nAnClpfYvOYtM8gqCQF1iUd/dUFMEQEj
	icdHDSEqRCT2vXjHOIFRaBaSQbOQDJqFZNAsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl
	5+duYgTH7DPpHYyrGiwOMQpwMCrx8DYsVA4UYk0sK67MPcQowcGsJML7s0MlUIg3JbGyKrUo
	P76oNCe1+BBjMtCfE5mlRJPzgekkryTe0NjEzMjSyMzCyMTcnDRhJXFexlNPAoQE0hNLUrNT
	UwtSi2C2MHFwSjUwMsas/tct9n6t3Da3BxtytIMKn6efalnc6sAUxD13UYfi/PptU4tkJJyX
	n9upc6zK9/Oj6uwb1dpy292dw/+v0foqNuHcM6Gs28f6plyzNlj7TG+RTrfBndccwT/i7Xhi
	s/atYXeUZVx3U3He4q9xLKwyBhuYL/RZMYdZ2JVaVB3yDa3jfL1JiaU4I9FQi7moOBEA5+oE
	RR0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- Use devm_free_irq()
- Use devm_regulator_bulk_get()

 drivers/mfd/twl6040.c |   31 +++++++++++--------------------
 1 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/drivers/mfd/twl6040.c b/drivers/mfd/twl6040.c
index f361bf3..492ee2c 100644
--- a/drivers/mfd/twl6040.c
+++ b/drivers/mfd/twl6040.c
@@ -554,7 +554,7 @@ static int twl6040_probe(struct i2c_client *client,
 
 	twl6040->supplies[0].supply = "vio";
 	twl6040->supplies[1].supply = "v2v1";
-	ret = regulator_bulk_get(&client->dev, TWL6040_NUM_SUPPLIES,
+	ret = devm_regulator_bulk_get(&client->dev, TWL6040_NUM_SUPPLIES,
 				 twl6040->supplies);
 	if (ret != 0) {
 		dev_err(&client->dev, "Failed to get supplies: %d\n", ret);
@@ -564,7 +564,7 @@ static int twl6040_probe(struct i2c_client *client,
 	ret = regulator_bulk_enable(TWL6040_NUM_SUPPLIES, twl6040->supplies);
 	if (ret != 0) {
 		dev_err(&client->dev, "Failed to enable supplies: %d\n", ret);
-		goto power_err;
+		goto regulator_get_err;
 	}
 
 	twl6040->dev = &client->dev;
@@ -586,8 +586,8 @@ static int twl6040_probe(struct i2c_client *client,
 		twl6040->audpwron = -EINVAL;
 
 	if (gpio_is_valid(twl6040->audpwron)) {
-		ret = gpio_request_one(twl6040->audpwron, GPIOF_OUT_INIT_LOW,
-				       "audpwron");
+		ret = devm_gpio_request_one(&client->dev, twl6040->audpwron,
+					GPIOF_OUT_INIT_LOW, "audpwron");
 		if (ret)
 			goto gpio_err;
 	}
@@ -596,14 +596,14 @@ static int twl6040_probe(struct i2c_client *client,
 			IRQF_ONESHOT, 0, &twl6040_irq_chip,
 			&twl6040->irq_data);
 	if (ret < 0)
-		goto irq_init_err;
+		goto gpio_err;
 
 	twl6040->irq_ready = regmap_irq_get_virq(twl6040->irq_data,
 					       TWL6040_IRQ_READY);
 	twl6040->irq_th = regmap_irq_get_virq(twl6040->irq_data,
 					       TWL6040_IRQ_TH);
 
-	ret = request_threaded_irq(twl6040->irq_ready, NULL,
+	ret = devm_request_threaded_irq(twl6040->dev, twl6040->irq_ready, NULL,
 				   twl6040_readyint_handler, IRQF_ONESHOT,
 				   "twl6040_irq_ready", twl6040);
 	if (ret) {
@@ -611,7 +611,7 @@ static int twl6040_probe(struct i2c_client *client,
 		goto readyirq_err;
 	}
 
-	ret = request_threaded_irq(twl6040->irq_th, NULL,
+	ret = devm_request_threaded_irq(twl6040->dev, twl6040->irq_th, NULL,
 				   twl6040_thint_handler, IRQF_ONESHOT,
 				   "twl6040_irq_th", twl6040);
 	if (ret) {
@@ -681,18 +681,13 @@ static int twl6040_probe(struct i2c_client *client,
 	return 0;
 
 mfd_err:
-	free_irq(twl6040->irq_th, twl6040);
+	devm_free_irq(&client->dev, twl6040->irq_th, twl6040);
 thirq_err:
-	free_irq(twl6040->irq_ready, twl6040);
+	devm_free_irq(&client->dev, twl6040->irq_ready, twl6040);
 readyirq_err:
 	regmap_del_irq_chip(twl6040->irq, twl6040->irq_data);
-irq_init_err:
-	if (gpio_is_valid(twl6040->audpwron))
-		gpio_free(twl6040->audpwron);
 gpio_err:
 	regulator_bulk_disable(TWL6040_NUM_SUPPLIES, twl6040->supplies);
-power_err:
-	regulator_bulk_free(TWL6040_NUM_SUPPLIES, twl6040->supplies);
 regulator_get_err:
 	i2c_set_clientdata(client, NULL);
 err:
@@ -706,18 +701,14 @@ static int twl6040_remove(struct i2c_client *client)
 	if (twl6040->power_count)
 		twl6040_power(twl6040, 0);
 
-	if (gpio_is_valid(twl6040->audpwron))
-		gpio_free(twl6040->audpwron);
-
-	free_irq(twl6040->irq_ready, twl6040);
-	free_irq(twl6040->irq_th, twl6040);
+	devm_free_irq(&client->dev, twl6040->irq_ready, twl6040);
+	devm_free_irq(&client->dev, twl6040->irq_th, twl6040);
 	regmap_del_irq_chip(twl6040->irq, twl6040->irq_data);
 
 	mfd_remove_devices(&client->dev);
 	i2c_set_clientdata(client, NULL);
 
 	regulator_bulk_disable(TWL6040_NUM_SUPPLIES, twl6040->supplies);
-	regulator_bulk_free(TWL6040_NUM_SUPPLIES, twl6040->supplies);
 
 	return 0;
 }
-- 
1.7.2.5


