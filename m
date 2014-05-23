Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031AbaEWKZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:25:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17087 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaEWKZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:25:30 -0400
X-AuditID: cbfee690-b7fb56d000003439-3c-537f221314a9
From: Jaehoon Chung <jh80.chung@samsung.com>
To: linux-mmc@vger.kernel.org
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Seungwon Jeon <tgih.jun@samsung.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Jaehoon Chung <jh80.chung@samsung.com>
Subject: [PATCH 3/3] ARM: dts: replace the broken-cd property into slot node
 for dwmmc.
Date: Fri, 23 May 2014 19:25:21 +0900
Message-id: <1400840721-11050-4-git-send-email-jh80.chung@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1400840721-11050-1-git-send-email-jh80.chung@samsung.com>
References: <1400840721-11050-1-git-send-email-jh80.chung@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkQFdEqT7YYM9yJosJl7czWsw/co7V
	4savNlaLy7vmsFkc+d/PaDHj/D4mi0Mzky0+3L/IbHF8bbgDp8eCX1tZPO5c28PmcePVQiaP
	vi2rGD0+b5ILYI3isklJzcksSy3St0vgythxejVTQZ9JxcFHOxgbGJ9rdDFyckgImEh8+vyA
	HcIWk7hwbz0biC0ksJRR4s1UUZiazU0fgeJcQPFFjBI3Ni9ghnDamCTarp9gAaliE9CR2P7t
	OBOILSIgK/HzzwWwDmaB1UwSR5f/ZgZJCAtESsxt3QzWwCKgKnF/4UlGEJtXwE1iw939QM0c
	QOsUJOZMsgEJcwq4S8ybe5EV4iI3iQ/b57FBXLSOXeLjRX2IMQIS3yYfYoFolZXYdIAZokRS
	4uCKGywTGIUXMDKsYhRNLUguKE5KLzLRK07MLS7NS9dLzs/dxAgM+tP/nk3YwXjvgPUhxmSg
	cROZpUST84FRk1cSb2hsZmRhamJqbGRuaUaasJI4r9qjpCAhgfTEktTs1NSC1KL4otKc1OJD
	jEwcnFINjIUNh9x3/b1wSMPIeoP5UWHGE9V/XB+3z7uraT/zwIf3Tt+e7bdSiHqfJOJzodpS
	zVj2xQFXoy+ON2wOpb666Lddaffu2hcbK49ymJatXKa3pTZT71+xiIz+4vd1+5wXT7OKPioZ
	lBvnEilbsK2pOfKCWkLG9w2H/Wf6bFlyLvmsV7nF6uxUayWW4oxEQy3mouJEAPEHlqGQAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t9jAV1hpfpgg949phYTLm9ntJh/5Byr
	xY1fbawWl3fNYbM48r+f0WLG+X1MFodmJlt8uH+R2eL42nAHTo8Fv7ayeNy5tofN48arhUwe
	fVtWMXp83iQXwBrVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk
	4hOg65aZA3SPkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFjx+nVTAV9
	JhUHH+1gbGB8rtHFyMkhIWAisbnpIxuELSZx4d56IJuLQ0hgEaPEjc0LmCGcNiaJtusnWECq
	2AR0JLZ/O84EYosIyEr8/HMBrINZYDWTxNHlv5lBEsICkRJzWzeDNbAIqErcX3iSEcTmFXCT
	2HB3P1AzB9A6BYk5k2xAwpwC7hLz5l5kBbGFgEo+bJ/HNoGRdwEjwypG0dSC5ILipPRcQ73i
	xNzi0rx0veT83E2M4Lh6JrWDcWWDxSFGAQ5GJR7eB0x1wUKsiWXFlbmHGCU4mJVEeM/I1gcL
	8aYkVlalFuXHF5XmpBYfYkwGOmois5Rocj4w5vNK4g2NTcyMLI3MDS2MjM1JE1YS5z3Qah0o
	JJCeWJKanZpakFoEs4WJg1OqgXHatb+bTsTtyfKx2ZH752H1wtog3ppsFwGBrav7NcXCU8sU
	l33eLVUy7e8vCxMP50lKH+UYa/xSuPjCYrfLaZxmVBJumdttsTKuK6zk8BTOFVcFT05JPaq9
	48FPKSa9XxNdk6anXhB9+15Dcm7BnyNsjquvz7j3TXCawuETGxjrDt29NL/xTJoSS3FGoqEW
	c1FxIgCEVq+17wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dw-mmc controller can be support the multiple slot.
