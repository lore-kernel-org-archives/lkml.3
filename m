Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaDUKKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 06:10:52 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:10471 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaDUKKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 06:10:22 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-dc-5354ee89aa2e
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv4 8/8] extcon: arizona: Use devm_extcon_dev_register()
Date: Mon, 21 Apr 2014 19:10:15 +0900
Message-id: <1398075015-19211-9-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398075015-19211-1-git-send-email-sangjung.woo@samsung.com>
References: <1398075015-19211-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWyRsSkSLfzXUiwwfd+ZYvrX56zWrx+YWhx
	edccNovbjSvYLBbsKbGYMfklmwObR9+WVYwenzfJBTBFcdmkpOZklqUW6dslcGWc2vaCsWCX
	QMWC3vPsDYy3eLsYOTgkBEwkjp8J6mLkBDLFJC7cW88GYgsJLGWUuHKTHSJuItHzspu5i5EL
	KL6IUeLIxR9MEE4bk8S19SfBOtgEdCWeHLjMDGKLCARLdJw8DlbELLCEUeLfyVtgRcICbhK/
	ej6DjWURUJXoXriPEcTmFfCQuLznEzvERQoScybZgIQ5BTwlFk1dyAhxkYfE6U/zwa6QEPjN
	JvF412dmiDkCEt8mH2KB6JWV2HSAGeJqSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3IVK84Mbe4
	NC9dLzk/dxMjMHBP/3s2cQfj/QPWhxiTgcZNZJYSTc4HBn5eSbyhsZmRhamJqbGRuaUZacJK
	4rzpj5KChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDW7OcJLv+it23Rh9QDryLC4lckv3d5
	vGJf6tEk5r2f44w6NkTfOKpp9qjh3oJLfAvMjGa8u5j4Ndx4TuWlK1NuG3WEvSi67cS7be76
	n5V1Czbs+uv90TD08sQK/yYH654Lmrn6f690zd2091KbHvu5V/t5jKv2cks1BgpurOP+4fZC
	+bKwSHihEktxRqKhFnNRcSIAajagCnICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t9jAd3OdyHBBu8nS1tc//Kc1eL1C0OL
	y7vmsFncblzBZrFgT4nFjMkv2RzYPPq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYx49S2F4wFuwQqFvSeZ29gvMXbxcjJISFgItHzspsZwhaTuHBvPVsX
	IxeHkMAiRokjF38wQThtTBLX1p9kA6liE9CVeHLgMliHiECwRMfJ42BFzAJLGCX+nbwFViQs
	4Cbxq+czO4jNIqAq0b1wHyOIzSvgIXF5zyegOAfQOgWJOZNsQMKcAp4Si6YuBCsRAio5/Wk+
	8wRG3gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgmPjmdQOxpUNFocYBTgYlXh4Z5SE
	BAuxJpYVV+YeYpTgYFYS4Y1YDxTiTUmsrEotyo8vKs1JLT7EmAx01ERmKdHkfGDc5pXEGxqb
	mBlZGpkbWhgZm5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QDY6Np1478GomlsyoLZyVc
	4i1/t+zkxyTbL1f/7ZssKnl1M8vqz37bumx1tqddOuDlVvKLyeJa+oR/XFm31+20YK9bpFzP
	mndDaV9ckdkMp6vNXi9vG362/8Z9se15npiOXPTSP0f/J3Ae1Pg00eCe9S23giaJWZUZC43E
	9s3hzbx3tJOJh2fFVyWW4oxEQy3mouJEAAg3pzPRAgAA
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
 drivers/extcon/extcon-arizona.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 98a14f6..f63fa6f 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -1105,15 +1105,14 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 	info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
 	if (!info) {
 		dev_err(&pdev->dev, "Failed to allocate memory\n");
-		ret = -ENOMEM;
-		goto err;
+		return -ENOMEM;
 	}
 
 	info->micvdd = devm_regulator_get(arizona->dev, "MICVDD");
 	if (IS_ERR(info->micvdd)) {
 		ret = PTR_ERR(info->micvdd);
 		dev_err(arizona->dev, "Failed to get MICVDD: %d\n", ret);
-		goto err;
+		return ret;
 	}
 
 	mutex_init(&info->lock);
@@ -1155,11 +1154,11 @@ static int arizona_extcon_probe(struct platform_device *pdev)
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
@@ -1410,8 +1409,6 @@ err_rise:
 err_input:
 err_register:
 	pm_runtime_disable(&pdev->dev);
-	extcon_dev_unregister(&info->edev);
-err:
 	return ret;
 }
 
@@ -1445,7 +1442,6 @@ static int arizona_extcon_remove(struct platform_device *pdev)
 	regmap_update_bits(arizona->regmap, ARIZONA_JACK_DETECT_ANALOGUE,
 			   ARIZONA_JD1_ENA, 0);
 	arizona_clk32k_disable(arizona);
-	extcon_dev_unregister(&info->edev);
 
 	return 0;
 }
-- 
1.7.9.5

