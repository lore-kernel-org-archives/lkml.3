Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab3IYHzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 03:55:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24147 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab3IYHzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 03:55:11 -0400
X-AuditID: cbfee68e-b7f756d000004512-db-524296dd7162
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "'Krystian Garbaciak'" <krystian.garbaciak@diasemi.com>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
In-reply-to: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
Subject: [PATCH 04/20] regulator: da9063: use devm_regulator_register()
Date: Wed, 25 Sep 2013 16:55:09 +0900
Message-id: <000d01ceb9c4$8ea3ef80$abebce80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65w5fHnzL+CpaSR8SldcZ2fs0oxwAAKTYA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t8zI91705yCDBbFWEx9+ITN4tmtvUwW
	lxdeYrU48vgzm8W3Kx1A7q45bA5sHis+6XvsnHWX3WPTqk42j0OHOxg9+rasYvT4vEkugC2K
	yyYlNSezLLVI3y6BK2N/v0HBXYGKr0+vMDYw3uLtYuTgkBAwkTh4WqGLkRPIFJO4cG89Wxcj
	F4eQwDJGib2LX7BAJEwkuj5MZIJILGKU2Hi+C6rqF6PEodUb2UGq2ATUJL58OcwOMlVEQFXi
	/yt3kBpmgauMEieebWMGqRESsJVY/vc22FROATuJZfc+s4HYwgLuEt9ff2ECsVmAev8uvwQ2
	kxeofsmKWUwQtqDEj8n3wHqZBbQk1u88zgRhy0tsXvOWGeIbdYlHf3UhTjCS6NuZCFEhIrHv
	xTtGkHMkBF6yS3x4tYYNYpWAxLfJh1ggWmUlNh1ghvhXUuLgihssExglZiFZPAvJ4llIFs9C
	smIBI8sqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjJCo7dvBePOA9SHGZKD1E5mlRJPzgVGf
	VxJvaGxmZGFqYmpsZG5pRpqwkjivWot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGmXs3
	z79b4bGl5MEqN02VI+92h/z7eH7DG8mXDL47P4V3ZV9gvDk12WGTVEjqjDZjjjMqXwQs3lS/
	7WRRObdE84Flzoa+V7Fhq4OvXnWNF73M0n+1dO655E5JzS9dvpHLz69Myua+mlws3PncqdNM
	cLvDHv++8x2L/ZU5rcV2xH4VXb2Vi3G+EktxRqKhFnNRcSIAevg+7PACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsVy+t9jAd2705yCDGZftrSY+vAJm8WzW3uZ
	LC4vvMRqceTxZzaLb1c6gNxdc9gc2DxWfNL32DnrLrvHplWdbB6HDncwevRtWcXo8XmTXABb
	VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QGUoK
	ZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjP39BgV3BSq+Pr3C2MB4i7eL
	kZNDQsBEouvDRCYIW0ziwr31bF2MXBxCAosYJTae74JyfjFKHFq9kR2kik1ATeLLl8NANgeH
	iICqxP9X7iA1zAJXGSVOPNvGDFIjJGArsfzvbRYQm1PATmLZvc9sILawgLvE99dfwLaxAPX+
	XX4JbCYvUP2SFbOYIGxBiR+T74H1MgtoSazfeZwJwpaX2LzmLTPIXgkBdYlHf3UhTjCS6NuZ
	CFEhIrHvxTvGCYxCs5AMmoVk0Cwkg2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cT
	IzgtPJPewbiqweIQowAHoxIPr8BRxyAh1sSy4srcQ4wSHMxKIrxFU52ChHhTEiurUovy44tK
	c1KLDzEmA/05kVlKNDkfmLLySuINjU3MjCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBa
	BLOFiYNTqoFRNb9ngdWRzGOu7l83VNdkXVt4Lvtgkr231I03G5K21p/xjfeoUVjcMSP9TKbr
	S9HlG7YkmjsF3PtedylRwz773W1Tdl+/a5LLl4SbtT5W+zxBWTLgWDzXow1XTkRFBMTVHrs5
	f/L9GrHdSw68M097NU/32IuUfdwV38NXLD0SGnt/+WW7r8fFlViKMxINtZiLihMBJCgrRk8D	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/da9063-regulator.c |   21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/drivers/regulator/da9063-regulator.c b/drivers/regulator/da9063-regulator.c
index 3d910f4..56727eb 100644
--- a/drivers/regulator/da9063-regulator.c
+++ b/drivers/regulator/da9063-regulator.c
@@ -847,13 +847,13 @@ static int da9063_regulator_probe(struct platform_device *pdev)
 		if (da9063_reg_matches)
 			config.of_node = da9063_reg_matches[id].of_node;
 		config.regmap = da9063->regmap;
-		regl->rdev = regulator_register(&regl->desc, &config);
+		regl->rdev = devm_regulator_register(&pdev->dev, &regl->desc,
+						     &config);
 		if (IS_ERR(regl->rdev)) {
 			dev_err(&pdev->dev,
 				"Failed to register %s regulator\n",
 				regl->desc.name);
-			ret = PTR_ERR(regl->rdev);
-			goto err;
+			return PTR_ERR(regl->rdev);
 		}
 		id++;
 		n++;
@@ -862,9 +862,8 @@ static int da9063_regulator_probe(struct platform_device *pdev)
 	/* LDOs overcurrent event support */
 	irq = platform_get_irq_byname(pdev, "LDO_LIM");
 	if (irq < 0) {
-		ret = irq;
 		dev_err(&pdev->dev, "Failed to get IRQ.\n");
-		goto err;
+		return irq;
 	}
 
 	regulators->irq_ldo_lim = regmap_irq_get_virq(da9063->regmap_irq, irq);
@@ -881,27 +880,15 @@ static int da9063_regulator_probe(struct platform_device *pdev)
 	}
 
 	return 0;
-
-err:
-	/* Wind back regulators registeration */
-	while (--n >= 0)
-		regulator_unregister(regulators->regulator[n].rdev);
-
-	return ret;
 }
 
 static int da9063_regulator_remove(struct platform_device *pdev)
 {
 	struct da9063_regulators *regulators = platform_get_drvdata(pdev);
-	struct da9063_regulator *regl;
 
 	free_irq(regulators->irq_ldo_lim, regulators);
 	free_irq(regulators->irq_uvov, regulators);
 
-	for (regl = &regulators->regulator[regulators->n_regulators - 1];
-	     regl >= &regulators->regulator[0]; regl--)
-		regulator_unregister(regl->rdev);
-
 	return 0;
 }
 
-- 
1.7.10.4


