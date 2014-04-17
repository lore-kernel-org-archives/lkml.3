Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161365AbaDQKKS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 06:10:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22904 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161175AbaDQKKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 06:10:07 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-92-534fa87b715f
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv2 8/8] extcon: arizona: Use devm_extcon_dev_register()
Date: Thu, 17 Apr 2014 19:10:03 +0900
Message-id: <1397729403-32045-9-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397729403-32045-1-git-send-email-sangjung.woo@samsung.com>
References: <1397729403-32045-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWyRsSkQLd6hX+wweVnHBbXvzxntXj9wtDi
	8q45bBa3G1ewWSzYU2IxY/JLNgc2j74tqxg9Pm+SC2CK4rJJSc3JLEst0rdL4MqYd/4yW0GT
	YMW0/T/YGxjn8XUxcnJICJhInHi5lhnCFpO4cG89WxcjF4eQwFJGidV/djPCFP241MMOkZjO
	KLF2+ytWCKeNSeLP2mlg7WwCuhJPDlwGs0UEgiU6Th5nAiliFljCKPHv5C02kISwgJtE5/tF
	LCA2i4CqxP+VR8FsXgEPiX+ndgJN5QBapyAxZ5INSJhTwFNiz9azYFcIAZVsXXYDbLGEwH82
	iSXb/zJCzBGQ+Db5EAtEr6zEpgNQ70hKHFxxg2UCo/ACRoZVjKKpBckFxUnpRYZ6xYm5xaV5
	6XrJ+bmbGIHBe/rfs94djLcPWB9iTAYaN5FZSjQ5Hxj8eSXxhsZmRhamJqbGRuaWZqQJK4nz
	Jj1MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAqHvrx49bjx5M+KQS23mmU3xzooex8R6e
	u4v+iXybr7bwoLR/5yNPeYOIj8t4JDs3BvYsLPisInArZ/LBX78+TYoTW/hn59Pbf/f4VZnd
	6mMW3zPNe9H8h506dr7pH2z1TrBzCn/KP7spc3eV4e3dVjFLnk4v4JCztjd+Zig5rd2zZYJR
	gJkyixJLcUaioRZzUXEiAI3nPn90AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t9jQd3qFf7BBssXM1pc//Kc1eL1C0OL
	y7vmsFncblzBZrFgT4nFjMkv2RzYPPq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYxY975y2wFTYIV0/b/YG9gnMfXxcjJISFgIvHjUg87hC0mceHeerYu
	Ri4OIYHpjBJrt79ihXDamCT+rJ3GDFLFJqAr8eTAZTBbRCBYouPkcSaQImaBJYwS/07eYgNJ
	CAu4SXS+X8QCYrMIqEr8X3kUzOYV8JD4d2on0FQOoHUKEnMm2YCEOQU8JfZsPcsIYgsBlWxd
	doN1AiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBsfFMegfjqgaLQ4wCHIxKPLyc
	v/2ChVgTy4orcw8xSnAwK4nwSgAjS4g3JbGyKrUoP76oNCe1+BBjMtBRE5mlRJPzgXGbVxJv
	aGxiZmRpZG5oYWRsTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MyzkmCaeWpQt73nm1
	WcpuemCQVefrX/7V39cazXznGtY594HYE2fZnExJ52lzv7katm/nXMDEOy9Z6M0FHYcaHt41
	60V+xxbyJWbNXK9xoqvFdf0Dcw6dmUHfH+u/O3j/zRrx1Wy6mns5Dy758X/x39fS4cFzZP1m
	nPSfbTkl7uTBF7+mX+NIVmIpzkg01GIuKk4EAAV487PRAgAA
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
Reviewed-by: Seung-Woo Kim <sw0312.kim@samsung.com>
---
 drivers/extcon/extcon-arizona.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 98a14f6..40e6c0b 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -1105,15 +1105,13 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
 	if (!info) {
 		dev_err(&pdev->dev, "Failed to allocate memory\n");
-		ret = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 
 	info->micvdd = devm_regulator_get(arizona->dev, "MICVDD");
 	if (IS_ERR(info->micvdd)) {
-		ret = PTR_ERR(info->micvdd);
 		dev_err(arizona->dev, "Failed to get MICVDD: %d\n", ret);
-		goto err;
+		return PTR_ERR(info->micvdd);
 	}
 
 	mutex_init(&info->lock);
@@ -1155,11 +1153,11 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 	info->edev.dev.parent = arizona->dev;
 	info->edev.supported_cable = arizona_cable;
 
-	ret = extcon_dev_register(&info->edev);
+	ret = devm_extcon_dev_register(&pdev->dev, &info->edev);
 	if (ret < 0) {
 		dev_err(arizona->dev, "extcon_dev_register() failed: %d\n",
 			ret);
-		goto err;
+		return ret;
 	}
 
 	info->input = devm_input_allocate_device(&pdev->dev);
@@ -1410,8 +1408,6 @@ err_rise:
 err_input:
 err_register:
 	pm_runtime_disable(&pdev->dev);
-	extcon_dev_unregister(&info->edev);
-err:
 	return ret;
 }
 
@@ -1445,7 +1441,6 @@ static int arizona_extcon_remove(struct platform_device *pdev)
 	regmap_update_bits(arizona->regmap, ARIZONA_JACK_DETECT_ANALOGUE,
 			   ARIZONA_JD1_ENA, 0);
 	arizona_clk32k_disable(arizona);
-	extcon_dev_unregister(&info->edev);
 
 	return 0;
 }
-- 
1.7.9.5

