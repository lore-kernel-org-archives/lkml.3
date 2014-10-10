Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaJJLgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 07:36:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56311 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbaJJLfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 07:35:45 -0400
X-AuditID: cbfee691-f79b86d000004a5a-26-5437c48cc887
From: Chanwoo Choi <cw00.choi@samsung.com>
To: broonie@kernel.org
Cc: lgirdwood@gmail.com, grant.likely@linaro.org, robh+dt@kernel.org,
        kyungmin.park@samsung.com, javier@dowhile0.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCHv5 3/3] ARM: dts: Add sleep mode of regulator for
 exynos3250-rinato board
Date: Fri, 10 Oct 2014 20:35:35 +0900
Message-id: <1412940935-14721-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1412940935-14721-1-git-send-email-cw00.choi@samsung.com>
References: <1412940935-14721-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsWyRsSkWLfniHmIwZQNnBZTHz5hs7j+5Tmr
	xfwj51gtDvzZwWhx7fcMNoveBVfZLM42vWG3+Halg8ni8q45bBate4+wO3B5/J3dyuyxc9Zd
	do9NqzrZPO5c28Pm0bdlFaPH501yAWxRXDYpqTmZZalF+nYJXBkdfRtYC+6ZV5y6+py1gfGh
	RhcjJ4eEgInE9bnXmSFsMYkL99azdTFycQgJLGWUOHB2MztM0eLTzUwgtpDAIkaJyxvKIIqa
	mCQ+Pr4J1s0moCWx/8UNNhBbBGjS7TmdzCBFzAL/GCUerj8HViQsECVxf/pfsCIWAVWJJ4cf
	gW3gFXCV+PZkOxvENjmJD3sg4pwCbhJzpjYwQmx2lVj68RgLyFAJgU3sEvf+d0ANEpD4NvkQ
	UIIDKCErsekA1DuSEgdX3GCZwCi8gJFhFaNoakFyQXFSepGpXnFibnFpXrpecn7uJkZgRJz+
	92ziDsb7B6wPMQpwMCrx8F6QMQ8RYk0sK67MPcRoCrRhIrOUaHI+MO7ySuINjc2MLExNTI2N
	zC3NlMR5daR/BgsJpCeWpGanphakFsUXleakFh9iZOLglGpgFG/0+P3x/bakDUmzXP7qqaY/
	nvQ5KPKm4jSzsxOj32pP69l2wa93c/muQNlInfTOYzErP3Lvn/avvk16hlRRZFCmlLDJIqf2
	d++CeTZF561s/uq9+6V77KKVupXGa5Y0H9e6wlFawrCTNe17iGHdql33Zjqy/9vfcU1vfpbu
	Wn/uZ99nHclcocRSnJFoqMVcVJwIAI+MJ4CDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t9jAd2eI+YhBvMMLKY+fMJmcf3Lc1aL
	+UfOsVoc+LOD0eLa7xlsFr0LrrJZnG16w27x7UoHk8XlXXPYLFr3HmF34PL4O7uV2WPnrLvs
	HptWdbJ53Lm2h82jb8sqRo/Pm+QC2KIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUN
	LS3MlRTyEnNTbZVcfAJ03TJzgE5TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SA
	BhLWMGZ09G1gLbhnXnHq6nPWBsaHGl2MnBwSAiYSi083M0HYYhIX7q1nA7GFBBYxSlzeUNbF
	yAVkNzFJfHx8kxkkwSagJbH/xQ2wIhGghttzOplBipgF/jFKPFx/DqxIWCBK4v70v2BFLAKq
	Ek8OP2IHsXkFXCW+PdnOBrFNTuLDHog4p4CbxJypDYwQm10lln48xjKBkXcBI8MqRtHUguSC
	4qT0XEO94sTc4tK8dL3k/NxNjOBoeya1g3Flg8UhRgEORiUe3gsy5iFCrIllxZW5hxglOJiV
	RHjn7wUK8aYkVlalFuXHF5XmpBYfYjQFumois5Rocj4wEeSVxBsam5gZWRqZG1oYGZsrifMe
	aLUOFBJITyxJzU5NLUgtgulj4uCUamA8t9Xojpq58lLGi18/n51yPv24sbbgk8NLDl088Lnd
	NqXi8o33LlPcmN7sTVPJMbrnW7N+vXnEWYMTJkq31DPbXIqjihIN/Nuerv6c92Wi6zqvgorN
	97Y48nn9fMq2Y8VlvYDmf+sFOBKE1Vg2/Di23/2Kl6wbQ9x/x6BCm47Fald/HOdS4eNRYinO
	SDTUYi4qTgQASr10/8wCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add sleep mode of regulator for exynos3250-rinato board to optimize
