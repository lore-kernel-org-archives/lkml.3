Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbbAGXwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:52:38 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:14581 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928AbbAGXvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:51:25 -0500
X-AuditID: cbfee68f-f791c6d000004834-89-54adc6783b8b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCHv7 08/10] ARM: dts: Add PPMU dt node for Exynos5260 SoC
Date: Thu, 08 Jan 2015 08:51:15 +0900
Message-id: <1420674677-3077-9-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1420674677-3077-1-git-send-email-cw00.choi@samsung.com>
References: <1420674677-3077-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWyRsSkSLfi2NoQgzWnZC0er1nMZLFxxnpW
	i+tfnrNaTLo/gcViSTO3xesXhhb9j18zW5xtesNusenxNVaLy7vmsFl87j3CaDHj/D4mi6XX
	LzJZ3G5cwWbxeMVbdovWvUfYLVbt+sPoIOixZt4aRo+ds+6yeyze85LJY9OqTjaPzUvqPfq2
	rGL0+LxJLoA9issmJTUnsyy1SN8ugStjf+cmtoJN0hWbnp1nbGA8JNrFyMkhIWAi8fndWRYI
	W0ziwr31bF2MXBxCAksZJR4eec4KU3Tt3FdmiMQiRonuRwdYIJwmJompi2ewg1SxCWhJ7H9x
	gw3EFhHQk+g8tocdpIhZYCmzxP75t8CKhAXcJKb+WgM2lkVAVeLcrS1gNq+Ai8TKV9ug1ilI
	LFs+E8zmFHCVWLp5ITOILQRU87LnFyPIUAmBj+wSu36+YYMYJCDxbfIhoJM4gBKyEpsOMEPM
	kZQ4uOIGywRG4QWMDKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxAqPr9L9n/TsY7x6wPsQo
	wMGoxMNb0LcmRIg1say4MvcQoynQhonMUqLJ+cAYziuJNzQ2M7IwNTE1NjK3NFMS510o9TNY
	SCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6PG0Ql83HKzGmRSjsaJCEn/4XUpst1fw9zreVUs
	61tnW1I5X8dzZb0DPdzrrtrfnlGW15Dw8nJiyJTdHIy3fdLu2E06scTZjTeORSHr76JC4xsB
	d37ws0RNCpJ8lid6RfrF50RuG/YtGqkrTF6JyChFM9ZFi6w2Y/jPckZq18zsqsw2jx0+SizF
	GYmGWsxFxYkADOyQvKkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t9jAd2KY2tDDNa/FrZ4vGYxk8XGGetZ
	La5/ec5qMen+BBaLJc3cFq9fGFr0P37NbHG26Q27xabH11gtLu+aw2bxufcIo8WM8/uYLJZe
	v8hkcbtxBZvF4xVv2S1a9x5ht1i16w+jg6DHmnlrGD12zrrL7rF4z0smj02rOtk8Ni+p9+jb
	sorR4/MmuQD2qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRef
	AF23zBygB5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGfs7N7EVbJKu
	2PTsPGMD4yHRLkZODgkBE4lr574yQ9hiEhfurWfrYuTiEBJYxCjR/egAC4TTxCQxdfEMdpAq
	NgEtif0vbrCB2CICehKdx/awgxQxCyxlltg//xZYkbCAm8TUX2tYQWwWAVWJc7e2gNm8Ai4S
	K19tY4VYpyCxbPlMMJtTwFVi6eaFYGcIAdW87PnFOIGRdwEjwypG0dSC5ILipPRcQ73ixNzi
	0rx0veT83E2M4Nh9JrWDcWWDxSFGAQ5GJR7egr41IUKsiWXFlbmHGCU4mJVEeNe2rQ0R4k1J
	rKxKLcqPLyrNSS0+xGgKdNVEZinR5HxgWskriTc0NjEzsjQyN7QwMjZXEudVsm8LERJITyxJ
	zU5NLUgtgulj4uCUamDUsljdtDokRvLLUvEJvW53hO8VuD+5Ndf+sYQGx3eZF3uSX+Vs3iTz
	KPn6dr3T+5bF2rrVF2/89OtT61TtOV++pCkEerDM0uCYmn7q5iGBlqXMPlZZu2dUnPNKFWte
	zNt+ML1POn+LbWOdI39LwNbFi96uCTl3WcsvQc6msEiypLb8/bMt0s+VWIozEg21mIuKEwEa
	AGFI8wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds PPMU (Performance Profiling Monitoring Unit) dt node
Exynos5260 SoC.

Exynos5260 SoC has following PPMU IPs:
- PPMU_DREX0_S0 0x10c60000
- PPMU_DREX0_S1 0x10c70000
- PPMU_DREX1_S0 0x10c80000
- PPMU_DREX1_S1 0x10c90000
- PPMU_EAGLE    0x10cc0000
- PPMU_KFC      0x10cd0000
- PPMU_MFC      0x11040000
- PPMU_G3D      0x11880000
- PPMU_FSYS     0x12220000
- PPMU_ISP      0x13370000
- PPMU_FICM     0x13cb0000
- PPMU_GSCL     0x13e60000
- PPMU_MSCL     0x13ee0000
- PPMU_FIMD0X   0x145b0000
- PPMU_FIMD1X   0x145c0000

The drivers/devfreq/exynos/exynos5_bus.c supports the memory bus frequency/
voltage scaling of Exynos5260 SoC with DEVFREQ framework.

Cc: Kukjin Kim <kgene@kernel.org>
Cc: Abhilash Kesavan <a.kesavan@samsung.com>
Cc: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/boot/dts/exynos5260.dtsi | 90 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5260.dtsi b/arch/arm/boot/dts/exynos5260.dtsi
index 36da38e..26f3074 100644
--- a/arch/arm/boot/dts/exynos5260.dtsi
+++ b/arch/arm/boot/dts/exynos5260.dtsi
@@ -307,6 +307,96 @@
 			fifo-depth = <64>;
 			status = "disabled";
 		};
+
+		ppmu_drex0_s0: ppmu_drex0_s0@10c60000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x10c60000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_drex0_s1: ppmu_drex0_s1@10c70000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x10c70000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_drex1_s0: ppmu_drex1_s0@10c80000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x10c80000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_drex1_s1: ppmu_drex1_s1@10c90000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x10c90000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_eagle: ppmu_eagle@10cc0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x10cc0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_kfc: ppmu_kfc@10cd0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x10cd0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_mfc: ppmu_mfc@11040000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x11040000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_g3d: ppmu_g3d@11880000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x11880000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_fsys: ppmu_fsys@12220000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x12220000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_isp: ppmu_isp@13370000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x13370000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_fimc: ppmu_fimc@13cb0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x13cb0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_gscl: ppmu_gscl@13e60000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x13e60000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_mscl: ppmu_gscl@13ee0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x13ee0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_fimd0x: ppmu_fimd0x@145b0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x145b0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_fimd1x: ppmu_fimd1x@145c0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x145c0000 0x2000>;
+			status = "disabled";
+		};
 	};
 };
 
-- 
1.8.5.5

