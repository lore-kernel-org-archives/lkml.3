Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaLRLNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 06:13:42 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:62199 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaLRLNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 06:13:39 -0500
X-AuditID: cbfee68e-f79b46d000002b74-d1-5492b6e181d6
From: Beomho Seo <beomho.seo@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: lgirdwood@gmail.com, broonie@kernel.org, beomho.seo@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com
Subject: [PATCH] regulator: rt5033-regulator: Use regulator_nodes/of_match in
 the descriptor
Date: Thu, 18 Dec 2014 20:13:36 +0900
Message-id: <1418901216-19030-1-git-send-email-beomho.seo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsWyRsSkQPfhtkkhBp9fSluc/rSN3WLqwyds
	Fte/PGe1mHR/AovFtysdTBaXd81hs/jce4TRYsbkl2wOHB47Z91l99i0qpPNo2/LKkaPz5vk
	AliiuGxSUnMyy1KL9O0SuDJmPEgveMJXcXv7SfYGxn6eLkZODgkBE4kbG/uZIGwxiQv31rN1
	MXJxCAksZZToOfuVHaboy4efUIlFjBIPX+xmhnDamCRunlsL1s4moCnxfsoVFhBbRMBK4kX7
	K3aQImaBLkaJef2XwYqEBeIkDp/eCTaWRUBVYnXTUzCbV8BN4tG/xaxdjBxA6xQk5kyyAemV
	EPjPJtG18T4jRL2AxLfJh1ggamQlNh1ghrhOUuLgihssExgFFzAyrGIUTS1ILihOSi8y0itO
	zC0uzUvXS87P3cQIDNvT/5717WC8ecD6EKMAB6MSD6+E3qQQIdbEsuLK3EOMpkAbJjJLiSbn
	A6MjryTe0NjMyMLUxNTYyNzSTEmcN0HqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRl6e
	usVv+i91PHFoiXfIe2eWk/DPPTj1cP3Ve7Kz0pjuLz9QkFDjJv/E3LvoGb+81ZU53WvZph2b
	8T9pt0NZsSjT0u4z60/8eXMg30XH8Blrc13+9svHA3a+72LZXHFA96Rh6Vu9mMeMK15PePGX
	X4Ojb+qxWx/lde2SEh7eOWvylN9tR77ydCWW4oxEQy3mouJEAInfcPxWAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42I5/e+xgO7DbZNCDN6cE7Y4/Wkbu8XUh0/Y
	LK5/ec5qMen+BBaLb1c6mCwu75rDZvG59wijxYzJL9kcODx2zrrL7rFpVSebR9+WVYwenzfJ
	BbBENTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDd
	oaRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMmPEgveAJX8Xt7SfZGxj7
	eboYOTkkBEwkvnz4yQZhi0lcuLceyObiEBJYxCjx8MVuZginjUni5rm1TCBVbAKaEu+nXGEB
	sUUErCRetL9iByliFuhilJjXfxmsSFggTuLw6Z3sIDaLgKrE6qanYDavgJvEo3+LWbsYOYDW
	KUjMmWQzgZF7ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgqHgmtYNxZYPFIUYBDkYl
	Hl4JvUkhQqyJZcWVuYcYJTiYlUR4o3OAQrwpiZVVqUX58UWlOanFhxhNgZZPZJYSTc4HRmxe
	SbyhsYmZkaWRuaGFkbG5kjivkn1biJBAemJJanZqakFqEUwfEwenVAPjTh0pJqlJR+O+7zrF
	PPl96sr7mUwTDE15VQvVnksySBd2LJ/ZWs2ex/SwctEOJ+knTDJXZWqfpmnw1U6YrRGudf/W
	q77ey0wXlzQYvN93VtU6mcvp/udGg2l2MpJJDMKn4netFf4Z4LuG8yRH2g/XnU8+rTwn1vA7
	eLmewN8nD2svCrwr3q6uxFKckWioxVxUnAgAtSPNyqACAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is add regulator_nodes/of_match in the regulator descriptor
for using information from DT instead of sppecific codes.

Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Beomho Seo <beomho.seo@samsung.com>
---
 drivers/regulator/rt5033-regulator.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/rt5033-regulator.c b/drivers/regulator/rt5033-regulator.c
index 870cc49..96d2c18 100644
--- a/drivers/regulator/rt5033-regulator.c
+++ b/drivers/regulator/rt5033-regulator.c
@@ -36,6 +36,8 @@ static struct regulator_ops rt5033_buck_ops = {
 static const struct regulator_desc rt5033_supported_regulators[] = {
 	[RT5033_BUCK] = {
 		.name		= "BUCK",
+		.of_match	= of_match_ptr("BUCK"),
+		.regulators_node = of_match_ptr("regulators"),
 		.id		= RT5033_BUCK,
 		.ops		= &rt5033_buck_ops,
 		.type		= REGULATOR_VOLTAGE,
@@ -50,6 +52,8 @@ static const struct regulator_desc rt5033_supported_regulators[] = {
 	},
 	[RT5033_LDO] = {
 		.name		= "LDO",
+		.of_match	= of_match_ptr("LDO"),
+		.regulators_node = of_match_ptr("regulators"),
 		.id		= RT5033_LDO,
 		.ops		= &rt5033_buck_ops,
 		.type		= REGULATOR_VOLTAGE,
@@ -64,6 +68,8 @@ static const struct regulator_desc rt5033_supported_regulators[] = {
 	},
 	[RT5033_SAFE_LDO] = {
 		.name		= "SAFE_LDO",
+		.of_match	= of_match_ptr("SAFE_LDO"),
+		.regulators_node = of_match_ptr("regulators"),
 		.id		= RT5033_SAFE_LDO,
 		.ops		= &rt5033_safe_ldo_ops,
 		.type		= REGULATOR_VOLTAGE,
@@ -81,7 +87,7 @@ static int rt5033_regulator_probe(struct platform_device *pdev)
 	int ret, i;
 	struct regulator_config config = {};
 
-	config.dev = &pdev->dev;
+	config.dev = rt5033->dev;
 	config.driver_data = rt5033;
 
 	for (i = 0; i < ARRAY_SIZE(rt5033_supported_regulators); i++) {
-- 
1.7.9.5

