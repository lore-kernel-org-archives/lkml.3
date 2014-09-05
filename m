Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbaIEEbe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 00:31:34 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27077 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbaIEEa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 00:30:28 -0400
X-AuditID: cbfee68f-f797f6d000001173-fe-54093c60b9f2
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, linux-pm@vger.kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        a.kesavan@samsung.com, kgene.kim@samsung.com, tomasz.figa@gmail.com,
        b.zolnierkie@samsung.com, nm@ti.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [RFC PATCH 4/5] ARM: dts: Add PPMU dt node for Exynos4 SoC
Date: Fri, 05 Sep 2014 13:30:18 +0900
Message-id: <1409891419-28560-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1409891419-28560-1-git-send-email-cw00.choi@samsung.com>
References: <1409891419-28560-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWyRsSkSDfBhjPE4PU9AYvHaxYzWWycsZ7V
	4vqX56wWvQuuslmcbXrDbrHp8TVWi8u75rBZfO49wmgx4/w+JovbjSvYLN78OMtk8XjFW3aL
	Vbv+MDrweuycdZfdY/Gel0wem5fUe/RtWcXocfzGdiaPz5vkAtiiuGxSUnMyy1KL9O0SuDLu
	z17FVjBVseL2j/ksDYznpboYOTkkBEwkNv1+wQJhi0lcuLeeDcQWEljKKHH0ehJMzdXVzUxd
	jFxA8emMEquv32OFcJqYJE5tecEIUsUmoCWx/8UNsG4RATOJfTv+ghUxC+xgkrh24AdYkbCA
	s8SM80eBRnFwsAioSuyfHAAS5hVwlTi8+iI7xDY5iQ97HoHZnAJuEmvvX2OCuMhV4uLxScwQ
	NefYJfZNqgSxWQQEJL5NPsQCMlJCQFZi0wGoEkmJgytusExgFF7AyLCKUTS1ILmgOCm9yFiv
	ODG3uDQvXS85P3cTIzBSTv971r+D8e4B60OMAhyMSjy8Cz5zhAixJpYVV+YeYjQF2jCRWUo0
	OR8Yj3kl8YbGZkYWpiamxkbmlmZK4rwLpX4GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBc
	ufV/m9+M+oQEJo6DzQ6/t4lk7mq+HbBecr3qsoK89Ia3kwQCv/FN2GERv3nvm7quj7rlJ2WX
	pUTtZGcz++92a06m+6w5qQUTjLQe7vuZbPbG5nrkTzWmRBPGX4Wrv37apvRKv0/3n/aSorTI
	I958rgt0TibmPoyzPKBe8rrNvP/u8elLtzkosRRnJBpqMRcVJwIAWcax/o8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t9jQd0EG84Qg/aX7BaP1yxmstg4Yz2r
	xfUvz1ktehdcZbM42/SG3WLT42usFpd3zWGz+Nx7hNFixvl9TBa3G1ewWbz5cZbJ4vGKt+wW
	q3b9YXTg9dg56y67x+I9L5k8Ni+p9+jbsorR4/iN7UwenzfJBbBFNTDaZKQmpqQWKaTmJeen
	ZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gBdqqRQlphTChQKSCwuVtK3wzQh
	NMRN1wKmMULXNyQIrsfIAA0krGHMuD97FVvBVMWK2z/mszQwnpfqYuTkkBAwkbi6upkJwhaT
	uHBvPVsXIxeHkMB0RonV1++xQjhNTBKntrxgBKliE9CS2P/iBhuILSJgJrFvx1+wImaBHUwS
	1w78ACsSFnCWmHH+KNBYDg4WAVWJ/ZMDQMK8Aq4Sh1dfZIfYJifxYc8jMJtTwE1i7f1rYFcI
	AdVcPD6JeQIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwbH4TGoH48oGi0OMAhyM
	Sjy8Cz5zhAixJpYVV+YeYpTgYFYS4fV6AxTiTUmsrEotyo8vKs1JLT7EaAp01ERmKdHkfGCa
	yCuJNzQ2MTOyNDI3tDAyNlcS5z3Qah0oJJCeWJKanZpakFoE08fEwSnVwHhy6g7jqwEzotP2
	OFambJp2frXqPN4EwbiYHxcKTJkjn+llPDb+0j97xZaGW641LjriYav6X91i3zr/9xrtvd9n
	FefYCUWaBsTcn7+wrurIn+lTPJLOJUw8tNWkZNbl+vRrz4IXzFVye/fR6sa6zw3J4Q3LFnf4
	Ju1c4MTN0xNwrFh8W8wbE0UlluKMREMt5qLiRAD931pC2wIAAA==
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

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos4.dtsi    | 96 +++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos4210.dtsi |  8 ++++
 2 files changed, 104 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index e0278ec..c58d3f3 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -645,4 +645,100 @@
 		samsung,sysreg = <&sys_reg>;
 		status = "disabled";
 	};
