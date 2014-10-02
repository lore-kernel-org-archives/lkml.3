Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaJBImn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 04:42:43 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:47266 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbaJBIkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 04:40:39 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-gpio@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/7] pinctrl: abx500: force-convert to generic config bindings
Date: Thu,  2 Oct 2014 10:40:17 +0200
Message-Id: <1412239220-22495-5-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412239220-22495-1-git-send-email-linus.walleij@linaro.org>
References: <1412239220-22495-1-git-send-email-linus.walleij@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the ABx500 pin controller and all associated device
trees to use the standard, generic config bindings for pin controllers.
There are no such device trees deployed in the wild so this is
safe to do to set a good example.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/boot/dts/ste-href-ab8500.dtsi   | 54 ++++++++++++++++----------------
 arch/arm/boot/dts/ste-href-ab8505.dtsi   | 30 +++++++++---------
 drivers/pinctrl/nomadik/pinctrl-abx500.c |  4 +--
 3 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/arch/arm/boot/dts/ste-href-ab8500.dtsi b/arch/arm/boot/dts/ste-href-ab8500.dtsi
index 8be3c471d097..9b69bce9297d 100644
--- a/arch/arm/boot/dts/ste-href-ab8500.dtsi
+++ b/arch/arm/boot/dts/ste-href-ab8500.dtsi
@@ -51,7 +51,7 @@
 								groups = "gpio2_a_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO2_T9";
+								pins = "GPIO2_T9";
 								input-enable;
 								bias-pull-down;
 							};
@@ -64,7 +64,7 @@
 								groups = "gpio4_a_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO4_W2";
+								pins = "GPIO4_W2";
 								input-enable;
 								bias-pull-down;
 							};
@@ -77,7 +77,7 @@
 								groups = "gpio10_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO10_U17";
+								pins = "GPIO10_U17";
 								input-enable;
 								bias-pull-down;
 							};
@@ -90,7 +90,7 @@
 								groups = "gpio11_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO11_AA18";
+								pins = "GPIO11_AA18";
 								input-enable;
 								bias-pull-down;
 							};
@@ -103,7 +103,7 @@
 								groups = "gpio12_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO12_U16";
+								pins = "GPIO12_U16";
 								input-enable;
 								bias-pull-down;
 							};
@@ -116,7 +116,7 @@
 								groups = "gpio13_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO13_W17";
+								pins = "GPIO13_W17";
 								input-enable;
 								bias-pull-down;
 							};
@@ -129,7 +129,7 @@
 								groups = "gpio16_a_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO16_F15";
+								pins = "GPIO16_F15";
 								input-enable;
 								bias-pull-down;
 							};
@@ -142,7 +142,7 @@
 								groups = "gpio24_a_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO24_T14";
+								pins = "GPIO24_T14";
 								input-enable;
 								bias-pull-down;
 							};
@@ -155,7 +155,7 @@
 								groups = "gpio25_a_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO25_R16";
+								pins = "GPIO25_R16";
 								input-enable;
 								bias-pull-down;
 							};
@@ -168,7 +168,7 @@
 								groups = "gpio36_a_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO36_A17";
+								pins = "GPIO36_A17";
 								input-enable;
 								bias-pull-down;
 							};
@@ -181,7 +181,7 @@
 								groups = "gpio37_a_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO37_E15";
+								pins = "GPIO37_E15";
 								input-enable;
 								bias-pull-down;
 							};
@@ -194,7 +194,7 @@
 								groups = "gpio38_a_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO38_C17";
+								pins = "GPIO38_C17";
 								input-enable;
 								bias-pull-down;
 							};
@@ -207,7 +207,7 @@
 								groups = "gpio39_a_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO39_E16";
+								pins = "GPIO39_E16";
 								input-enable;
 								bias-pull-down;
 							};
@@ -220,7 +220,7 @@
 								groups = "gpio42_a_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO42_U2";
+								pins = "GPIO42_U2";
 								input-enable;
 								bias-pull-down;
 							};
@@ -236,7 +236,7 @@
 								groups = "gpio26_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO26_M16";
+								pins = "GPIO26_M16";
 								output-low;
 							};
 						};
@@ -248,7 +248,7 @@
 								groups = "gpio35_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO35_W15";
+								pins = "GPIO35_W15";
 								output-low;
 							};
 						};
@@ -264,7 +264,7 @@
 								groups = "ycbcr0123_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO6_Y18",
+								pins = "GPIO6_Y18",
 									 "GPIO7_AA20",
 									 "GPIO8_W18",
 									 "GPIO9_AA19";
@@ -281,7 +281,7 @@
 								groups = "pwmout1_d_1", "pwmout2_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO14_F14",
+								pins = "GPIO14_F14",
 									 "GPIO15_B17";
 								input-enable;
 								bias-pull-down;
@@ -296,7 +296,7 @@
 								groups = "adi1_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO17_P5",
+								pins = "GPIO17_P5",
 									 "GPIO18_R5",
 									 "GPIO19_U5",
 									 "GPIO20_T5";
@@ -313,7 +313,7 @@
 								groups = "usbuicc_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO21_H19",
+								pins = "GPIO21_H19",
 									 "GPIO22_G20",
 									 "GPIO23_G19";
 								input-enable;
@@ -331,7 +331,7 @@
 									 "dmic56_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO27_J6",
+								pins = "GPIO27_J6",
 									 "GPIO28_K6",
 									 "GPIO29_G6",
 									 "GPIO30_H6",
@@ -349,7 +349,7 @@
 								groups = "extcpena_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO34_R17";
