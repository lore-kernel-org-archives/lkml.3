Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaDUKKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 06:10:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28482 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbaDUKKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 06:10:20 -0400
X-AuditID: cbfee68e-b7fd86d0000038e3-25-5354ee891d6a
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv4 4/8] extcon: max14577: Use devm_extcon_dev_register()
Date: Mon, 21 Apr 2014 19:10:11 +0900
Message-id: <1398075015-19211-5-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398075015-19211-1-git-send-email-sangjung.woo@samsung.com>
References: <1398075015-19211-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWyRsSkRLfzXUiwQftPYYvrX56zWrx+YWhx
	edccNovbjSvYLBbsKbGYMfklmwObR9+WVYwenzfJBTBFcdmkpOZklqUW6dslcGUc6p/AVnCf
	r2Le4ePsDYybeLoYOTkkBEwkLq2+xgRhi0lcuLeerYuRi0NIYCmjxJO2p0AOB1jRq0tcEPFF
	jBIz392CKmpjkphytZ0RpJtNQFfiyYHLzCC2iECwRMfJ40wgRcwCSxgl/p0E6eDkEBZwl1i2
	4wYriM0ioCrxcM8ysDivgIfE61UL2CG2KUjMmWQDEuYU8JRYNHUh2HwhoJLTn+Yzg8yUEPjN
	JnHnw1RGiDkCEt8mH2KB6JWV2HSAGeIbSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3ISK84Mbe4
	NC9dLzk/dxMjMHRP/3vWt4Px5gHrQ4zJQOMmMkuJJucDQz+vJN7Q2MzIwtTE1NjI3NKMNGEl
	cd5FD5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAy7J3GVHxw1q7AtM5Z/7k+/uq/sJeD
	827Ptv0TbL/xdQlsvCA4ec/kc5c7uydenz8nfs5krn23Jz04+zWxXH2vwaUWx/JCp66DW3a1
	M92ZtEux5Z4Yo8GOjPdKkfuW/xYUUVSZHT27TH/vZQkdEY7OWd/9vO87a/PkOyRfzZ3GvHfS
	Or2n7hrRSizFGYmGWsxFxYkA48G7KHMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t9jAd3OdyHBBgt38lhc//Kc1eL1C0OL
	y7vmsFncblzBZrFgT4nFjMkv2RzYPPq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYx41D/BLaC+3wV8w4fZ29g3MTTxcjBISFgIvHqElcXIyeQKSZx4d56
	ti5GLg4hgUWMEjPf3YJy2pgkplxtZwSpYhPQlXhy4DIziC0iECzRcfI4E0gRs8ASRol/J0E6
	ODmEBdwllu24wQpiswioSjzcswwszivgIfF61QJ2iM0KEnMm2YCEOQU8JRZNXQg2Xwio5PSn
	+cwTGHkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiOjGfSOxhXNVgcYhTgYFTi4X2R
	HxIsxJpYVlyZe4hRgoNZSYQ3Yj1QiDclsbIqtSg/vqg0J7X4EGMy0FETmaVEk/OBUZtXEm9o
	bGJmZGlkbmhhZGxOmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYx6hve+LGyVcThm+qko
	7dy28/HnCuL6ZnIefsIyd3nR1ICsQO6Alu3znF35TLMyxa9MY7jEYv5H4niczCrRYIFTx4Pm
	HZLnznBcuHeXqCS3+gen9Ntn76T5He17YaT9vnKp2NNsjboXppXpt1uNczKTE3f+K5h9Y0/9
	jHLVuprMdk+P6aq6e5RYijMSDbWYi4oTAbOnIqXQAgAA
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
 drivers/extcon/extcon-max14577.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index 1fef08d..c6166e7 100644
--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -675,7 +675,7 @@ static int max14577_muic_probe(struct platform_device *pdev)
 	}
 	info->edev->name = DEV_NAME;
 	info->edev->supported_cable = max14577_extcon_cable;
-	ret = extcon_dev_register(info->edev);
+	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
 		return ret;
@@ -694,7 +694,7 @@ static int max14577_muic_probe(struct platform_device *pdev)
 			MAX14577_REG_DEVICEID, &id);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to read revision number\n");
-		goto err_extcon;
+		return ret;
 	}
 	dev_info(info->dev, "device ID : 0x%x\n", id);
 
@@ -714,10 +714,6 @@ static int max14577_muic_probe(struct platform_device *pdev)
 			delay_jiffies);
 
 	return ret;
-
-err_extcon:
-	extcon_dev_unregister(info->edev);
-	return ret;
 }
 
 static int max14577_muic_remove(struct platform_device *pdev)
@@ -725,7 +721,6 @@ static int max14577_muic_remove(struct platform_device *pdev)
 	struct max14577_muic_info *info = platform_get_drvdata(pdev);
 
 	cancel_work_sync(&info->irq_work);
-	extcon_dev_unregister(info->edev);
 
 	return 0;
 }
-- 
1.7.9.5

