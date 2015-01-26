Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbbAZERJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 23:17:09 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:24225 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbbAZEQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 23:16:41 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-ee-54c5bfa51c35
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        sangbae90.lee@samsung.com, inki.dae@samsung.com, cw00.choi@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v10 4/7] ARM: dts: Add PPMU dt node for Exynos3250 SoC
Date: Mon, 26 Jan 2015 13:16:30 +0900
Message-id: <1422245793-8552-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1422245793-8552-1-git-send-email-cw00.choi@samsung.com>
References: <1422245793-8552-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWyRsSkWHfp/qMhBmsbdS0er1nMZLFxxnpW
	i+tfnrNaTLo/gcXi9QtDi/7Hr5ktzja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27ReveI+wWxz8dZLFYtesPo4Ogx5p5axg9ds66y+6xeM9LJo9NqzrZPDYvqffo
	27KK0ePzJrkA9igum5TUnMyy1CJ9uwSujOVrlrAUXBGvmLXkA2MD4wGhLkZODgkBE4mbK74x
	QdhiEhfurWfrYuTiEBJYyiix9+s8Fpiiy4cWM0EkpjNKrN/6ihXCaWKS2HDtFVgVm4CWxP4X
	N9hAbBEBPYnOY3vYQYqYBaYzS0xeMJEVJCEs4Cbx8N0ddhCbRUBV4vDkV4wgNq+Ai0TTm0lQ
	6xQkli2fCVbPKeAqMbHhOVANB9A2F4nv37lAZkoIfGWXOP8LYiaLgIDEt8mHWEBqJARkJTYd
	YIYYIylxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525iBEbX6X/PJuxgvHfA
	+hCjAAejEg9vQ/PRECHWxLLiytxDjKZAGyYyS4km5wNjOK8k3tDYzMjC1MTU2Mjc0kxJnPe1
	1M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYw1DdFirOkSP03OpmnIzWia2uGtO8NsduyN
	zpdNxnWbSnYLGiTaFEhsfPletZ5BVfn7B16/CW+2bJ2w4P6ie07LWusX3vNZIiObfr7f3Vv6
	QVnerhk5vGzuLOmJa/Ucp/qXq2ZJSB2tz9c1WBEoLVsZ8ii/UnfjBu0dLCsdajWU6hykZjdV
	KrEUZyQaajEXFScCAP2sSMepAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t9jQd2l+4+GGPQ+VrF4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFq17j7BbHP90kMVi1a4/jA6CHmvmrWH02DnrLrvH4j0vmTw2repk89i8pN6j
	b8sqRo/Pm+QC2KMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVc
	fAJ03TJzgD5QUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGYsX7OEpeCK
	eMWsJR8YGxgPCHUxcnJICJhIXD60mAnCFpO4cG89WxcjF4eQwHRGifVbX7FCOE1MEhuuvWIB
	qWIT0JLY/+IGG4gtIqAn0XlsDztIEbPAdGaJyQsmsoIkhAXcJB6+u8MOYrMIqEocnvyKEcTm
	FXCRaHoziQVinYLEsuUzweo5BVwlJjY8B6rhANrmIvH9O9cERt4FjAyrGEVTC5ILipPSc430
	ihNzi0vz0vWS83M3MYJj95n0DsZVDRaHGAU4GJV4eDUaj4YIsSaWFVfmHmKU4GBWEuEtnwIU
	4k1JrKxKLcqPLyrNSS0+xGgKdNREZinR5HxgWskriTc0NjEzsjQyN7QwMjZXEudVsm8LERJI
	TyxJzU5NLUgtgulj4uCUamBc9qklQ6HgaoeE6Ou1fLYPxNmuB/TOYPzK8+eu0dMwLWNfj/7P
	cUs8Gk6pXolJCnVenfb03QRlvfg157q6pqnYrm5Y2LhH0Uzzu+P6JvsLe6a/lqpITZnXNXOl
	Zu9rxxhFU0W/ire8a7o9E06mpaTuUayfzJdm9s/lYoPT76fcbE/t0pqf/VViKc5INNRiLipO
	BABWOXgD8wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add PPMU (Platform Performance Monitoring Unit) dt node
to estimate the utilization of each IP in Exynos SoC throught DEVFREQ Event
subsystem.

This patch adds following PPMU dt nodes:
- PPMU_DMC0     0x106a0000
- PPMU_DMC1     0x106b0000
- PPMU_RIGHTBUS 0x112A0000
- PPMU_LEFTBUS  0x116A0000
- PPMU_CAMIF    0x11AC0000
- PPMU_LCD0     0x11E40000
- PPMU_FSYS     0x12630000
- PPMU_3D       0x13220000
- PPMU_MFC      0x13660000
- PPMU_CPU      0x106c0000

Cc: Kukjin Kim <kgene@kernel.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 74 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index d89fdf5..45513ed 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -530,6 +530,80 @@
 			compatible = "arm,cortex-a7-pmu";
 			interrupts = <0 18 0>, <0 19 0>;
 		};
+
+		ppmu_dmc0: ppmu_dmc0@106a0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x106a0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_dmc1: ppmu_dmc1@106b0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x106b0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_cpu: ppmu_cpu@106c0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x106c0000 0x2000>;
+			status = "disabled";
+		};
+
+		ppmu_rightbus: ppmu_rightbus@112a0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x112a0000 0x2000>;
+			clocks = <&cmu CLK_PPMURIGHT>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+		ppmu_leftbus: ppmu_leftbus0@116a0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x116a0000 0x2000>;
+			clocks = <&cmu CLK_PPMULEFT>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+		ppmu_camif: ppmu_camif@11ac0000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x11ac0000 0x2000>;
+			clocks = <&cmu CLK_PPMUCAMIF>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+		ppmu_lcd0: ppmu_lcd0@11e40000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x11e40000 0x2000>;
+			clocks = <&cmu CLK_PPMULCD0>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+		ppmu_fsys: ppmu_fsys@12630000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x12630000 0x2000>;
+			clocks = <&cmu CLK_PPMUFILE>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+		ppmu_g3d: ppmu_g3d@13220000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x13220000 0x2000>;
+			clocks = <&cmu CLK_PPMUG3D>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+		ppmu_mfc: ppmu_mfc@13660000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x13660000 0x2000>;
+			clocks = <&cmu CLK_PPMUMFC_L>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
 	};
 };
 
-- 
1.8.5.5

