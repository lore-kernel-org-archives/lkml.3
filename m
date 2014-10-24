Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426AbaJXLkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:40:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:65155 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260AbaJXLkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:40:05 -0400
X-AuditID: cbfee691-f79b86d000004a5a-f6-544a3a92320d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: kgene.kim@samsung.com
Cc: mark.rutland@arm.com, arnd@arndb.de, olof@lixom.net, tomasz.figa@gmail.com,
        geunsik.lim@samsung.com, inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCHv3 3/3] ARM: dts: Add sleep mode of regulator for
 exynos3250-rinato board
Date: Fri, 24 Oct 2014 20:39:55 +0900
Message-id: <1414150795-31105-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1414150795-31105-1-git-send-email-cw00.choi@samsung.com>
References: <1414150795-31105-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42JZI2JSoDvZyivEYNI1Jou/k46xW1z/8pzV
	4s+EVjaLSfcnsFj0LrjKZnG26Q27xabH11gtLu+aw2Yx4/w+Joul1y8yWZy6/hnInfySzWLV
	rj+MDrwea+atYfT4/WsSo8fOWXfZPTYvqfe4cqKJ1aNvyypGj8+b5ALYo7hsUlJzMstSi/Tt
	Ergypr/uZSpYYF5xY+561gbGdRpdjJwcEgImEt+m3WSHsMUkLtxbz9bFyMUhJLCUUaK3tYcd
	pujvk+UsEInpjBKzPl1ngnCamCSu/zzPClLFJqAlsf/FDTYQW0RAUqKp4Q8ziM0ssI1Jom1S
	VhcjB4ewQJTElQVRIGEWAVWJc+f/MYHYvAKuEnOebWWBWKYgsWz5TFaQck4BN4n2fk6QsBBQ
	yedjaxlB1koIXGKXuHz0MxPEHAGJb5MPsYDUSwjISmw6wAwxRlLi4IobLBMYhRcwMqxiFE0t
	SC4oTkovMtUrTswtLs1L10vOz93ECIyZ0/+eTdzBeP+A9SFGAQ5GJR7eGzM8Q4RYE8uKK3MP
	MZoCbZjILCWanA+MzLySeENjMyMLUxNTYyNzSzMlcV4d6Z/BQgLpiSWp2ampBalF8UWlOanF
	hxiZODilGhiFKh8FJjzt0J1qaGulzZZZZXAuY9Jpnts6bxkfat+5qsl26cqGg9vYrOTPFjG0
	zm+vCb9wZ7/qFI7zsyY2mbU9n7maff1xrZNL+itkVy5YYjz3ZhObuoZF9RYXhffp29w485km
	Pnd8LLz8nOmNTwfrEz1Dl5Yd3mrDfSRb4InA9tfRjR1MbueVWIozEg21mIuKEwHLcBFSlAIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t9jQd1JVl4hBsuvmFr8nXSM3eL6l+es
	Fn8mtLJZTLo/gcWid8FVNouzTW/YLTY9vsZqcXnXHDaLGef3MVksvX6RyeLU9c9A7uSXbBar
	dv1hdOD1WDNvDaPH71+TGD12zrrL7rF5Sb3HlRNNrB59W1YxenzeJBfAHtXAaJORmpiSWqSQ
	mpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdK6SQlliTilQKCCxuFhJ
	3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMWP6616mggXmFTfmrmdtYFyn0cXIySEhYCLx98ly
	FghbTOLCvfVsXYxcHEIC0xklZn26zgThNDFJXP95nhWkik1AS2L/ixtsILaIgKREU8MfZhCb
	WWAbk0TbpKwuRg4OYYEoiSsLokDCLAKqEufO/2MCsXkFXCXmPNsKtUxBYtnymawg5ZwCbhLt
	/ZwgYSGgks/H1jJOYORdwMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Ip9J72Bc1WBx
	iFGAg1GJh/fGDM8QIdbEsuLK3EOMEhzMSiK8XiZeIUK8KYmVValF+fFFpTmpxYcYTYGOmsgs
	JZqcD0wWeSXxhsYmZkaWRuaGFkbG5krivAdbrQOFBNITS1KzU1MLUotg+pg4OKUaGPXPJa7V
	OdC5MjQ8ZHpQn4KB4YngLV+XdonUP7tXUzxX8Zhwi+PSTzfPT9z2ykg4b8dzprK3y2/GbTr1
	VSVUq+7u+VO+G3QZ03yeZMSKZq+RiIpKNmtQnnLVTvuSla3/u6P7IvceZrI7eCCZb1orT1Gl
	fOaK/d3yN14/e9zuvOXqovav9/nNcpRYijMSDbWYi4oTAcY/rf7eAgAA
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
index 7256eec..8e828bc 100644
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
@@ -194,6 +210,10 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo6_reg: LDO6 {
@@ -201,6 +221,10 @@
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo7_reg: LDO7 {
@@ -208,6 +232,10 @@
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo8_reg: LDO8 {
@@ -215,6 +243,10 @@
 				regulator-min-microvolt = <3000000>;
 				regulator-max-microvolt = <3000000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			ldo9_reg: LDO9 {
@@ -222,12 +254,20 @@
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
@@ -248,60 +288,100 @@
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
@@ -315,12 +395,20 @@
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
@@ -328,6 +416,10 @@
 				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <900000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck2_reg: BUCK2 {
@@ -335,6 +427,10 @@
 				regulator-min-microvolt = <850000>;
 				regulator-max-microvolt = <1150000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck3_reg: BUCK3 {
@@ -342,6 +438,10 @@
 				regulator-min-microvolt = <850000>;
 				regulator-max-microvolt = <1000000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-off-in-suspend;
+				};
 			};
 
 			buck4_reg: BUCK4 {
@@ -349,6 +449,10 @@
 				regulator-min-microvolt = <1950000>;
 				regulator-max-microvolt = <1950000>;
 				regulator-always-on;
+
+				regulator-state-mem {
+					regulator-on-in-suspend;
+				};
 			};
 
 			buck5_reg: BUCK5 {
@@ -356,6 +460,10 @@
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

