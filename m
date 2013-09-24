Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab3IXJTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:19:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22788 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab3IXJS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:18:58 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-7d-5241590142ea
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
In-reply-to: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
Subject: [PATCH 19/22] backlight: pandora_bl: use
 devm_backlight_device_register()
Date: Tue, 24 Sep 2013 18:18:57 +0900
Message-id: <005901ceb907$18dfe8c0$4a9fba40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65BQPO2UlhwYgjRvaJnkuV9ccl+gAAgJ3Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zI13GSMcgg43flCzmrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsErowPs76z
	FuznqWi99JW5gfEUVxcjJ4eEgInEsl2zmCBsMYkL99azdTFycQgJLGOUONK5hg2maMHWNlaI
	xHRGiXtnn7FDOL8YJT4cfc8IUsUmoCbx5cthoAQHh4iAvkRbiwZImFkgR+L+k1nsILaQgK3E
	ug+zwWxOATuJU0vPgC0QFgiR2LBwFwuIzSKgKtF2cw8TyBheoPo5vxRBwrwCghI/Jt9jgRip
	JbF5WxMrhC0vsXnNW2aQcgkBdYlHf3VBwiICRhI7b51jhigRkdj34h0jyMUSApfYJZoOHmeG
	WCUg8W3yIRaIXlmJTQeYId6VlDi44gbLBEaJWUg2z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9
	yFSvODG3uDQvXS85P3cTIyQmJ+5gvH/A+hBjMtD6icxSosn5wJjOK4k3NDYzsjA1MTU2Mrc0
	I01YSZxXvcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAOjnhvvgruHBVUPKnSZZn/TClYN
	C/Dv5U/NdO5ZVq9bu0v+tpV7rf+aN6X2qfnii9Tattd/j+/8tzMs8b3owbu5add8/kUt15/S
	57ihtDTx71TGWSVXn5W71Cdm+Ib99EutvnCh2fZ7itSGt8v+ZukeiQmd+u2d58N0O4vnReUc
	Ke+4W58rxyixFGckGmoxFxUnAgC0efMX3wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jQV3GSMcgg30T5S3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMD7O+sxbs56lovfSVuYHxFFcXIyeHhICJxIKtbawQtpjEhXvr
	2boYuTiEBKYzStw7+4wdwvnFKPHh6HtGkCo2ATWJL18OAyU4OEQE9CXaWjRAwswCORL3n8xi
	B7GFBGwl1n2YDWZzCthJnFp6hg3EFhYIkdiwcBcLiM0ioCrRdnMPE8gYXqD6Ob8UQcK8AoIS
	PybfY4EYqSWxeVsTK4QtL7F5zVtmkHIJAXWJR391QcIiAkYSO2+dY4YoEZHY9+Id4wRGoVlI
	Js1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc8c+kdjCubLA4xCjA
	wajEw7vD2yFIiDWxrLgy9xCjBAezkgjvDVvHICHelMTKqtSi/Pii0pzU4kOMyUB/TmSWEk3O
	ByajvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpgbCkvqD67
	eesjge/91l0zL89lO1cmEtMY0HDQsX0O2yQ1u82at5bef57Abuzr6m985OqF/d168RG6kb1l
	xxKPPDRgy5x40ez+wzXtnxyseedsnR7gvb7c5YPmN1/etry36W6Z3fp69dd88qdUC17pfvXn
	yJuNvIuY77O+uDR3nW9f55HtW2pLlFiKMxINtZiLihMB/IXq0DwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/pandora_bl.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/video/backlight/pandora_bl.c b/drivers/video/backlight/pandora_bl.c
index 633b0a2..2098c5d 100644
--- a/drivers/video/backlight/pandora_bl.c
+++ b/drivers/video/backlight/pandora_bl.c
@@ -120,8 +120,8 @@ static int pandora_backlight_probe(struct platform_device *pdev)
 	memset(&props, 0, sizeof(props));
 	props.max_brightness = MAX_USER_VALUE;
 	props.type = BACKLIGHT_RAW;
-	bl = backlight_device_register(pdev->name, &pdev->dev,
-			NULL, &pandora_backlight_ops, &props);
+	bl = devm_backlight_device_register(&pdev->dev, pdev->name, &pdev->dev,
+					NULL, &pandora_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
 		return PTR_ERR(bl);
@@ -145,20 +145,12 @@ static int pandora_backlight_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int pandora_backlight_remove(struct platform_device *pdev)
-{
-	struct backlight_device *bl = platform_get_drvdata(pdev);
-	backlight_device_unregister(bl);
-	return 0;
-}
-
 static struct platform_driver pandora_backlight_driver = {
 	.driver		= {
 		.name	= "pandora-backlight",
 		.owner	= THIS_MODULE,
 	},
 	.probe		= pandora_backlight_probe,
-	.remove		= pandora_backlight_remove,
 };
 
 module_platform_driver(pandora_backlight_driver);
-- 
1.7.10.4


