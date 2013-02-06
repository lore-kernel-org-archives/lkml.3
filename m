Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418Ab3BFLAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:00:24 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:54013 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365Ab3BFKzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:55:13 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 35/49] regulator: ab8500: Correct regulator id values
Date: Wed,  6 Feb 2013 10:53:57 +0000
Message-Id: <1360148051-7560-36-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator id in the regulator info array should be the same
values as the position of the element within the array. This
patch fixes the mismatches.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c |   62 ++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index e463668..1df809e 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -649,7 +649,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX1",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUX1,
+			.id		= AB8505_LDO_AUX1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
@@ -670,7 +670,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX2",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUX2,
+			.id		= AB8505_LDO_AUX2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
@@ -691,7 +691,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX3",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUX3,
+			.id		= AB8505_LDO_AUX3,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
 			.volt_table	= ldo_vaux3_voltages,
@@ -712,7 +712,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX4",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB9540_LDO_AUX4,
+			.id		= AB8505_LDO_AUX4,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
@@ -779,7 +779,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-INTCORE",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_INTCORE,
+			.id		= AB8505_LDO_INTCORE,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
 			.volt_table	= ldo_vintcore_voltages,
@@ -825,7 +825,7 @@ static struct ab8500_regulator_info
 			.name           = "LDO-USB",
 			.ops            = &ab8500_regulator_mode_ops,
 			.type           = REGULATOR_VOLTAGE,
-			.id             = AB9540_LDO_USB,
+			.id             = AB8505_LDO_USB,
 			.owner          = THIS_MODULE,
 			.n_voltages     = 1,
 			.volt_table	= fixed_3300000_voltage,
@@ -842,7 +842,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUDIO",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUDIO,
+			.id		= AB8505_LDO_AUDIO,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2000000_voltage,
@@ -857,7 +857,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANAMIC1",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANAMIC1,
+			.id		= AB8505_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2050000_voltage,
@@ -872,7 +872,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANAMIC2",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANAMIC2,
+			.id		= AB8505_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2050000_voltage,
@@ -905,7 +905,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANA",
 			.ops		= &ab8500_regulator_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANA,
+			.id		= AB8505_LDO_ANA,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_1200000_voltage,
@@ -934,7 +934,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX1",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUX1,
+			.id		= AB9540_LDO_AUX1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
@@ -955,7 +955,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX2",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUX2,
+			.id		= AB9540_LDO_AUX2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
@@ -976,7 +976,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX3",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUX3,
+			.id		= AB9540_LDO_AUX3,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
 			.volt_table	= ldo_vaux3_voltages,
@@ -1020,7 +1020,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-INTCORE",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_INTCORE,
+			.id		= AB9540_LDO_INTCORE,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
 			.volt_table	= ldo_vintcore_voltages,
@@ -1047,7 +1047,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-TVOUT",
 			.ops		= &ab8500_regulator_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_TVOUT,
+			.id		= AB9540_LDO_TVOUT,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2000000_voltage,
@@ -1083,7 +1083,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUDIO",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUDIO,
+			.id		= AB9540_LDO_AUDIO,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2000000_voltage,
@@ -1098,7 +1098,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANAMIC1",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANAMIC1,
+			.id		= AB9540_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2050000_voltage,
@@ -1113,7 +1113,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANAMIC2",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANAMIC2,
+			.id		= AB9540_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2050000_voltage,
@@ -1128,7 +1128,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-DMIC",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_DMIC,
+			.id		= AB9540_LDO_DMIC,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_1800000_voltage,
@@ -1147,7 +1147,7 @@ static struct ab8500_regulator_info
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
 			.name		= "LDO-AUDIO",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUDIO,
+			.id		= AB8540_LDO_AUDIO,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 		},
@@ -1322,7 +1322,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANAMIC1",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANAMIC1,
+			.id		= AB8540_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 		},
@@ -1336,7 +1336,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANAMIC2",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANAMIC2,
+			.id		= AB8540_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 		},
@@ -1350,7 +1350,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-DMIC",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_DMIC,
+			.id		= AB8540_LDO_DMIC,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 		},
@@ -1368,7 +1368,7 @@ static struct ab8500_regulator_info
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

