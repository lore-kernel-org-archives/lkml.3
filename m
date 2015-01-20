Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbbATHL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:11:57 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:25907 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbbATHKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:10:22 -0500
X-AuditID: cbfee691-f79b86d000004a5a-ea-54bdff566d52
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v9 5/7] ARM: dts: Add PPMU dt node for Exynos4 SoCs
Date: Tue, 20 Jan 2015 16:10:07 +0900
Message-id: <1421737809-4010-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421737809-4010-1-git-send-email-cw00.choi@samsung.com>
References: <1421737809-4010-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAIsWRmVeSWpSXmKPExsWyRsSkWDfs/94Qg70HdC0er1nMZLFxxnpW
	i+tfnrNaTLo/gcXi9QtDi/7Hr5ktzja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27ReveI+wWq3b9YXQQ8Fgzbw2jx85Zd9k9Fu95yeSxaVUnm8fmJfUefVtWMXp8
	3iQXwB7FZZOSmpNZllqkb5fAlfHlwHq2giPKFV/2N7E3MO6R6WLk4JAQMJE4eTSoi5ETyBST
	uHBvPVsXIxeHkMBSRokHTd+ZIRImEnt/PWSFSCxilDjYfZkJwmlikjgw8x4bSBWbgJbE/hc3
	wGwRAT2JzmN72EFsZoE/TBJNm1hAbGEBZ4kNFxeC1bAIqEo8+TqTFcTmFXCRaDk8kQlim4LE
	suUQcU4BV4ntWy4zgthCQDXNn9+DLZYQeMkuMXfueqhBAhLfJh9igXhHVmLTAairJSUOrrjB
	MoFReAEjwypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MwIg6/e/ZxB2M9w9YH2IU4GBU4uF9
	sWpviBBrYllxZe4hRlOgDROZpUST84Fxm1cSb2hsZmRhamJqbGRuaaYkzqsj/TNYSCA9sSQ1
	OzW1ILUovqg0J7X4ECMTB6dUA6PcQ/V99jM9arbxHTyvVV9xc+XO8mqDWSru/SePrObon7rx
	g8v8t/LBbGc271O32q8wf9nmdbyKd8u+77/KtlAqdP+HzOUOnk9eir8OnPc6MJ1j+V3H6898
	5pjJ6NheWbe5+Mn6zR2tF28I3PD89cP+m1j0hp8OoudjTTezXb90wVt2+uysKbVXlViKMxIN
	tZiLihMBv+5W1aMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAd2w/3tDDG6uVLF4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFq17j7BbrNr1h9FBwGPNvDWMHjtn3WX3WLznJZPHplWdbB6bl9R79G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtDxSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaMLwfWsxUcUa74sr+J
	vYFxj0wXIyeHhICJxN5fD1khbDGJC/fWs3UxcnEICSxilDjYfZkJwmlikjgw8x4bSBWbgJbE
	/hc3wGwRAT2JzmN72EFsZoE/TBJNm1hAbGEBZ4kNFxeC1bAIqEo8+ToTbAOvgItEy+GJTBDb
	FCSWLYeIcwq4SmzfcpkRxBYCqmn+/J5pAiPvAkaGVYyiqQXJBcVJ6bmGesWJucWleel6yfm5
	mxjBEftMagfjygaLQ4wCHIxKPLwOa/eGCLEmlhVX5h5ilOBgVhLhnfAUKMSbklhZlVqUH19U
	mpNafIjRFOiqicxSosn5wGSSVxJvaGxiZmRpZG5oYWRsriTOq2TfFiIkkJ5YkpqdmlqQWgTT
	x8TBKdXA2FN77pWd5JdtmRuLoh9vX7Aj5PnTlUEpe2vPLHAU+OnFcvCKetC6mcwKk/IND2x/
	1rJr8RYZiWV2qbubmJ93+HYuPzDZ8Zz+0c+rRK0XdCc8+Z0245TZLql/kuskGJlZDcPd/79Q
	aKmY3xB8mHPSaY0dUi7brlexd9ib7px9cLvBU0vrx95r3iqxFGckGmoxFxUnAgD034Ms7gIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add PPMU (Platform Performance Monitoring Unit) dt node for Exynos4
(Exynos4210/4212/4412) SoC. PPMU dt node is used to monitor the utilization of
each IP.

The Exynos4210/Exynos4212/Exynos4412 SoC includes following PPMUs:
- PPMU_DMC0      0x106A_0000
- PPMU_DMC1      0x106B_0000
- PPMU_CPU       0x106C_0000
- PPMU_ACP       0x10AE_0000
- PPMU_RIGHT_BUS 0x112A_0000
- PPMU_LEFT_BUS  0x116A_0000
- PPMU_FSYS      0x1263_0000
- PPMU_LCD0      0x11E4_0000
- PPMU_CAMIF     0x11AC_0000
- PPMU_IMAGE     0x12AA_0000
- PPMU_TV        0x12E4_0000
- PPMU_3D        0x1322_0000
- PPMU_MFC_LEFT  0x1366_0000
- PPMU_MFC_RIGHT 0x1367_0000

Additionally, the Exynos4210 SoC includes following PPMUs:
- PPMU_LCD1      0x1224_0000

Cc: Kukjin Kim <kgene@kernel.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 arch/arm/boot/dts/exynos4.dtsi    | 108 ++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos4210.dtsi |   8 +++
 2 files changed, 116 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index b8168f1..70064dc 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -645,4 +645,112 @@
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
+	ppmu_acp: ppmu_acp@10ae0000 {
+		compatible = "samsung,exynos-ppmu";
+		reg = <0x106e0000 0x2000>;
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
+	ppmu_fsys: ppmu_g3d@12630000 {
+		compatible = "samsung,exynos-ppmu";
+		reg = <0x12630000 0x2000>;
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
+	ppmu_mfc_left: ppmu_mfc_left@13660000 {
+		compatible = "samsung,exynos-ppmu";
+		reg = <0x13660000 0x2000>;
+		clocks = <&clock CLK_PPMUMFC_L>;
+		clock-names = "ppmu";
+		status = "disabled";
+	};
+
+	ppmu_mfc_right: ppmu_mfc_right@13670000 {
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

