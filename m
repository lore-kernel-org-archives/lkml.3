Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaDUKK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 06:10:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:10471 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbaDUKKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 06:10:18 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-58-5354ee89439b
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv4 5/8] extcon: max77693: Use devm_extcon_dev_register()
Date: Mon, 21 Apr 2014 19:10:12 +0900
Message-id: <1398075015-19211-6-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398075015-19211-1-git-send-email-sangjung.woo@samsung.com>
References: <1398075015-19211-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWyRsSkULfzXUiwQfs2aYvrX56zWrx+YWhx
	edccNovbjSvYLBbsKbGYMfklmwObR9+WVYwenzfJBTBFcdmkpOZklqUW6dslcGUcP69X8IGv
	ounXD/YGxhM8XYycHBICJhI7OyezQdhiEhfurQeyuTiEBJYySkzcPYEZpujPxOmsEIlFjBIX
	rz1kgnDamCSmXG1nBKliE9CVeHLgMliHiECwRMfJ42BFzAJLGCX+nbwFtkNYwF2i8fBydhCb
	RUBVYvWUtWBxXgEPicvrzwI1cACtU5CYM8kGJMwp4CmxaOpCsPlCQCWnP81nBpkpIfCbTeLv
	nFmMEHMEJL5NPsQC0SsrsekA1NWSEgdX3GCZwCi8gJFhFaNoakFyQXFSepGxXnFibnFpXrpe
	cn7uJkZg6J7+96x/B+PdA9aHGJOBxk1klhJNzgeGfl5JvKGxmZGFqYmpsZG5pRlpwkrivPcf
	JgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYNz/92WmdZNG5fRNvz9oPZiUr82SPnHr1aqp
	vQHxdxd/rdr41S3x2y7W1Xc7nS/vd2eoEpaep5L4fxXnD9tc8+3LPjS9Mn0+OXUfc4N+93Wp
	gCPGP6aerNt2dtrvc97r9vm8aZBL/BohlX55V+dfH7UHXDt765eK9f68sVvEteej9ZeZi2Zn
	N6grsRRnJBpqMRcVJwIAZTSaDnMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t9jAd3OdyHBBj1PhS2uf3nOavH6haHF
	5V1z2CxuN65gs1iwp8RixuSXbA5sHn1bVjF6fN4kF8AU1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvh2lCaIibrgVM
	Y4Sub0gQXI+RARpIWMOYcfy8XsEHvoqmXz/YGxhP8HQxcnJICJhI/Jk4nRXCFpO4cG89Wxcj
	F4eQwCJGiYvXHjJBOG1MElOutjOCVLEJ6Eo8OXCZGcQWEQiW6Dh5HKyIWWAJo8S/k7fYQBLC
	Au4SjYeXs4PYLAKqEqunrAWL8wp4SFxefxaogQNonYLEnEk2IGFOAU+JRVMXgs0XAio5/Wk+
	8wRG3gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgiPjmfQOxlUNFocYBTgYlXh4X+SH
	BAuxJpYVV+YeYpTgYFYS4Y1YDxTiTUmsrEotyo8vKs1JLT7EmAx01ERmKdHkfGDU5pXEGxqb
	mBlZGpkbWhgZm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QD47wdb2zX+/4/4Js4dU79
	m2Nm7MH3ygRCFjNM5w9frFWzqGS5SuOJOrtfc8wE68XnP2bTyPvr6xVx3W3b/cK8Q0wJ2Sy7
	2B75tfS80n4zdZ8Bz/lp02wYd9V8K1L8PUHQ1ftc5q0HXheTnoeKn5f0sWg2fn+0UD1xqfPC
	RWv6d59V5X843bClXomlOCPRUIu5qDgRAMx5cPnQAgAA
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
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/extcon/extcon-max77693.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 39cd095..f0f18e2 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1185,7 +1185,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	info->edev->name = DEV_NAME;
 	info->edev->dev.parent = &pdev->dev;
 	info->edev->supported_cable = max77693_extcon_cable;
-	ret = extcon_dev_register(info->edev);
+	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
 		goto err_irq;
@@ -1267,7 +1267,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
 			MAX77693_MUIC_REG_ID, &id);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to read revision number\n");
-		goto err_extcon;
+		goto err_irq;
 	}
 	dev_info(info->dev, "device ID : 0x%x\n", id);
 
@@ -1288,8 +1288,6 @@ static int max77693_muic_probe(struct platform_device *pdev)
 
 	return ret;
 
-err_extcon:
-	extcon_dev_unregister(info->edev);
 err_irq:
 	while (--i >= 0)
 		free_irq(muic_irqs[i].virq, info);
@@ -1305,7 +1303,6 @@ static int max77693_muic_remove(struct platform_device *pdev)
 		free_irq(muic_irqs[i].virq, info);
 	cancel_work_sync(&info->irq_work);
 	input_unregister_device(info->dock);
-	extcon_dev_unregister(info->edev);
 
 	return 0;
 }
-- 
1.7.9.5

