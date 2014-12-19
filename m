Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaLSJEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 04:04:54 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:8294 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaLSJEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 04:04:49 -0500
X-AuditID: cbfee691-f79b86d000004a5a-01-5493ea2f724a
From: Beomho Seo <beomho.seo@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: lgirdwood@gmail.com, broonie@kernel.org, beomho.seo@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] regulator: max14577: Use regulator_nodes/of_match in the
 descriptor
Date: Fri, 19 Dec 2014 18:04:46 +0900
Message-id: <1418979886-31482-1-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWyRsSkWFf/1eQQgyktKhanP21jt5j68Amb
	xfUvz1ktJt2fwGLx+oWhxbcrHUwWl3fNYbP43HuE0WLG5JdsDpweO2fdZffYtKqTzaNvyypG
	j8+b5AJYorhsUlJzMstSi/TtErgy5vzYx1KwQLtiUm8rawPjC+UuRk4OCQETid+Nx5ghbDGJ
	C/fWs3UxcnEICSxllNh85wsLTNG7h1eYIBKLGCV+n5jFCOG0MUmsXvYVrIpNQFPi/ZQrYLaI
	gJXEi/ZX7CBFzAK7GSUerV4BNJeDQ1ggTOJNVyFIDYuAqsTCG4cZQWxeATeJjzdBejmAtilI
	zJlkA9IqIdDOLvHqyRpmiHoBiW+TD0HVyEpsOgB1taTEwRU3WCYwCi5gZFjFKJpakFxQnJRe
	ZKpXnJhbXJqXrpecn7uJERi+p/89m7iD8f4B60OMAhyMSjy8D4onhwixJpYVV+YeYjQF2jCR
	WUo0OR8YJXkl8YbGZkYWpiamxkbmlmZK4rw60j+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBK
	NTCWPjWTKHvDeCAt2/LYNK9N0yy2qK07tHiTzAf5FWXh/jlqExvny6k1TbVw71wicCiHx6DR
	eQ1HlpafR5/IyYOc3iuCz62ZciZl8s8LGdJX59Uw7bryTWdJcuaMuX+/XH5ofPz1fWf7jYfr
	jeT96/ZcXDD/+s5+lusLjpq05fWwJrRd5GtOlulXYinOSDTUYi4qTgQADNq5SloCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsVy+t9jAV39V5NDDDadlLE4/Wkbu8XUh0/Y
	LK5/ec5qMen+BBaL1y8MLb5d6WCyuLxrDpvF594jjBYzJr9kc+D02DnrLrvHplWdbB59W1Yx
	enzeJBfAEtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6Dr
	lpkDdIuSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMWPOj30sBQu0Kyb1
	trI2ML5Q7mLk5JAQMJF49/AKE4QtJnHh3nq2LkYuDiGBRYwSv0/MYoRw2pgkVi/7ygJSxSag
	KfF+yhUwW0TASuJF+yt2kCJmgd2MEo9WrwBq5+AQFgiTeNNVCFLDIqAqsfDGYUYQm1fATeLj
	TZBeDqBtChJzJtlMYORewMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4Op5J7WBc2WBx
	iFGAg1GJh7ejcHKIEGtiWXFl7iFGCQ5mJRFex+NAId6UxMqq1KL8+KLSnNTiQ4ymQMsnMkuJ
	JucDIzevJN7Q2MTMyNLI3NDCyNhcSZxXyb4tREggPbEkNTs1tSC1CKaPiYNTqoEx34A/47mw
	E6vf+w1HLT56s8z8cN9vT1huQMav/80tAR9tGAx1dbbtmtOwV7P1jLjDnhOTgmYx/i/dWd49
	ha9kPd/8tVGNgs8TOtbk8DRfv9AbH3fM5v+3x/8+z17nslgh0EfGqnmxhLeh1yWnR2YCifl/
	N//zXctheZMxaIKixMT/n366XdqnxFKckWioxVxUnAgA+Le4R6QCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is add regulator_nodes/ofmatch in the regulator descriptor
for using information from DT instead of specific codes.
That will be used regulation_of_get_init_data function for get regulator
property on device tree. Using that make driver simpler.

Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
---
 drivers/regulator/max14577.c |   62 ++++++++++--------------------------------
 1 file changed, 14 insertions(+), 48 deletions(-)