+
+	ppmu_dmc0: ppmu_dmc0@106a0000 {
+		compatible = "samsung,exynos4210-ppmu";
+		reg = <0x106a0000 0x2000>;
+		clocks = <&clock CLK_PPMUDMC0>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
+
+	ppmu_dmc1: ppmu_dmc1@106b0000 {
+		compatible = "samsung,exynos4210-ppmu";
+		reg = <0x106b0000 0x2000>;
+		clocks = <&clock CLK_PPMUDMC1>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
+
+	ppmu_cpu: ppmu_cpu@106c0000 {
+		compatible = "samsung,exynos4210-ppmu";
+		reg = <0x106c0000 0x2000>;
+		clocks = <&clock CLK_PPMUCPU>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
+
+	ppmu_rightbus: ppmu_rightbus@112a0000 {
+		compatible = "samsung,exynos4210-ppmu";
+		reg = <0x112a0000 0x2000>;
+		clocks = <&clock CLK_PPMURIGHT>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
+
+	ppmu_leftbus: ppmu_leftbus0@116a0000 {
+		compatible = "samsung,exynos4210-ppmu";
+		reg = <0x116a0000 0x2000>;
+		clocks = <&clock CLK_PPMULEFT>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
+
+	ppmu_camif: ppmu_camif@11ac0000 {
+		compatible = "samsung,exynos4210-ppmu";
+		reg = <0x11ac0000 0x2000>;
+		clocks = <&clock CLK_PPMUCAMIF>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
+
+	ppmu_lcd0: ppmu_lcd0@11e40000 {
+		compatible = "samsung,exynos4210-ppmu";
+		reg = <0x11e40000 0x2000>;
+		clocks = <&clock CLK_PPMULCD0>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
+
+	ppmu_image: ppmu_image@12aa0000 {
+		compatible = "samsung,exynos4210-ppmu";
+		reg = <0x12aa0000 0x2000>;
+		clocks = <&clock CLK_PPMUIMAGE>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
+
+	ppmu_tv: ppmu_tv@12e40000 {
+		compatible = "samsung,exynos4210-ppmu";
+		reg = <0x12e40000 0x2000>;
+		clocks = <&clock CLK_PPMUTV>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
+
+	ppmu_g3d: ppmu_g3d@13220000 {
+		compatible = "samsung,exynos4210-ppmu";
+		reg = <0x13220000 0x2000>;
+		clocks = <&clock CLK_PPMUG3D>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
+
+	ppmu_mfc_l: ppmu_mfc_l@13660000 {
+		compatible = "samsung,exynos4210-ppmu";
+		reg = <0x13660000 0x2000>;
+		clocks = <&clock CLK_PPMUMFC_L>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
+
+	ppmu_mfc_r: ppmu_mfc_r@13670000 {
+		compatible = "samsung,exynos4210-ppmu";
+		reg = <0x13670000 0x2000>;
+		clocks = <&clock CLK_PPMUMFC_R>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
 };
diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index 807bb5b..1b854e6 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -175,4 +175,12 @@
 			samsung,lcd-wb;
 		};
 	};
+
+	ppmu_lcd1: ppmu_lcd1@12240000 {
+		compatible = "samsung,exynos4210-ppmu";
+		reg = <0x12240000 0x2000>;
+		clocks = <&clock CLK_PPMULCD1>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
 };
-- 
1.8.0

