Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbaLIOO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:14:59 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26705 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbaLIONR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:13:17 -0500
X-AuditID: cbfee68e-f79b46d000002b74-e9-548703745c11
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, kgene.kim@samsung.com,
        rafael.j.wysocki@intel.com, a.kesavan@samsung.com,
        tomasz.figa@gmail.com, b.zolnierkie@samsung.com,
        k.kozlowski@samsung.com, cw00.choi@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCHv2 6/7] ARM: dts: Add PPMU dt node for Exynos4 SoC
Date: Tue, 09 Dec 2014 23:13:05 +0900
Message-id: <1418134386-14681-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1418134386-14681-1-git-send-email-cw00.choi@samsung.com>
References: <1418134386-14681-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWyRsSkSLeEuT3E4NA7DYvHaxYzWWycsZ7V
	4vqX56wW84+cY7V4/cLQonfBVTaLs01v2C02Pb7GanF51xw2i8+9RxgtZpzfx2Rxu3EFm8Xj
	FW/ZLVbt+sPowOexc9Zddo/Fe14yeWxeUu/Rt2UVo8fnTXIBrFFcNimpOZllqUX6dglcGVOb
	ehkLuhUrPq1aw9jAeECqi5GTQ0LAROJuz1d2CFtM4sK99WwgtpDAUkaJBxddYWqu7HvB2sXI
	BRRfxChxb+tmNginiUniza7drCBVbAJaEvtf3ADrFhGwkjj9v4MZpIhZ4DyTxJKF+4EcDg5h
	AVeJ2+d1QGpYBFQlDh+bxAhi8wKFV6xcwQaxTUFi2fKZYDM5BdwkmnY3skBc5Crx4UQrO8hM
	CYFj7BLPN7exQAwSkPg2+RALyHwJAVmJTQeYIeZIShxccYNlAqPwAkaGVYyiqQXJBcVJ6UVG
	esWJucWleel6yfm5mxiBkXL637O+HYw3D1gfYhTgYFTi4dW0bAsRYk0sK67MPcRoCrRhIrOU
	aHI+MB7zSuINjc2MLExNTI2NzC3NlMR5E6R+BgsJpCeWpGanphakFsUXleakFh9iZOLglGpg
	ZLT4PsNy52v77ZcSF7yNtJPIstyU/4exb7vMzKYJc1RTJDQiCr7MeBcasS7hm+K7ZCtlIcuf
	m3l6BPl+Lgz961A8f/GqR/ekHQUqpK0bLabK3dlesaZwhmqva/bX35w6Tw/orjV0057uoFsX
	znH8T79DWfLBDxO/NZ045moyW2v9ba6cx08ClFiKMxINtZiLihMBwLbhJ48CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t9jAd0S5vYQgzN35C0er1nMZLFxxnpW
	i+tfnrNazD9yjtXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF7cYVbBaP
	V7xlt1i16w+jA5/Hzll32T0W73nJ5LF5Sb1H35ZVjB6fN8kFsEY1MNpkpCampBYppOYl56dk
	5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAB2qpFCWmFMKFApILC5W0rfDNCE0
	xE3XAqYxQtc3JAiux8gADSSsYcyY2tTLWNCtWPFp1RrGBsYDUl2MnBwSAiYSV/a9YIWwxSQu
	3FvP1sXIxSEksIhR4t7WzVBOE5PEm127warYBLQk9r+4wQZiiwhYSZz+38EMUsQscJ5JYsnC
	/UAOB4ewgKvE7fM6IDUsAqoSh49NYgSxeYHCK1auYIPYpiCxbPlMsJmcAm4STbsbWUBsIaCa
	Dyda2Scw8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERyJz6R2MK5ssDjEKMDBqMTD
	q2nZFiLEmlhWXJl7iFGCg1lJhHfKUaAQb0piZVVqUX58UWlOavEhRlOgqyYyS4km5wOTRF5J
	vKGxiZmRpZG5oYWRsbmSOK+SPVCTQHpiSWp2ampBahFMHxMHp1QDY0pV5iTGiHNp+xU82rR0
	g/oepmyYtbzuJ5d7v7RNUkrTsqcbLz+7fLmTdf3bFLmJ4jtvvFP1Em1YHzc99+ym1zOPHbM/
	HTr9Rr9GsHm85ScbRvHkxQXXXweGT3TUlVB5sOhNiU5X9B2nS2Zr70e9nb25nzdJ+P/8ijVr
	3HWzmg6UKV77+rD7vBJLcUaioRZzUXEiAOC5pXvaAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add PPMU (Performance Profiling Monitoring Unit) dt node for Exynos4
