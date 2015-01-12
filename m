Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbbALMfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:35:16 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:12725 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbbALMfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:35:08 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-45-54b3bf754248
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCHv8 7/9] ARM: dts: Add PPMU dt node for Exynos5260 SoC
Date: Mon, 12 Jan 2015 21:34:55 +0900
Message-id: <1421066097-26237-8-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421066097-26237-1-git-send-email-cw00.choi@samsung.com>
References: <1421066097-26237-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsWyRsSkULd0/+YQg/+PZC0er1nMZLFxxnpW
	i+tfnrNaTLo/gcViSTO3xesXhhb9j18zW5xtesNusenxNVaLy7vmsFl87j3CaDHj/D4mi6XX
	LzJZ3G5cwWbxeMVbdovWvUfYLVbt+sPoIOixZt4aRo+ds+6yeyze85LJY9OqTjaPzUvqPfq2
	rGL0+LxJLoA9issmJTUnsyy1SN8ugStjf+cmtoJN0hWbnp1nbGA8JNrFyMkhIWAi0XjwJCOE
	LSZx4d56ti5GLg4hgaWMEle2zmOCKeq4+YoFIrGIUeLFjwZ2CKeJSeJm70WwKjYBLYn9L26w
	gdgiAnoSncf2gBUxCyxlltg//xaQw8EhLOAicfe0GEgNi4CqxJk968B6eQVcJbY3HmKD2KYg
	sWz5TFYQm1PATeLd7jVsIK1CQDU31tdDlHxkl9jwMQFijIDEt8mHWEBKJARkJTYdYIYokZQ4
	uOIGywRG4QWMDKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxAuPq9L9nE3Yw3jtgfYhRgINR
	iYfXQmpziBBrYllxZe4hRlOgDROZpUST84HRm1cSb2hsZmRhamJqbGRuaaYkzvta6mewkEB6
	YklqdmpqQWpRfFFpTmrxIUYmDk6pBkZPw/YPn/+ar4pR7U37vLbbryTUk48lPeDCvsmP0rf5
	1HSJMj/QXL9wOYd+XvNUuSX3Lmmb118WcLSazzrDLSR/l1rl46mv30mEy/I7SB59uVf8m17I
	+7BX+k8i5p4oqpMXbggLyE3q4np28MeDosvqCqsOeMtvPNnodEZo2rwr0XU5ppEOjUosxRmJ
	hlrMRcWJAG+oTDqmAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t9jAd3S/ZtDDJbMFrV4vGYxk8XGGetZ
	La5/ec5qMen+BBaLJc3cFq9fGFr0P37NbHG26Q27xabH11gtLu+aw2bxufcIo8WM8/uYLJZe
	v8hkcbtxBZvF4xVv2S1a9x5ht1i16w+jg6DHmnlrGD12zrrL7rF4z0smj02rOtk8Ni+p9+jb
	sorR4/MmuQD2qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRef
	AF23zBygB5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhDWMGfs7N7EVbJKu
	2PTsPGMD4yHRLkZODgkBE4mOm69YIGwxiQv31rN1MXJxCAksYpR48aOBHcJpYpK42XuRCaSK
	TUBLYv+LG2wgtoiAnkTnsT1gRcwCS5kl9s+/BeRwcAgLuEjcPS0GUsMioCpxZs86sF5eAVeJ
	7Y2H2CC2KUgsWz6TFcTmFHCTeLd7DRtIqxBQzY319RMYeRcwMqxiFE0tSC4oTkrPNdQrTswt
	Ls1L10vOz93ECI7bZ1I7GFc2WBxiFOBgVOLhtZDaHCLEmlhWXJl7iFGCg1lJhNe1DCjEm5JY
	WZValB9fVJqTWnyI0RToqInMUqLJ+cCUklcSb2hsYmZkaWRuaGFkbK4kzqtk3xYiJJCeWJKa
	nZpakFoE08fEwSnVwGg8IX+ng3rJ7v6+tynJwjo5ZkFdUpPdnk2YlnJOrCjvoVTMY44Fb10+
	cG0SWq65d+KpkOQWI9vGgjhp4f9HDngEvzUq9dnyoPjZ1SA/1tPnt516v+Pbw7h9Us9vTk7Z
	n/fjA4Pi3xWhQsFTvn/IYz392fWJq+thUdY7TraHjTytfaqeVM97XqLEUpyRaKjFXFScCAAi
	9B7Y8QIAAA==
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

