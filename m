Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab3E3N31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:29:27 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:53799 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab3E3N2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:28:16 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Ola Lilja <ola.o.lilja@stericsson.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 2/5] ARM: ux500: Correct anamic2 typo in DT files
Date: Thu, 30 May 2013 15:27:42 +0200
Message-Id: <1369920465-13905-3-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1369920465-13905-1-git-send-email-fabio.baltieri@linaro.org>
References: <1369920465-13905-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typo of VAMIC2 LDO regulator name in some DT-related files.  This
patch replaces all occurrences with the right name.

Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi     | 4 ++--
 arch/arm/boot/dts/href.dtsi       | 2 +-
 arch/arm/boot/dts/hrefv60plus.dts | 2 +-
 arch/arm/boot/dts/snowball.dts    | 2 +-
 drivers/regulator/ab8500.c        | 8 ++++----
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index e6ea7ba..d0b6e32 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -466,8 +466,8 @@
 					};
 
 					// supply for v-amic2; VAMIC2 LDO; reuse constants for AMIC1
-					ab8500_ldo_amamic2_reg: ab8500_ldo_amamic2 {
-						regulator-compatible = "ab8500_ldo_amamic2";
+					ab8500_ldo_anamic2_reg: ab8500_ldo_anamic2 {
+						regulator-compatible = "ab8500_ldo_anamic2";
 					};
 
 					// supply for v-dmic; VDMIC LDO
diff --git a/arch/arm/boot/dts/href.dtsi b/arch/arm/boot/dts/href.dtsi
index c0bc426..4a53c48 100644
--- a/arch/arm/boot/dts/href.dtsi
+++ b/arch/arm/boot/dts/href.dtsi
@@ -256,7 +256,7 @@
 						regulator-name = "V-AMIC1";
 					};
 
-					ab8500_ldo_amamic2_reg: ab8500_ldo_amamic2 {
+					ab8500_ldo_anamic2_reg: ab8500_ldo_anamic2 {
 						regulator-name = "V-AMIC2";
 					};
 
diff --git a/arch/arm/boot/dts/hrefv60plus.dts b/arch/arm/boot/dts/hrefv60plus.dts
index 2b587a7..4f04af8 100644
--- a/arch/arm/boot/dts/hrefv60plus.dts
+++ b/arch/arm/boot/dts/hrefv60plus.dts
@@ -192,7 +192,7 @@
 						regulator-name = "V-AMIC1";
 					};
 
-					ab8500_ldo_amamic2_reg: ab8500_ldo_amamic2 {
+					ab8500_ldo_anamic2_reg: ab8500_ldo_anamic2 {
 						regulator-name = "V-AMIC2";
 					};
 
diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/snowball.dts
index db5db24..557d75e 100644
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@ -336,7 +336,7 @@
 						regulator-name = "V-AMIC1";
 					};
 
-					ab8500_ldo_amamic2_reg: ab8500_ldo_amamic2 {
+					ab8500_ldo_anamic2_reg: ab8500_ldo_anamic2 {
 						regulator-name = "V-AMIC2";
 					};
 
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index f6656b8..a19045e 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -2901,7 +2901,7 @@ static struct of_regulator_match ab8500_regulator_match[] = {
 	{ .name	= "ab8500_ldo_tvout",   .driver_data = (void *) AB8500_LDO_TVOUT, },
 	{ .name = "ab8500_ldo_audio",   .driver_data = (void *) AB8500_LDO_AUDIO, },
 	{ .name	= "ab8500_ldo_anamic1", .driver_data = (void *) AB8500_LDO_ANAMIC1, },
-	{ .name	= "ab8500_ldo_amamic2", .driver_data = (void *) AB8500_LDO_ANAMIC2, },
+	{ .name	= "ab8500_ldo_anamic2", .driver_data = (void *) AB8500_LDO_ANAMIC2, },
 	{ .name	= "ab8500_ldo_dmic",    .driver_data = (void *) AB8500_LDO_DMIC, },
 	{ .name	= "ab8500_ldo_ana",     .driver_data = (void *) AB8500_LDO_ANA, },
 };
@@ -2917,7 +2917,7 @@ static struct of_regulator_match ab8505_regulator_match[] = {
 	{ .name	= "ab8500_ldo_adc",	.driver_data = (void *) AB8505_LDO_ADC, },
 	{ .name = "ab8500_ldo_audio",   .driver_data = (void *) AB8505_LDO_AUDIO, },
 	{ .name	= "ab8500_ldo_anamic1", .driver_data = (void *) AB8505_LDO_ANAMIC1, },
-	{ .name	= "ab8500_ldo_amamic2", .driver_data = (void *) AB8505_LDO_ANAMIC2, },
+	{ .name	= "ab8500_ldo_anamic2", .driver_data = (void *) AB8505_LDO_ANAMIC2, },
 	{ .name	= "ab8500_ldo_aux8",    .driver_data = (void *) AB8505_LDO_AUX8, },
 	{ .name	= "ab8500_ldo_ana",     .driver_data = (void *) AB8505_LDO_ANA, },
 };
@@ -2933,7 +2933,7 @@ static struct of_regulator_match ab8540_regulator_match[] = {
 	{ .name	= "ab8500_ldo_tvout",   .driver_data = (void *) AB8540_LDO_TVOUT, },
 	{ .name = "ab8500_ldo_audio",   .driver_data = (void *) AB8540_LDO_AUDIO, },
 	{ .name	= "ab8500_ldo_anamic1", .driver_data = (void *) AB8540_LDO_ANAMIC1, },
-	{ .name	= "ab8500_ldo_amamic2", .driver_data = (void *) AB8540_LDO_ANAMIC2, },
+	{ .name	= "ab8500_ldo_anamic2", .driver_data = (void *) AB8540_LDO_ANAMIC2, },
 	{ .name	= "ab8500_ldo_dmic",    .driver_data = (void *) AB8540_LDO_DMIC, },
 	{ .name	= "ab8500_ldo_ana",     .driver_data = (void *) AB8540_LDO_ANA, },
 	{ .name = "ab8500_ldo_sdio",    .driver_data = (void *) AB8540_LDO_SDIO, },
@@ -2948,7 +2948,7 @@ static struct of_regulator_match ab9540_regulator_match[] = {
 	{ .name	= "ab8500_ldo_tvout",   .driver_data = (void *) AB9540_LDO_TVOUT, },
 	{ .name = "ab8500_ldo_audio",   .driver_data = (void *) AB9540_LDO_AUDIO, },
 	{ .name	= "ab8500_ldo_anamic1", .driver_data = (void *) AB9540_LDO_ANAMIC1, },
-	{ .name	= "ab8500_ldo_amamic2", .driver_data = (void *) AB9540_LDO_ANAMIC2, },
+	{ .name	= "ab8500_ldo_anamic2", .driver_data = (void *) AB9540_LDO_ANAMIC2, },
 	{ .name	= "ab8500_ldo_dmic",    .driver_data = (void *) AB9540_LDO_DMIC, },
 	{ .name	= "ab8500_ldo_ana",     .driver_data = (void *) AB9540_LDO_ANA, },
 };
-- 
1.8.2

