Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934107Ab3CUQGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:06:13 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:44915 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab3CUQBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:01:04 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 30/46] regulator: ab8500: Supply platform specific regulator id values
Date: Thu, 21 Mar 2013 15:59:27 +0000
Message-Id: <1363881583-15234-31-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
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
index 22bac57..840f23b 100644
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
@@ -826,7 +826,7 @@ static struct ab8500_regulator_info
 			.name           = "LDO-USB",
 			.ops            = &ab8500_regulator_mode_ops,
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
@@ -1049,7 +1049,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-TVOUT",
 			.ops		= &ab8500_regulator_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_TVOUT,
+			.id		= AB9540_LDO_TVOUT,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2000000_voltage,
@@ -1085,7 +1085,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUDIO",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUDIO,
+			.id		= AB9540_LDO_AUDIO,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2000000_voltage,
@@ -1100,7 +1100,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANAMIC1",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANAMIC1,
+			.id		= AB9540_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2050000_voltage,
@@ -1115,7 +1115,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANAMIC2",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANAMIC2,
+			.id		= AB9540_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2050000_voltage,
@@ -1130,7 +1130,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-DMIC",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_DMIC,
+			.id		= AB9540_LDO_DMIC,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_1800000_voltage,
@@ -1149,7 +1149,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANA",
 			.ops		= &ab8500_regulator_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANA,
+			.id		= AB9540_LDO_ANA,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_1200000_voltage,
@@ -1178,7 +1178,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX1",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUX1,
+			.id		= AB8540_LDO_AUX1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
@@ -1199,7 +1199,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX2",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUX2,
+			.id		= AB8540_LDO_AUX2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
@@ -1220,7 +1220,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX3",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUX3,
+			.id		= AB8540_LDO_AUX3,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vaux3_ab8540_voltages),
 			.volt_table	= ldo_vaux3_ab8540_voltages,
@@ -1241,7 +1241,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUX4",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB9540_LDO_AUX4,
+			.id		= AB8540_LDO_AUX4,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
 			.volt_table	= ldo_vauxn_voltages,
@@ -1264,7 +1264,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-INTCORE",
 			.ops		= &ab8500_regulator_volt_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_INTCORE,
+			.id		= AB8540_LDO_INTCORE,
 			.owner		= THIS_MODULE,
 			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
 			.volt_table	= ldo_vintcore_voltages,
@@ -1292,7 +1292,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-TVOUT",
 			.ops		= &ab8500_regulator_mode_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_TVOUT,
+			.id		= AB8540_LDO_TVOUT,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 		},
@@ -1310,7 +1310,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-AUDIO",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_AUDIO,
+			.id		= AB8540_LDO_AUDIO,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2000000_voltage,
@@ -1325,7 +1325,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANAMIC1",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANAMIC1,
+			.id		= AB8540_LDO_ANAMIC1,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2050000_voltage,
@@ -1340,7 +1340,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-ANAMIC2",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_ANAMIC2,
+			.id		= AB8540_LDO_ANAMIC2,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 			.volt_table	= fixed_2050000_voltage,
@@ -1355,7 +1355,7 @@ static struct ab8500_regulator_info
 			.name		= "LDO-DMIC",
 			.ops		= &ab8500_regulator_ops,
 			.type		= REGULATOR_VOLTAGE,
-			.id		= AB8500_LDO_DMIC,
+			.id		= AB8540_LDO_DMIC,
 			.owner		= THIS_MODULE,
 			.n_voltages	= 1,
 		},
@@ -1373,7 +1373,7 @@ static struct ab8500_regulator_info
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

