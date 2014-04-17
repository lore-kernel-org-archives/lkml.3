Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbaDQKKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 06:10:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28855 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161137AbaDQKKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 06:10:03 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-49-534fa87a19ec
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv2 4/8] extcon: max14577: Use devm_extcon_dev_register()
Date: Thu, 17 Apr 2014 19:09:59 +0900
Message-id: <1397729403-32045-5-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397729403-32045-1-git-send-email-sangjung.woo@samsung.com>
References: <1397729403-32045-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWyRsSkQLdqhX+wwe1GQ4vrX56zWrx+YWhx
	edccNovbjSvYLBbsKbGYMfklmwObR9+WVYwenzfJBTBFcdmkpOZklqUW6dslcGUc6p/AVnCf
	r2Le4ePsDYybeLoYOTkkBEwkeve8ZoKwxSQu3FvP1sXIxSEksJRR4uP7a4wwRXvXdTJCJKYz
	Smx53MQO4bQxSfxZO40ZpIpNQFfiyYHLYLaIQLBEx8njTCBFzAJLGCX+nbzFBpIQFnCXWL58
	DdAoDg4WAVWJx4+KQcK8Ah4Sj+bsZwUJSwgoSMyZZAMS5hTwlNiz9SzYEUJAJVuX3WAFGSkh
	8J9N4s7EnSwgCRYBAYlvkw+xQPTKSmw6wAxxtKTEwRU3WCYwCi9gZFjFKJpakFxQnJReZKpX
	nJhbXJqXrpecn7uJERi6p/89m7iD8f4B60OMyUDjJjJLiSbnA0M/ryTe0NjMyMLUxNTYyNzS
	jDRhJXHe9EdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY105hKlv0tdB4nfrUqdtUH7Rv
	Czoy5USP+SfV6deNnI5W/nDK3rt9G9N3vc9aokJPml1cVP/XX7dslJ9WstbH7k+iLRe7S1h0
	lIf1jHqj/d/8lkxbuq1rq9SSj19Ml+rnV50+mXG209GzYF94h2z3Ad2nlfryXteufjA8taQj
	0Gfz0oPqi7OLlFiKMxINtZiLihMBMpNeS3MCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t9jQd2qFf7BBhcPaVpc//Kc1eL1C0OL
	y7vmsFncblzBZrFgT4nFjMkv2RzYPPq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYx41D/BLaC+3wV8w4fZ29g3MTTxcjJISFgIrF3XScjhC0mceHeerYu
	Ri4OIYHpjBJbHjexQzhtTBJ/1k5jBqliE9CVeHLgMpgtIhAs0XHyOBNIEbPAEkaJfydvsYEk
	hAXcJZYvXwM0loODRUBV4vGjYpAwr4CHxKM5+1lBwhICChJzJtmAhDkFPCX2bD0LdoQQUMnW
	ZTdYJzDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHBnPpHYwrmywOMQowMGoxMM7
	Qd0/WIg1say4MvcQowQHs5II75JeoBBvSmJlVWpRfnxRaU5q8SHGZKCbJjJLiSbnA6M2ryTe
	0NjEzMjSyNzQwsjYnDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoYD4bnb7/OK8jc1ztR
	r1Y4bUlHpwdbya7HXW+E3//bdOTIymPJuzb3Hctb17ZHf/7aP942/H+iv5zJtzTUqRPujlzV
	/CCZp/H03Ls7z18V3zl1Xt/CGN7qM2ZnWkSU67JVeeeHFli7rzN0NtmuHxacV6/qGXqg2HYq
	58r/NbMOL8+dlL1y3m1mJZbijERDLeai4kQAxUHUedACAAA=
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