+								pins = "GPIO34_R17";
 								input-enable;
 								bias-pull-down;
 							};
@@ -363,7 +363,7 @@
 								groups = "modsclsda_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO40_T19",
+								pins = "GPIO40_T19",
 									"GPIO41_U19";
 								input-enable;
 								bias-pull-down;
@@ -380,7 +380,7 @@
 								groups = "sysclkreq2_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO1_T10";
+								pins = "GPIO1_T10";
 								input-enable;
 								bias-disable;
 							};
@@ -391,7 +391,7 @@
 								groups = "gpio1_a_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO1_T10";
+								pins = "GPIO1_T10";
 								input-enable;
 								bias-pull-down;
 							};
@@ -404,7 +404,7 @@
 								groups = "sysclkreq4_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO3_U9";
+								pins = "GPIO3_U9";
 								input-enable;
 								bias-disable;
 							};
@@ -415,7 +415,7 @@
 								groups = "gpio3_a_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO3_U9";
+								pins = "GPIO3_U9";
 								input-enable;
 								bias-pull-down;
 							};
diff --git a/arch/arm/boot/dts/ste-href-ab8505.dtsi b/arch/arm/boot/dts/ste-href-ab8505.dtsi
index 112053c7aa51..ccf37a9df050 100644
--- a/arch/arm/boot/dts/ste-href-ab8505.dtsi
+++ b/arch/arm/boot/dts/ste-href-ab8505.dtsi
@@ -39,7 +39,7 @@
 								groups = "gpio2_a_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO2_R5";
+								pins = "GPIO2_R5";
 								input-enable;
 								bias-pull-down;
 							};
@@ -52,7 +52,7 @@
 								groups = "gpio10_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO10_B16";
+								pins = "GPIO10_B16";
 								input-enable;
 								bias-pull-down;
 							};
@@ -65,7 +65,7 @@
 								groups = "gpio11_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO11_B17";
+								pins = "GPIO11_B17";
 								input-enable;
 								bias-pull-down;
 							};
@@ -78,7 +78,7 @@
 								groups = "gpio13_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO13_D17";
+								pins = "GPIO13_D17";
 								input-enable;
 								bias-disable;
 							};
@@ -91,7 +91,7 @@
 								groups = "gpio34_a_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO34_H14";
+								pins = "GPIO34_H14";
 								input-enable;
 								bias-pull-down;
 							};
@@ -104,7 +104,7 @@
 								groups = "gpio50_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO50_L4";
+								pins = "GPIO50_L4";
 								input-enable;
 								bias-disable;
 							};
@@ -118,7 +118,7 @@
 								groups = "pwmout1_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO14_C16";
+								pins = "GPIO14_C16";
 								input-enable;
 								bias-pull-down;
 							};
@@ -132,7 +132,7 @@
 								groups = "adi2_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO17_P2",
+								pins = "GPIO17_P2",
 									 "GPIO18_N3",
 									 "GPIO19_T1",
 									 "GPIO20_P3";
@@ -149,7 +149,7 @@
 								groups = "modsclsda_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO40_J15",
+								pins = "GPIO40_J15",
 									"GPIO41_J14";
 								input-enable;
 								bias-pull-down;
@@ -163,7 +163,7 @@
 								groups = "resethw_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO52_D16";
+								pins = "GPIO52_D16";
 								input-enable;
 								bias-pull-down;
 							};
@@ -176,7 +176,7 @@
 								groups = "service_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO53_D15";
+								pins = "GPIO53_D15";
 								input-enable;
 								bias-pull-down;
 							};
@@ -192,7 +192,7 @@
 								groups = "sysclkreq2_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO1_N4";
+								pins = "GPIO1_N4";
 								input-enable;
 								bias-disable;
 							};
@@ -203,7 +203,7 @@
 								groups = "gpio1_a_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO1_N4";
+								pins = "GPIO1_N4";
 								input-enable;
 								bias-pull-down;
 							};
@@ -216,7 +216,7 @@
 								groups = "sysclkreq4_d_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO3_P5";
+								pins = "GPIO3_P5";
 								input-enable;
 								bias-disable;
 							};
@@ -227,7 +227,7 @@
 								groups = "gpio3_a_1";
 							};
 							default_cfg {
-								ste,pins = "GPIO3_P5";
+								pins = "GPIO3_P5";
 								input-enable;
 								bias-pull-down;
 							};
diff --git a/drivers/pinctrl/nomadik/pinctrl-abx500.c b/drivers/pinctrl/nomadik/pinctrl-abx500.c
index debeffcc2134..93ded6e0e21a 100644
--- a/drivers/pinctrl/nomadik/pinctrl-abx500.c
+++ b/drivers/pinctrl/nomadik/pinctrl-abx500.c
@@ -932,7 +932,7 @@ static int abx500_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		const char *gpio_name;
 		const char *pin;
 
-		ret = of_property_count_strings(np, "ste,pins");
+		ret = of_property_count_strings(np, "pins");
 		if (ret < 0)
 			goto exit;
 
@@ -942,7 +942,7 @@ static int abx500_dt_subnode_to_map(struct pinctrl_dev *pctldev,
 		if (ret < 0)
 			goto exit;
 
-		of_property_for_each_string(np, "ste,pins", prop, pin) {
+		of_property_for_each_string(np, "pins", prop, pin) {
 			gpio_name = abx500_find_pin_name(pctldev, pin);
 
 			ret = abx500_dt_add_map_configs(map, reserved_maps,
-- 
1.9.3

