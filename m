Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965923AbaLLI2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:28:05 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:38563 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965822AbaLLI15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:27:57 -0500
X-AuditID: cbfee691-f79b86d000004a5a-5e-548aa6f696c5
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: kgene.kim@samsung.com, rafael.j.wysocki@intel.com, a.kesavan@samsung.com,
        tomasz.figa@gmail.com, b.zolnierkie@samsung.com,
        k.kozlowski@samsung.com, cw00.choi@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCHv3 6/7] ARM: dts: Add PPMU dt node for Exynos4 SoC
Date: Fri, 12 Dec 2014 17:27:31 +0900
Message-id: <1418372852-12454-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1418372852-12454-1-git-send-email-cw00.choi@samsung.com>
References: <1418372852-12454-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkWPfbsq4Qg6uNchaP1yxmstg4Yz2r
	xfUvz1kt5h85x2rx+oWhRe+Cq2wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8niduMKNovH
	K96yW6za9YfRgc9j56y77B6L97xk8ti8pN6jb8sqRo/Pm+QCWKO4bFJSczLLUov07RK4Mja9
	nM1ccE2h4vf2U4wNjBOkuhg5OSQETCRutGxkhLDFJC7cW8/WxcjFISSwlFFi//1XLDBFix5e
	YoJILGKU+LD8JJTTxCRxbtZ+ZpAqNgEtif0vbrCB2CIC5hK7lv4EG8UscIlJYvvMHiaQhLCA
	q8SZvutgNouAqkTXzFVgK3iB4j3rrjBDrFOQWLZ8JiuIzSngJvHi6gag+ziAtrlK/FxSBzJT
	QuAUu8SurbvZIOYISHybfIgFpEZCQFZi0wGoMZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kale
	cWJucWleul5yfu4mRmCsnP73bOIOxvsHrA8xCnAwKvHwvkjtChFiTSwrrsw9xGgKtGEis5Ro
	cj4wIvNK4g2NzYwsTE1MjY3MLc2UxHl1pH8GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBs
	2NjguyPGMuSUe2MO82vp4wl7A0o23di9Men/Hdf9oZ77DyzcstdpH6e0On+blamI++oZyW1N
	C/scZy7jtG/nnSzS/XhqW+p1bi8fs8m8Jd1LGBs6E04xihqcXndlflbZ1UMt1msTps9L6C4K
	DPb0WvK+5PVvr4TrktNum6h/3mDV5dm2LVCJpTgj0VCLuag4EQCCPUN6kAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t9jAd1vy7pCDB5dF7F4vGYxk8XGGetZ
	La5/ec5qMf/IOVaL1y8MLXoXXGWzONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWtxtXsFk8
	XvGW3WLVrj+MDnweO2fdZfdYvOclk8fmJfUefVtWMXp83iQXwBrVwGiTkZqYklqkkJqXnJ+S
	mZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SokkJZYk4pUCggsbhYSd8O04TQ
	EDddC5jGCF3fkCC4HiMDNJCwhjFj08vZzAXXFCp+bz/F2MA4QaqLkZNDQsBEYtHDS0wQtpjE
	hXvr2boYuTiEBBYxSnxYfpIJwmlikjg3az8zSBWbgJbE/hc32EBsEQFziV1Lf4J1MAtcYpLY
	PrMHbJSwgKvEmb7rYDaLgKpE18xVLCA2L1C8Z90VZoh1ChLLls9kBbE5BdwkXlzdwNjFyAG0
	zVXi55K6CYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIER+Iz6R2MqxosDjEKcDAq
	8fC+SO0KEWJNLCuuzD3EKMHBrCTC+zcKKMSbklhZlVqUH19UmpNafIjRFOioicxSosn5wCSR
	VxJvaGxiZmRpZG5oYWRsriTOq2TfFiIkkJ5YkpqdmlqQWgTTx8TBKdXAOKkgyfBGygN+9Vfi
	anWrPZZ5TL5synty298nx1rYXXrezQ3/e9Bhq95rH4H7MWKa65a86lo/vcFnX46Oh8ZO29N/
	Lj3Y9u2izYT5Xw9JH/sgL7/6/XfPdL/U2k2bFD7n+nvfNTfi1qk7cXCScmJLcG3YlPOdHW8O
	tb2wXn7TWDfDaf3HlZVpaUosxRmJhlrMRcWJAEp72SHaAgAA
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

