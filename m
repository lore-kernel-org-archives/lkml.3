Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaDRAdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:33:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:30892 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaDRAcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:32:43 -0400
X-AuditID: cbfee68f-b7f156d00000276c-42-535072a5d7f9
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv3 8/8] extcon: arizona: Use devm_extcon_dev_register()
Date: Fri, 18 Apr 2014 09:32:40 +0900
Message-id: <1397781160-744-9-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397781160-744-1-git-send-email-sangjung.woo@samsung.com>
References: <1397781160-744-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWyRsSkRHdZUUCwwbnbzBbXvzxntXj9wtDi
	8q45bBa3G1ewWSzYU2IxY/JLNgc2j74tqxg9Pm+SC2CK4rJJSc3JLEst0rdL4Mo4te0FY8Eu
	gYoFvefZGxhv8XYxcnJICJhIbG85xQhhi0lcuLeerYuRi0NIYCmjxJY1p9lhipa17GGHSCxi
	lJi+8xwjhNPGJLH/2WlmkCo2AV2JJwcug9kiAsESHSePM4EUMQssYZT4d/IWG0hCWMBN4vjx
	BWA2i4CqxLr+i2AreIHi/y9eY+1i5ABapyAxZ5INSJhTwF1i1q6dTCC2EFDJ8y1TwRZLCPxn
	kzi68iw7xBwBiW+TD7FA9MpKbDrADHG1pMTBFTdYJjAKL2BkWMUomlqQXFCclF5krFecmFtc
	mpeul5yfu4kRGLyn/z3r38F494D1IcZkoHETmaVEk/OBwZ9XEm9obGZkYWpiamxkbmlGmrCS
	OO/9h0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhitGZ/kLvl3Vifm0pvczYJeukpc0RbT
	jx6WdV/o7LBmQofWW54HU1s3fnuk+Kf7+ZRWS8vP77vnv+dlX3b0ZinrxZZXyxZGSySllnrx
	G9Vt+6r+ymbzbWs+sYVrNkQXyG8/27+do+hO7q+N9gtPbtH6c/qEuBSry1G/wi/Tb1bP7RDk
	eMWppB2ixFKckWioxVxUnAgAM8nAInQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t9jAd2lRQHBBlMPW1pc//Kc1eL1C0OL
	y7vmsFncblzBZrFgT4nFjMkv2RzYPPq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYx49S2F4wFuwQqFvSeZ29gvMXbxcjJISFgIrGsZQ87hC0mceHeerYu
	Ri4OIYFFjBLTd55jhHDamCT2PzvNDFLFJqAr8eTAZTBbRCBYouPkcSaQImaBJYwS/07eYgNJ
	CAu4SRw/vgDMZhFQlVjXfxFsBS9Q/P/Fa6xdjBxA6xQk5kyyAQlzCrhLzNq1kwnEFgIqeb5l
	KuMERt4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYJj45n0DsZVDRaHGAU4GJV4eC98
	9Q8WYk0sK67MPcQowcGsJMJ7Pi0gWIg3JbGyKrUoP76oNCe1+BBjMtBRE5mlRJPzgXGbVxJv
	aGxiZmRpZG5oYWRsTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MkVGvjrHc0eBy1Lz+
	7a/9evclYoz3l+7p+rlw2ez1bi6PoqatcPM6bxDDXPDQydpqqbNX+J3kwOvbD/kvm/Hg/KHr
	66RD7wXNUv6nuOiMnHmfWNHFXIXXjF90/GOi66pXfDkekhYl3nRiyc/Nl+YeC3f4Zl58Uvdw
	4HnZ95nhNm82pj19+8JpoxJLcUaioRZzUXEiABsIM9PRAgAA
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