power-consumption in sleep state.

The power-consumption in suspend state is 0.6mA after applied this patch.

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250-rinato.dts | 108 ++++++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 63861e7..002e396 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -166,6 +166,10 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-on-in-suspend;
+				};
 			};
 
 			ldo2_reg: LDO2 {
@@ -173,6 +177,10 @@
 				regulator-min-microvolt = <1200000>;
 				regulator-max-microvolt = <1200000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo3_reg: LDO3 {
@@ -180,6 +188,10 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo4_reg: LDO4 {
@@ -187,6 +199,10 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo5_reg: LDO5 {
@@ -194,12 +210,20 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo6_reg: LDO6 {
 				regulator-name = "VAP_VMIPI_1.0V";
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo7_reg: LDO7 {
@@ -207,6 +231,10 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo8_reg: LDO8 {
@@ -214,6 +242,10 @@
 				regulator-min-microvolt = <3000000>;
 				regulator-max-microvolt = <3000000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo9_reg: LDO9 {
@@ -221,12 +253,20 @@
 				regulator-min-microvolt = <1200000>;
 				regulator-max-microvolt = <1200000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-on-in-suspend;
+				};
 			};
 
 			ldo10_reg: LDO10 {
 				regulator-name = "UNUSED_LDO10";
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo11_reg: LDO11 {
@@ -247,60 +287,100 @@
 				regulator-name = "CAM_AVDD_2.8V";
 				regulator-min-microvolt = <2800000>;
 				regulator-max-microvolt = <2800000>;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo14_reg: LDO14 {
 				regulator-name = "UNUSED_LDO14";
 				regulator-min-microvolt = <2700000>;
 				regulator-max-microvolt = <2700000>;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo15_reg: LDO15 {
 				regulator-name = "TSP_AVDD_3.3V";
 				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo16_reg: LDO16 {
 				regulator-name = "LCD_VDD_3.3V";
 				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo17_reg: LDO17 {
 				regulator-name = "V_IRLED_3.3V";
 				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo18_reg: LDO18 {
 				regulator-name = "CAM_AF_2.8V";
 				regulator-min-microvolt = <2800000>;
 				regulator-max-microvolt = <2800000>;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo19_reg: LDO19 {
 				regulator-name = "TSP_VDD_1.8V";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo20_reg: LDO20 {
 				regulator-name = "LCD_VDD_1.8V";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo21_reg: LDO21 {
 				regulator-name = "CAM_IO_1.8V";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo22_reg: LDO22 {
 				regulator-name = "CAM_DVDD_1.2V";
 				regulator-min-microvolt = <1200000>;
 				regulator-max-microvolt = <1200000>;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo23_reg: LDO23 {
@@ -314,12 +394,20 @@
 				regulator-name = "HRM_VCC_3.3V";
 				regulator-min-microvolt = <3000000>;
 				regulator-max-microvolt = <3000000>;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo25_reg: LDO25 {
 				regulator-name = "UNUSED_LDO25";
 				regulator-min-microvolt = <3000000>;
 				regulator-max-microvolt = <3000000>;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck1_reg: BUCK1 {
@@ -327,6 +415,10 @@
 				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <900000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck2_reg: BUCK2 {
@@ -334,6 +426,10 @@
 				regulator-min-microvolt = <850000>;
 				regulator-max-microvolt = <1150000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck3_reg: BUCK3 {
@@ -341,6 +437,10 @@
 				regulator-min-microvolt = <850000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck4_reg: BUCK4 {
@@ -348,6 +448,10 @@
 				regulator-min-microvolt = <1950000>;
 				regulator-max-microvolt = <1950000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-on-in-suspend;
+				};
 			};
 
 			buck5_reg: BUCK5 {
@@ -355,6 +459,10 @@
 				regulator-min-microvolt = <1350000>;
 				regulator-max-microvolt = <1350000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-on-in-suspend;
+				};
 			};
 		};
 	};
-- 
1.8.0