diff --git a/drivers/regulator/max14577.c b/drivers/regulator/max14577.c
index 0ff5a20..bbcc750 100644
--- a/drivers/regulator/max14577.c
+++ b/drivers/regulator/max14577.c
@@ -103,6 +103,8 @@ static struct regulator_ops max14577_charger_ops = {
 static const struct regulator_desc max14577_supported_regulators[] = {
 	[MAX14577_SAFEOUT] = {
 		.name		= "SAFEOUT",
+		.of_match	= of_match_ptr("SAFEOUT"),
+		.regulators_node = of_match_ptr("regulators"),
 		.id		= MAX14577_SAFEOUT,
 		.ops		= &max14577_safeout_ops,
 		.type		= REGULATOR_VOLTAGE,
@@ -114,6 +116,8 @@ static const struct regulator_desc max14577_supported_regulators[] = {
 	},
 	[MAX14577_CHARGER] = {
 		.name		= "CHARGER",
+		.of_match	= of_match_ptr("CHARGER"),
+		.regulators_node = of_match_ptr("regulators"),
 		.id		= MAX14577_CHARGER,
 		.ops		= &max14577_charger_ops,
 		.type		= REGULATOR_CURRENT,
@@ -137,6 +141,8 @@ static struct regulator_ops max77836_ldo_ops = {
 static const struct regulator_desc max77836_supported_regulators[] = {
 	[MAX14577_SAFEOUT] = {
 		.name		= "SAFEOUT",
+		.of_match	= of_match_ptr("SAFEOUT"),
+		.regulators_node = of_match_ptr("regulators"),
 		.id		= MAX14577_SAFEOUT,
 		.ops		= &max14577_safeout_ops,
 		.type		= REGULATOR_VOLTAGE,
@@ -148,6 +154,8 @@ static const struct regulator_desc max77836_supported_regulators[] = {
 	},
 	[MAX14577_CHARGER] = {
 		.name		= "CHARGER",
+		.of_match	= of_match_ptr("CHARGER"),
+		.regulators_node = of_match_ptr("regulators"),
 		.id		= MAX14577_CHARGER,
 		.ops		= &max14577_charger_ops,
 		.type		= REGULATOR_CURRENT,
@@ -157,6 +165,8 @@ static const struct regulator_desc max77836_supported_regulators[] = {
 	},
 	[MAX77836_LDO1] = {
 		.name		= "LDO1",
+		.of_match	= of_match_ptr("LDO1"),
+		.regulators_node = of_match_ptr("regulators"),
 		.id		= MAX77836_LDO1,
 		.ops		= &max77836_ldo_ops,
 		.type		= REGULATOR_VOLTAGE,
@@ -171,6 +181,8 @@ static const struct regulator_desc max77836_supported_regulators[] = {
 	},
 	[MAX77836_LDO2] = {
 		.name		= "LDO2",
+		.of_match	= of_match_ptr("LDO2"),
+		.regulators_node = of_match_ptr("regulators"),
 		.id		= MAX77836_LDO2,
 		.ops		= &max77836_ldo_ops,
 		.type		= REGULATOR_VOLTAGE,
@@ -198,43 +210,6 @@ static struct of_regulator_match max77836_regulator_matches[] = {
 	{ .name = "LDO2", },
 };
 
-static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev,
-		enum maxim_device_type dev_type)
-{
-	int ret;
-	struct device_node *np;
-	struct of_regulator_match *regulator_matches;
-	unsigned int regulator_matches_size;
-
-	np = of_get_child_by_name(pdev->dev.parent->of_node, "regulators");
-	if (!np) {
-		dev_err(&pdev->dev, "Failed to get child OF node for regulators\n");
-		return -EINVAL;
-	}
-
-	switch (dev_type) {
-	case MAXIM_DEVICE_TYPE_MAX77836:
-		regulator_matches = max77836_regulator_matches;
-		regulator_matches_size = ARRAY_SIZE(max77836_regulator_matches);
-		break;
-	case MAXIM_DEVICE_TYPE_MAX14577:
-	default:
-		regulator_matches = max14577_regulator_matches;
-		regulator_matches_size = ARRAY_SIZE(max14577_regulator_matches);
-	}
-
-	ret = of_regulator_match(&pdev->dev, np, regulator_matches,
-			regulator_matches_size);
-	if (ret < 0)
-		dev_err(&pdev->dev, "Error parsing regulator init data: %d\n", ret);
-	else
-		ret = 0;
-
-	of_node_put(np);
-
-	return ret;
-}
-
 static inline struct regulator_init_data *match_init_data(int index,
 		enum maxim_device_type dev_type)
 {
@@ -261,11 +236,6 @@ static inline struct device_node *match_of_node(int index,
 	}
 }
 #else /* CONFIG_OF */
-static int max14577_regulator_dt_parse_pdata(struct platform_device *pdev,
-		enum maxim_device_type dev_type)
-{
-	return 0;
-}
 static inline struct regulator_init_data *match_init_data(int index,
 		enum maxim_device_type dev_type)
 {
@@ -308,16 +278,12 @@ static int max14577_regulator_probe(struct platform_device *pdev)
 {
 	struct max14577 *max14577 = dev_get_drvdata(pdev->dev.parent);
 	struct max14577_platform_data *pdata = dev_get_platdata(max14577->dev);
-	int i, ret;
+	int i, ret = 0;
 	struct regulator_config config = {};
 	const struct regulator_desc *supported_regulators;
 	unsigned int supported_regulators_size;
 	enum maxim_device_type dev_type = max14577->dev_type;
 
-	ret = max14577_regulator_dt_parse_pdata(pdev, dev_type);
-	if (ret)
-		return ret;
-
 	switch (dev_type) {
 	case MAXIM_DEVICE_TYPE_MAX77836:
 		supported_regulators = max77836_supported_regulators;
@@ -329,7 +295,7 @@ static int max14577_regulator_probe(struct platform_device *pdev)
 		supported_regulators_size = ARRAY_SIZE(max14577_supported_regulators);
 	}
 
-	config.dev = &pdev->dev;
+	config.dev = max14577->dev;
 	config.driver_data = max14577;
 
 	for (i = 0; i < supported_regulators_size; i++) {
-- 
1.7.9.5