(Exynos4210/4212/4412) SoC. PPMU dt node is used to monitor the utilization of
each IP.

The Exynos4210/Exynos4212/Exynos4412 SoC includes following PPMUs:
- PPMU_DMC0      0x106A_0000
- PPMU_DMC1      0x106B_0000
- PPMU_CPU       0x106C_0000
- PPMU_ACP       0x10AE_0000
- PPMU_RIGHT_BUS 0x112A_0000
- PPMU_LEFT_BUS  0x116A_0000
- PPMU_LCD0      0x11E4_0000
- PPMU_CAMIF     0x11AC_0000
- PPMU_IMAGE     0x12AA_0000
- PPMU_TV        0x12E4_0000
- PPMU_3D        0x1322_0000
- PPMU_MFC_L     0x1366_0000
- PPMU_MFC_R     0x1367_0000

Additionally, the Exynos4210 SoC includes following PPMUs:
- PPMU_LCD1      0x1224_0000

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos4.dtsi    | 96 +++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos4210.dtsi |  8 ++++
 2 files changed, 104 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index e0278ec..150bb56 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -645,4 +645,100 @@
 		samsung,sysreg = <&sys_reg>;
 		status = "disabled";
 	};
+
+	ppmu_dmc0: ppmu_dmc0@106a0000 {
+		compatible = "samsung,exynos-ppmu";
+		reg = <0x106a0000 0x2000>;
+		clocks = <&clock CLK_PPMUDMC0>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
+
+	ppmu_dmc1: ppmu_dmc1@106b0000 {
+		compatible = "samsung,exynos-ppmu";
+		reg = <0x106b0000 0x2000>;
+		clocks = <&clock CLK_PPMUDMC1>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
+
+	ppmu_cpu: ppmu_cpu@106c0000 {
+		compatible = "samsung,exynos-ppmu";
+		reg = <0x106c0000 0x2000>;
+		clocks = <&clock CLK_PPMUCPU>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
+
+	ppmu_rightbus: ppmu_rightbus@112a0000 {
+		compatible = "samsung,exynos-ppmu";
+		reg = <0x112a0000 0x2000>;
+		clocks = <&clock CLK_PPMURIGHT>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
+
+	ppmu_leftbus: ppmu_leftbus0@116a0000 {
+		compatible = "samsung,exynos-ppmu";
+		reg = <0x116a0000 0x2000>;
+		clocks = <&clock CLK_PPMULEFT>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
+
+	ppmu_camif: ppmu_camif@11ac0000 {
+		compatible = "samsung,exynos-ppmu";
+		reg = <0x11ac0000 0x2000>;
+		clocks = <&clock CLK_PPMUCAMIF>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
+
+	ppmu_lcd0: ppmu_lcd0@11e40000 {
+		compatible = "samsung,exynos-ppmu";
+		reg = <0x11e40000 0x2000>;
+		clocks = <&clock CLK_PPMULCD0>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
+
+	ppmu_image: ppmu_image@12aa0000 {
+		compatible = "samsung,exynos-ppmu";
+		reg = <0x12aa0000 0x2000>;
+		clocks = <&clock CLK_PPMUIMAGE>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
+
+	ppmu_tv: ppmu_tv@12e40000 {
+		compatible = "samsung,exynos-ppmu";
+		reg = <0x12e40000 0x2000>;
+		clocks = <&clock CLK_PPMUTV>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
+
+	ppmu_g3d: ppmu_g3d@13220000 {
+		compatible = "samsung,exynos-ppmu";
+		reg = <0x13220000 0x2000>;
+		clocks = <&clock CLK_PPMUG3D>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
+
+	ppmu_mfc_l: ppmu_mfc_l@13660000 {
+		compatible = "samsung,exynos-ppmu";
+		reg = <0x13660000 0x2000>;
+		clocks = <&clock CLK_PPMUMFC_L>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
+
+	ppmu_mfc_r: ppmu_mfc_r@13670000 {
+		compatible = "samsung,exynos-ppmu";
+		reg = <0x13670000 0x2000>;
+		clocks = <&clock CLK_PPMUMFC_R>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
 };
diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index bcc9e63..b2598de 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -192,4 +192,12 @@
 			samsung,lcd-wb;
 		};
 	};
+
+	ppmu_lcd1: ppmu_lcd1@12240000 {
+		compatible = "samsung,exynos-ppmu";
+		reg = <0x12240000 0x2000>;
+		clocks = <&clock CLK_PPMULCD1>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
 };
-- 
1.8.5.5

