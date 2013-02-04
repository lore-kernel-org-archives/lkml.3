Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab3BDL51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:57:27 -0500
Received: from mail-we0-f179.google.com ([74.125.82.179]:48399 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063Ab3BDL5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:57:25 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>,
        Marcus Cooper <marcus.xm.cooper@stericsson.com>
Subject: [PATCH 50/73] regulator: ab8500: Correct regulator id values
Date: Mon,  4 Feb 2013 11:54:05 +0000
Message-Id: <1359978868-28736-51-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
References: <1359978868-28736-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator id in the regulator info array should be the same
values as the position of the element within the array. This
patch fixes the mismatches.

Signed-off-by: Marcus Cooper <marcus.xm.cooper@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Jonas ABERG <jonas.aberg@stericsson.com>
Reviewed-by: Mattias WALLIN <mattias.wallin@stericsson.com>
---
 drivers/regulator/ab8500.c |   66 ++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index b09b507..7089a38 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -650,7 +650,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX1",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUX1,
+			.id		= AB8505_LDO_AUX1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
@@ -671,7 +671,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX2",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUX2,
+			.id		= AB8505_LDO_AUX2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
@@ -692,7 +692,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX3",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUX3,
+			.id		= AB8505_LDO_AUX3,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
 			.volt_table	= ldo_vaux3_voltages,
@@ -713,7 +713,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX4",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB9540_LDO_AUX4,
+			.id		= AB8505_LDO_AUX4,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
@@ -780,7 +780,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-INTCORE",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_INTCORE,
+			.id		= AB8505_LDO_INTCORE,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
 			.volt_table	= ldo_vintcore_voltages,
@@ -826,7 +826,7 @@ static struct ab8500_regulator_info
 			.name           = "LDO-USB",
 			.ops            = &ab8500_regulator_ops,
 			.type           = REGULATOR_VOLTAGE,
-			.id             = AB9540_LDO_USB,
+			.id             = AB8505_LDO_USB,
 			.owner          = THIS_MODULE,
 			.n_voltages     = 1,
 			.volt_table	= fixed_3300000_voltage,
@@ -843,7 +843,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUDIO",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUDIO,
+			.id		= AB8505_LDO_AUDIO,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2000000_voltage,
@@ -858,7 +858,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANAMIC1",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANAMIC1,
+			.id		= AB8505_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2050000_voltage,
@@ -873,7 +873,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANAMIC2",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANAMIC2,
+			.id		= AB8505_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2050000_voltage,
@@ -888,7 +888,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-DMIC",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_DMIC,
+			.id		= AB8505_LDO_DMIC,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_1800000_voltage,
@@ -906,7 +906,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANA",
 			.ops		= &ab8500_regulator_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANA,
+			.id		= AB8505_LDO_ANA,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_1200000_voltage,
@@ -935,7 +935,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX1",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUX1,
+			.id		= AB9540_LDO_AUX1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
@@ -956,7 +956,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX2",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUX2,
+			.id		= AB9540_LDO_AUX2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
@@ -977,7 +977,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX3",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUX3,
+			.id		= AB9540_LDO_AUX3,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
 			.volt_table	= ldo_vaux3_voltages,
@@ -1021,7 +1021,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-INTCORE",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_INTCORE,
+			.id		= AB9540_LDO_INTCORE,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
 			.volt_table	= ldo_vintcore_voltages,
@@ -1048,7 +1048,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-TVOUT",
 			.ops		= &ab8500_regulator_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_TVOUT,
+			.id		= AB9540_LDO_TVOUT,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2000000_voltage,
@@ -1084,7 +1084,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUDIO",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUDIO,
+			.id		= AB9540_LDO_AUDIO,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2000000_voltage,
@@ -1099,7 +1099,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANAMIC1",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANAMIC1,
+			.id		= AB9540_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2050000_voltage,
@@ -1114,7 +1114,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANAMIC2",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANAMIC2,
+			.id		= AB9540_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2050000_voltage,
@@ -1129,7 +1129,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-DMIC",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_DMIC,
+			.id		= AB9540_LDO_DMIC,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_1800000_voltage,
@@ -1148,7 +1148,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANA",
 			.ops		= &ab8500_regulator_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANA,
+			.id		= AB9540_LDO_ANA,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_1200000_voltage,
@@ -1177,7 +1177,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX1",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUX1,
+			.id		= AB8540_LDO_AUX1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table     = ldo_vauxn_voltages,
@@ -1198,7 +1198,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX2",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUX2,
+			.id		= AB8540_LDO_AUX2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
@@ -1219,7 +1219,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX3",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUX3,
+			.id		= AB8540_LDO_AUX3,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_ab8540_voltages),
 			.volt_table	= ldo_vaux3_ab8540_voltages,
@@ -1240,7 +1240,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX4",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB9540_LDO_AUX4,
+			.id		= AB8540_LDO_AUX4,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
@@ -1263,7 +1263,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-INTCORE",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_INTCORE,
+			.id		= AB8540_LDO_INTCORE,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
 			.volt_table	= ldo_vintcore_voltages,
@@ -1290,7 +1290,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-TVOUT",
 			.ops		= &ab8500_regulator_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_TVOUT,
+			.id		= AB8540_LDO_TVOUT,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 		},
@@ -1308,7 +1308,7 @@ static struct ab8500_regulator_info
 			.name           = "LDO-USB",
 			.ops            = &ab8500_regulator_ops,
 			.type           = REGULATOR_VOLTAGE,
-			.id             = AB9540_LDO_USB,
+			.id             = AB8540_LDO_USB,
 			.owner          = THIS_MODULE,
 			.n_voltages     = 1,
 		},
@@ -1325,7 +1325,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUDIO",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUDIO,
+			.id		= AB8540_LDO_AUDIO,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 		},
@@ -1339,7 +1339,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANAMIC1",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANAMIC1,
+			.id		= AB8540_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 		},
@@ -1353,7 +1353,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANAMIC2",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANAMIC2,
+			.id		= AB8540_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 		},
@@ -1367,7 +1367,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-DMIC",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_DMIC,
+			.id		= AB8540_LDO_DMIC,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 		},
@@ -1385,7 +1385,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANA",
 			.ops		= &ab8500_regulator_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANA,
+			.id		= AB8540_LDO_ANA,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 		},
-- 
1.7.9.5

