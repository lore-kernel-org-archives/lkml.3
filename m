Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbaJXNMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:12:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10676 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550AbaJXNMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:12:51 -0400
X-AuditID: cbfee68e-f79b46d000002b74-55-544a50505116
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net, tomasz.figa@gmail.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        k.kozlowski@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCHv4 3/3] ARM: dts: Add sleep mode of regulator for
 exynos3250-rinato board
Date: Fri, 24 Oct 2014 22:12:42 +0900
Message-id: <1414156362-5752-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1414156362-5752-1-git-send-email-cw00.choi@samsung.com>
References: <1414156362-5752-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSohsQ4BVi0NylYvF30jF2i+tfnrNa
	/JnQymYx6f4EFovXLwwtehdcZbM42/SG3WLT42usFpd3zWGzmHF+H5PF0usXmSxOXf8M5E5+
	yWaxatcfRgc+jzXz1jB6/P41idFj56y77B6bl9R7XDnRxOrRt2UVo8fnTXIB7FFcNimpOZll
	qUX6dglcGZNvbmctWGBeMeHsMfYGxnUaXYycHBICJhJfl+5mg7DFJC7cWw9kc3EICSxllJjf
	c5wRpujhkr3sEIlFjBJbNrSzQDhNTBIv5nQyg1SxCWhJ7H9xA2yUiICkRFPDH2aQImaB80wS
	jSd3AiU4OIQFoiRmfbACqWERUJXY334NrJ5XwEViwqYfTBDbFCSWLZ/JCmJzCrhKLH+3EaxG
	CKhm+9d9TCAzJQRusUssmbSYCWKQgMS3yYdYQOZLCMhKbDrADDFHUuLgihssExiFFzAyrGIU
	TS1ILihOSi8y0itOzC0uzUvXS87P3cQIjJ/T/5717WC8ecD6EKMAB6MSD++NGZ4hQqyJZcWV
	uYcYTYE2TGSWEk3OB0ZpXkm8obGZkYWpiamxkbmlmZI4b4LUz2AhgfTEktTs1NSC1KL4otKc
	1OJDjEwcnFINjNzTZ25aP5FX20Yj5u67akXZGKcb1mdfPUqLnr1tHWuGVG3UMf968fKN1vPf
	ny9W+LHsmFtC9Zeke9+dd9yszC/TVNFdcaHjdPQzjhb26Ncvt71QfXnxTtSzD4flSu71344X
	D2hcZnQ8S1z8RF3/Dvd0v6t8Hlo50+ybVZ/W3Vmhefn9BjZZYyWW4oxEQy3mouJEABHnhpea	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t9jAd2AAK8Qg7eHpCz+TjrGbnH9y3NW
	iz8TWtksJt2fwGLx+oWhRe+Cq2wWZ5vesFtsenyN1eLyrjlsFjPO72OyWHr9IpPFqeufgdzJ
	L9ksVu36w+jA57Fm3hpGj9+/JjF67Jx1l91j85J6jysnmlg9+rasYvT4vEkugD2qgdEmIzUx
	JbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+hkJYWyxJxSoFBA
	YnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPG5JvbWQsWmFdMOHuMvYFxnUYXIyeHhICJ
	xMMle9khbDGJC/fWs3UxcnEICSxilNiyoZ0Fwmlikngxp5MZpIpNQEti/4sbbCC2iICkRFPD
	H2aQImaB80wSjSd3AiU4OIQFoiRmfbACqWERUJXY334NrJ5XwEViwqYfTBDbFCSWLZ/JCmJz
	CrhKLH+3EaxGCKhm+9d9TBMYeRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI7OZ1I7
	GFc2WBxiFOBgVOLhvTHDM0SINbGsuDL3EKMEB7OSCK+/v1eIEG9KYmVValF+fFFpTmrxIUZT
	oKsmMkuJJucDE0deSbyhsYmZkaWRuaGFkbG5kjjvgVbrQCGB9MSS1OzU1ILUIpg+Jg5OqQbG
	jCWax7x+v3R9OpktwL3T5hSzbV35Yrd/lsVNt4p3bUsrPuRd3P9wht3a3PzQC7Y+Agbvfni9
	MmPwMDBezx7lvSPK/LLvnNXK33/Xl/JyG642kJNZZL5JPDXL+sIjyVMcF/eqPlDol+V3Nt9/
	XGK54XsxkSMfr5cKzfnjInTrOPfcY1IWJ+OUWIozEg21mIuKEwE733w55AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add sleep mode of regulator for exynos3250-rinato board to optimize
power-consumption in sleep state.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
---
 arch/arm/boot/dts/exynos3250-rinato.dts | 108 ++++++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index 8ad9808..84380fa 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -157,6 +157,10 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-on-in-suspend;
+				};
 			};
 
 			ldo2_reg: LDO2 {
@@ -164,6 +168,10 @@
 				regulator-min-microvolt = <1200000>;
 				regulator-max-microvolt = <1200000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo3_reg: LDO3 {
@@ -171,6 +179,10 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo4_reg: LDO4 {
@@ -178,6 +190,10 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo5_reg: LDO5 {
@@ -185,6 +201,10 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo6_reg: LDO6 {
@@ -192,6 +212,10 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo7_reg: LDO7 {
@@ -199,6 +223,10 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo8_reg: LDO8 {
@@ -206,6 +234,10 @@
 				regulator-min-microvolt = <3000000>;
 				regulator-max-microvolt = <3000000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo9_reg: LDO9 {
@@ -213,12 +245,20 @@
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
@@ -239,60 +279,100 @@
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
@@ -306,12 +386,20 @@
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
@@ -319,6 +407,10 @@
 				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <900000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck2_reg: BUCK2 {
@@ -326,6 +418,10 @@
 				regulator-min-microvolt = <850000>;
 				regulator-max-microvolt = <1150000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck3_reg: BUCK3 {
@@ -333,6 +429,10 @@
 				regulator-min-microvolt = <850000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck4_reg: BUCK4 {
@@ -340,6 +440,10 @@
 				regulator-min-microvolt = <1950000>;
 				regulator-max-microvolt = <1950000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-on-in-suspend;
+				};
 			};
 
 			buck5_reg: BUCK5 {
@@ -347,6 +451,10 @@
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
1.8.5.5