So each slot's property can be difference.

Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
---
 arch/arm/boot/dts/exynos4412-odroidx.dts      |    2 +-
 arch/arm/boot/dts/exynos4412-origen.dts       |    2 +-
 arch/arm/boot/dts/exynos4412-trats2.dts       |    4 ++--
 arch/arm/boot/dts/exynos5250-arndale.dts      |    2 +-
 arch/arm/boot/dts/exynos5250-cros-common.dtsi |    4 ++--
 arch/arm/boot/dts/exynos5250-smdk5250.dts     |    2 +-
 arch/arm/boot/dts/exynos5420-arndale-octa.dts |    2 +-
 arch/arm/boot/dts/rk3066a-bqcurie2.dts        |    2 +-
 arch/arm/boot/dts/socfpga_arria5.dtsi         |    2 +-
 arch/arm/boot/dts/socfpga_cyclone5.dtsi       |    2 +-
 arch/arm/boot/dts/socfpga_vt.dts              |    2 +-
 11 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4412-odroidx.dts b/arch/arm/boot/dts/exynos4412-odroidx.dts
index 31db28a..24ec351 100644
--- a/arch/arm/boot/dts/exynos4412-odroidx.dts
+++ b/arch/arm/boot/dts/exynos4412-odroidx.dts
@@ -46,7 +46,6 @@
 
 		num-slots = <1>;
 		supports-highspeed;
-		broken-cd;
 		card-detect-delay = <200>;
 		samsung,dw-mshc-ciu-div = <3>;
 		samsung,dw-mshc-sdr-timing = <2 3>;
@@ -55,6 +54,7 @@
 		slot@0 {
 			reg = <0>;
 			bus-width = <8>;
+			broken-cd;
 		};
 	};
 
diff --git a/arch/arm/boot/dts/exynos4412-origen.dts b/arch/arm/boot/dts/exynos4412-origen.dts
index e2c0dca..ed712a6 100644
--- a/arch/arm/boot/dts/exynos4412-origen.dts
+++ b/arch/arm/boot/dts/exynos4412-origen.dts
@@ -129,7 +129,6 @@
 
 		num-slots = <1>;
 		supports-highspeed;
-		broken-cd;
 		card-detect-delay = <200>;
 		samsung,dw-mshc-ciu-div = <3>;
 		samsung,dw-mshc-sdr-timing = <2 3>;
@@ -138,6 +137,7 @@
 		slot@0 {
 			reg = <0>;
 			bus-width = <8>;
+			broken-cd;
 		};
 	};
 
diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 9583563..294a586 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -460,8 +460,6 @@
 	mmc@12550000 {
 		num-slots = <1>;
 		supports-highspeed;
-		broken-cd;
-		non-removable;
 		card-detect-delay = <200>;
 		vmmc-supply = <&vemmc_reg>;
 		clock-frequency = <400000000>;
@@ -475,6 +473,8 @@
 		slot@0 {
 			reg = <0>;
 			bus-width = <8>;
+			non-removable;
+			broken-cd;
 		};
 	};
 
diff --git a/arch/arm/boot/dts/exynos5250-arndale.dts b/arch/arm/boot/dts/exynos5250-arndale.dts
index 090f983..0c9a7da 100644
--- a/arch/arm/boot/dts/exynos5250-arndale.dts
+++ b/arch/arm/boot/dts/exynos5250-arndale.dts
@@ -400,7 +400,6 @@
 		status = "okay";
 		num-slots = <1>;
 		supports-highspeed;
-		broken-cd;
 		card-detect-delay = <200>;
 		samsung,dw-mshc-ciu-div = <3>;
 		samsung,dw-mshc-sdr-timing = <2 3>;
@@ -412,6 +411,7 @@
 		slot@0 {
 			reg = <0>;
 			bus-width = <8>;
+			broken-cd;
 		};
 	};
 
diff --git a/arch/arm/boot/dts/exynos5250-cros-common.dtsi b/arch/arm/boot/dts/exynos5250-cros-common.dtsi
index 2c1560d..7ab3b94 100644
--- a/arch/arm/boot/dts/exynos5250-cros-common.dtsi
+++ b/arch/arm/boot/dts/exynos5250-cros-common.dtsi
@@ -249,7 +249,6 @@
 	mmc@12200000 {
 		num-slots = <1>;
 		supports-highspeed;
-		broken-cd;
 		card-detect-delay = <200>;
 		samsung,dw-mshc-ciu-div = <3>;
 		samsung,dw-mshc-sdr-timing = <2 3>;
@@ -260,6 +259,7 @@
 		slot@0 {
 			reg = <0>;
 			bus-width = <8>;
+			broken-cd;
 		};
 	};
 
