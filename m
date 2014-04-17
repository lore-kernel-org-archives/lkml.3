Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbaDQKK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 06:10:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22904 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161105AbaDQKKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 06:10:03 -0400
X-AuditID: cbfee68e-b7f566d000002344-b5-534fa87a668b
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv3 3/8] extcon: gpio: Use devm_extcon_dev_register()
Date: Thu, 17 Apr 2014 19:09:58 +0900
Message-id: <1397729403-32045-4-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397729403-32045-1-git-send-email-sangjung.woo@samsung.com>
References: <1397729403-32045-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWyRsSkSLdqhX+wwftJBhbXvzxntXj9wtDi
	8q45bBa3G1ewWSzYU2IxY/JLNgc2j74tqxg9Pm+SC2CK4rJJSc3JLEst0rdL4MrYtnQSY8Er
	vortjVENjAt5uhg5OSQETCQWrtjKCGGLSVy4t56ti5GLQ0hgKaPE7o8TGGGKlq2ZygJiCwlM
	Z5SYs6QaoqiNSeLP2mnMIAk2AV2JJwcug9kiAsESHSePM4EUMQssYZT4d/IW0FgODmEBZ4n/
	KytBalgEVCW6PjSBLeAV8JB41/aHHaREQkBBYs4kG5Awp4CnxJ6tZxkh9npIbF12gxXint9s
	EpO2JUCMEZD4NvkQC0SrrMSmA8wQJZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kZFecWJucWle
	ul5yfu4mRmDQnv73rG8H480D1ocYk4HGTWSWEk3OBwZ9Xkm8obGZkYWpiamxkbmlGWnCSuK8
	ix4mBQkJpCeWpGanphakFsUXleakFh9iZOLglGpgnPmqe/vKDHOeD7Zl/Ot1t0rvVI4+XnJQ
	vuz7o+mMftU2h/7/8N6XF/zF5VDP2UmL8mcv2Wb3bs6+xjMKD//2Pph2+9FW5zMvKprY1p7Y
	EXlK+7X46+77lnxrj54+Ivk/1mvOs12eB5atY12TmNp8xsY+ULpyem5Jr4j7Y3lL2di2xpAJ
	G1Ti+5RYijMSDbWYi4oTAaU1cURwAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jQd2qFf7BBlOXalhc//Kc1eL1C0OL
	y7vmsFncblzBZrFgT4nFjMkv2RzYPPq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYxY9vSSYwFr/gqtjcCHbSQp4uRk0NCwERi2ZqpLBC2mMSFe+vZQGwh
	gemMEnOWVHcxcgHZbUwSf9ZOYwZJsAnoSjw5cBnMFhEIlug4eZwJpIhZYAmjxL+Tt4C6OTiE
	BZwl/q+sBKlhEVCV6PrQxAhi8wp4SLxr+8MOUiIhoCAxZ5INSJhTwFNiz9azjBB7PSS2LrvB
	OoGRdwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Kh4Jr2DcVWDxSFGAQ5GJR5ezt9+
	wUKsiWXFlbmHGCU4mJVEeCWAMSXEm5JYWZValB9fVJqTWnyIMRnoqInMUqLJ+cCIzSuJNzQ2
	MTOyNDI3tDAyNidNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxsol3w5qXt4kbsKl47Dg
	6EE9/1kt5zI+mJ69lW+ZwOqus73xykzdZ7lNmufljh0XDpDyPMlyL+YBb+b/FX/m7cvrvWC4
	Zk1FovOp+xZlitUNk7pPiaU8qm1bbh63VUdj+vTVnztSpm372TOL7b5u0a9Fl+LZFrP1a/6d
	13G2U1c/0/KhnPpvVSWW4oxEQy3mouJEANdsLY3OAgAA
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

