Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab3C1QQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 12:16:49 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:47585 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757000Ab3C1QMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 12:12:33 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 19/33] regulator: ab8500: Supply platform specific regulator id values
Date: Thu, 28 Mar 2013 16:11:19 +0000
Message-Id: <1364487093-19551-20-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regulator ID in the regulator info array should be the same
values as the position of the element within the array.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c |   62 ++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 9c3fc09..a5e204d 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -648,7 +648,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX1",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUX1,
+			.id		= AB8505_LDO_AUX1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
@@ -669,7 +669,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX2",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUX2,
+			.id		= AB8505_LDO_AUX2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
@@ -690,7 +690,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX3",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUX3,
+			.id		= AB8505_LDO_AUX3,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
 			.volt_table	= ldo_vaux3_voltages,
@@ -711,7 +711,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX4",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB9540_LDO_AUX4,
+			.id		= AB8505_LDO_AUX4,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
@@ -778,7 +778,7 @@ static struct ab8500_regulator_info
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
 			.volt_table	= ldo_vauxn_voltages,
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
@@ -1291,7 +1291,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-TVOUT",
 			.ops		= &ab8500_regulator_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_TVOUT,
+			.id		= AB8540_LDO_TVOUT,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 		},
@@ -1309,7 +1309,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUDIO",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUDIO,
+			.id		= AB8540_LDO_AUDIO,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2000000_voltage,
@@ -1324,7 +1324,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANAMIC1",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANAMIC1,
+			.id		= AB8540_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2050000_voltage,
@@ -1339,7 +1339,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANAMIC2",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANAMIC2,
+			.id		= AB8540_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2050000_voltage,
@@ -1354,7 +1354,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-DMIC",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_DMIC,
+			.id		= AB8540_LDO_DMIC,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 		},
@@ -1372,7 +1372,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANA",
 			.ops		= &ab8500_regulator_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANA,
+			.id		= AB8540_LDO_ANA,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table     = fixed_1200000_voltage,
-- 
1.7.10.4