@@ -283,7 +283,6 @@
 	mmc@12230000 {
 		num-slots = <1>;
 		supports-highspeed;
-		broken-cd;
 		card-detect-delay = <200>;
 		samsung,dw-mshc-ciu-div = <3>;
 		samsung,dw-mshc-sdr-timing = <2 3>;
@@ -293,6 +292,7 @@
 		slot@0 {
 			reg = <0>;
 			bus-width = <4>;
+			broken-cd;
 		};
 	};
 
diff --git a/arch/arm/boot/dts/exynos5250-smdk5250.dts b/arch/arm/boot/dts/exynos5250-smdk5250.dts
index a794a70..feffe24 100644
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@ -283,7 +283,6 @@
 		status = "okay";
 		num-slots = <1>;
 		supports-highspeed;
-		broken-cd;
 		card-detect-delay = <200>;
 		samsung,dw-mshc-ciu-div = <3>;
 		samsung,dw-mshc-sdr-timing = <2 3>;
@@ -294,6 +293,7 @@
 		slot@0 {
 			reg = <0>;
 			bus-width = <8>;
+			broken-cd;
 		};
 	};
 
diff --git a/arch/arm/boot/dts/exynos5420-arndale-octa.dts b/arch/arm/boot/dts/exynos5420-arndale-octa.dts
index 80a3bf4..0d3b467 100644
--- a/arch/arm/boot/dts/exynos5420-arndale-octa.dts
+++ b/arch/arm/boot/dts/exynos5420-arndale-octa.dts
@@ -39,7 +39,6 @@
 
 	mmc@12200000 {
 		status = "okay";
-		broken-cd;
 		supports-highspeed;
 		card-detect-delay = <200>;
 		samsung,dw-mshc-ciu-div = <3>;
@@ -52,6 +51,7 @@
 		slot@0 {
 			reg = <0>;
 			bus-width = <8>;
+			broken-cd;
 		};
 	};
 
diff --git a/arch/arm/boot/dts/rk3066a-bqcurie2.dts b/arch/arm/boot/dts/rk3066a-bqcurie2.dts
index 035df40..62c7484 100644
--- a/arch/arm/boot/dts/rk3066a-bqcurie2.dts
+++ b/arch/arm/boot/dts/rk3066a-bqcurie2.dts
@@ -69,7 +69,6 @@
 		dwmmc@10218000 { /* wifi */
 			num-slots = <1>;
 			status = "okay";
-			non-removable;
 
 			pinctrl-names = "default";
 			pinctrl-0 = <&sd1_clk &sd1_cmd &sd1_bus4>;
@@ -78,6 +77,7 @@
 				reg = <0>;
 				bus-width = <4>;
 				disable-wp;
+				non-removable;
 			};
 		};
 
diff --git a/arch/arm/boot/dts/socfpga_arria5.dtsi b/arch/arm/boot/dts/socfpga_arria5.dtsi
index 6c87b70..9c2b933 100644
--- a/arch/arm/boot/dts/socfpga_arria5.dtsi
+++ b/arch/arm/boot/dts/socfpga_arria5.dtsi
@@ -30,11 +30,11 @@
 		dwmmc0@ff704000 {
 			num-slots = <1>;
 			supports-highspeed;
-			broken-cd;
 
 			slot@0 {
 				reg = <0>;
 				bus-width = <4>;
+				broken-cd;
 			};
 		};
 
diff --git a/arch/arm/boot/dts/socfpga_cyclone5.dtsi b/arch/arm/boot/dts/socfpga_cyclone5.dtsi
index ca41b0e..c5c7b5f 100644
--- a/arch/arm/boot/dts/socfpga_cyclone5.dtsi
+++ b/arch/arm/boot/dts/socfpga_cyclone5.dtsi
@@ -31,11 +31,11 @@
 		dwmmc0@ff704000 {
 			num-slots = <1>;
 			supports-highspeed;
-			broken-cd;
 
 			slot@0 {
 				reg = <0>;
 				bus-width = <4>;
+				broken-cd;
 			};
 		};
 
diff --git a/arch/arm/boot/dts/socfpga_vt.dts b/arch/arm/boot/dts/socfpga_vt.dts
index 87d6f75..ff1111e 100644
--- a/arch/arm/boot/dts/socfpga_vt.dts
+++ b/arch/arm/boot/dts/socfpga_vt.dts
@@ -44,11 +44,11 @@
 		dwmmc0@ff704000 {
 			num-slots = <1>;
 			supports-highspeed;
-			broken-cd;
 
 			slot@0 {
 				reg = <0>;
 				bus-width = <4>;
+				broken-cd;
 			};
 		};
 
-- 
1.7.9.5

