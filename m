Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbaFBG1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 02:27:25 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:22684 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaFBG1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 02:27:23 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-fd-538c1949c233
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Matt Porter'" <mporter@linaro.org>,
        "'Tim Kryger'" <tim.kryger@linaro.org>
Subject: [PATCH 1/3] regulator: bcm590xx: remove unnecessary OOM messages
Date: Mon, 02 Jun 2014 15:27:21 +0900
Message-id: <000101cf7e2b$b5c9f9c0$215ded40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9+K7WAMnl298jeROKabyh9CsMnMA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zQ11PyZ5gg2c7jS2mPnzCZnF54SVW
	i29XOpgsLu+aw2YxZ622RfuGMgc2j52z7rJ7bFrVyeZx59oeNo++LasYPT5vkgtgjeKySUnN
	ySxLLdK3S+DK6G1sYS/4wVvx7GVJA+Mm7i5GTg4JAROJja9nMULYYhIX7q1n62Lk4hASWMYo
	sXLhVHaYopN3WlghEosYJSav3coM4fxmlDj5YwITSBWbgJrEly+HgTo4OEQEVCX+v3IHqWEW
	2Mko8fD1OlaQuLCAp8TmTlOQchagkr0/zjOD2LwCthJ7294wQdiCEj8m32MBsZkFtCTW7zzO
	BGHLS2xe85YZZIyEgLrEo7+6IGERAT2Jzm1voUpEJPa9eMcIslZC4BS7xJ6Hz9kgdglIfJt8
	iAWiV1Zi0wFmiL8kJQ6uuMEygVFsFpLNs5BsnoVk8ywkKxYwsqxiFE0tSC4oTkovMtUrTswt
	Ls1L10vOz93ECIm+iTsY7x+wPsSYDLR+IrOUaHI+MHrzSuINjc2MLExNTI2NzC3NSBNWEudN
	f5QUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHx2N+HzHtPSy6S2Nf5oUMtZ+NzT769S7L8
	5rDpfdhXPOXXta3ruF+0a3tcnBKqZ378avLrqXOc5qh27VE6vILlmtcLtow/XY5rxfaoBr/T
	j1h5z6bHYqfobm3rjpYLoZ53OvVmxbM15ceslWh+zOxsLGs/y0adtdVvZd7XC5aBDWklcs9c
	I68rsRRnJBpqMRcVJwIAoPJXnNQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAV1PyZ5ggyOT9S2mPnzCZnF54SVW
	i29XOpgsLu+aw2YxZ622RfuGMgc2j52z7rJ7bFrVyeZx59oeNo++LasYPT5vkgtgjWpgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOkBJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmNHb2MJe8IO34tnLkgbGTdxdjJwcEgIm
	EifvtLBC2GISF+6tZ+ti5OIQEljEKDF57VZmCOc3o8TJHxOYQKrYBNQkvnw5zN7FyMEhIqAq
	8f+VO0gNs8BORomHr9exgsSFBTwlNneagpSzAJXs/XGeGcTmFbCV2Nv2hgnCFpT4MfkeC4jN
	LKAlsX7ncSYIW15i85q3zCBjJATUJR791QUJiwjoSXRuewtVIiKx78U7xgmMArOQTJqFZNIs
	JJNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4tp9J7WBc2WBxiFGAg1GJh3fC
	gq5gIdbEsuLK3EOMEhzMSiK8R892BwvxpiRWVqUW5ccXleakFh9iTAZ6dCKzlGhyPjDt5JXE
	GxqbmBlZGplZGJmYm5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QD4+k6S4PllbdXuG/v
	tzDJ43eXzapZqRux+k9NzS62zkOr8jlnse6RfdklEcS40Olo3oVfPWL/b1Sx7nPr2Pv7xfnH
	9S2lroJ9Ecrylns8jv5ZmLEp8pBc3flXK47/sXax/8RRrJYRVvt1knrvjh3c3nVvz9U1y+5Y
	u0vkwG2zfX90EvSb5i1uV2Ipzkg01GIuKk4EAJbMm+YxAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The site-specific OOM messages are unnecessary, because they
duplicate the MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/bcm590xx-regulator.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/bcm590xx-regulator.c b/drivers/regulator/bcm590xx-regulator.c
index 57544e2..fb8c6f7 100644
--- a/drivers/regulator/bcm590xx-regulator.c
+++ b/drivers/regulator/bcm590xx-regulator.c
@@ -326,10 +326,8 @@ static struct bcm590xx_board *bcm590xx_parse_dt_reg_data(
 	}
 
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
-	if (!data) {
-		dev_err(&pdev->dev, "failed to allocate regulator board data\n");
+	if (!data)
 		return NULL;
-	}
 
 	np = of_node_get(np);
 	regulators = of_get_child_by_name(np, "regulators");
@@ -374,10 +372,8 @@ static int bcm590xx_probe(struct platform_device *pdev)
 					      &bcm590xx_reg_matches);
 
 	pmu = devm_kzalloc(&pdev->dev, sizeof(*pmu), GFP_KERNEL);
-	if (!pmu) {
-		dev_err(&pdev->dev, "Memory allocation failed for pmu\n");
+	if (!pmu)
 		return -ENOMEM;
-	}
 
 	pmu->mfd = bcm590xx;
 
@@ -385,17 +381,13 @@ static int bcm590xx_probe(struct platform_device *pdev)
 
 	pmu->desc = devm_kzalloc(&pdev->dev, BCM590XX_NUM_REGS *
 			sizeof(struct regulator_desc), GFP_KERNEL);
-	if (!pmu->desc) {
-		dev_err(&pdev->dev, "Memory alloc fails for desc\n");
+	if (!pmu->desc)
 		return -ENOMEM;
-	}
 
 	pmu->info = devm_kzalloc(&pdev->dev, BCM590XX_NUM_REGS *
 			sizeof(struct bcm590xx_info *), GFP_KERNEL);
-	if (!pmu->info) {
-		dev_err(&pdev->dev, "Memory alloc fails for info\n");
+	if (!pmu->info)
 		return -ENOMEM;
-	}
 
 	info = bcm590xx_regs;
 
-- 
1.7.10.4


