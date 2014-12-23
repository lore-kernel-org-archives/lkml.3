Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbaLWDSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 22:18:37 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41892 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbaLWDSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 22:18:25 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-65-5498defb33ba
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv5 6/9] ARM: dts: Add PPMU dt node for Exynos4 SoCs
Date: Tue, 23 Dec 2014 12:18:14 +0900
Message-id: <1419304697-14789-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1419304697-14789-1-git-send-email-cw00.choi@samsung.com>
References: <1419304697-14789-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSovv73owQg0VHLCwer1nMZHH9y3NW
	i/lHzrFaTLo/gcXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27xapdfxgd+D3WzFvD6LFz1l12j8V7XjJ5bF5S79G3ZRWjx+dNcgFsUVw2Kak5
	mWWpRfp2CVwZs37eZC+YplzRMuUUawPjZJkuRk4OCQETif9brzFD2GISF+6tZ+ti5OIQEljK
	KNH8aT8jTNH+Y0vYIRKLGCUeH97LCOE0MUn8PfSVCaSKTUBLYv+LG2wgtoiAjMTVjdtZQIqY
	BRqZJb4s+w9WJCzgJLH7awPYWBYBVYk/d16xgNi8Aq4SR88sYIVYpyCxbPlMMJtTwE3iz7yn
	YLYQUM3EjutMIEMlBG6xSzxtO8EKMUhA4tvkQ0CDOIASshKbDkD9IylxcMUNlgmMwgsYGVYx
	iqYWJBcUJ6UXmegVJ+YWl+al6yXn525iBEbQ6X/PJuxgvHfA+hCjAAejEg/vwjMzQoRYE8uK
	K3MPMZoCbZjILCWanA+M07ySeENjMyMLUxNTYyNzSzMlcd7XUj+DhQTSE0tSs1NTC1KL4otK
	c1KLDzEycXBKNTD61ywtkW7INxUU6T10M+BikcW61Wt0PirtXfruW03/1rsyfKXc/FySm7N/
	XexTuy6y6OmKyQmTtx//7Rgytftf+Jp7s1+f4uCZrHLKXaN5uum6WKdq8fd5ORJbudeJrPea
	8/WIo+ja9C+nCxmvL2vMqg/XmvJy+bugdVVfA/YsDFy7uvtpegabEktxRqKhFnNRcSIAMDWH
	rZsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jAd3f92aEGHR1GFg8XrOYyeL6l+es
	FvOPnGO1mHR/AovF6xeGFr0LrrJZnG16w26x6fE1VovLu+awWXzuPcJoMeP8PiaLpdcvMlnc
	blzBZvF4xVt2i1W7/jA68HusmbeG0WPnrLvsHov3vGTy2Lyk3qNvyypGj8+b5ALYohoYbTJS
	E1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOATlZSKEvMKQUK
	BSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZsz6eZO9YJpyRcuUU6wNjJNluhg5OSQE
	TCT2H1vCDmGLSVy4t56ti5GLQ0hgEaPE48N7GSGcJiaJv4e+MoFUsQloSex/cYMNxBYRkJG4
	unE7C0gRs0Ajs8SXZf/BioQFnCR2f21gBLFZBFQl/tx5xQJi8wq4Shw9s4AVYp2CxLLlM8Fs
	TgE3iT/znoLZQkA1EzuuM01g5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzg+n0nv
	YFzVYHGIUYCDUYmHd8GZGSFCrIllxZW5hxglOJiVRHjVW4FCvCmJlVWpRfnxRaU5qcWHGE2B
	rprILCWanA9MHXkl8YbGJmZGlkbmhhZGxuZK4rxK9m0hQgLpiSWp2ampBalFMH1MHJxSDYyu
	U62fm0z59uVFZeQzjdjdi5gmXzltLdp0bPeafdUbWiodD0ce+x0l9svl1cowzlq9nZ8z23e9
	U/wix3jdfMnLo9KzrMJTmq5GnS75umxSd9ePmGkKL3l27G+JiNfZzL3SPf1Uh4v+l2nfQnbU
	79BYtKb8U0DJs16tPnN+hm/rJTiZ+IJN9XKUWIozEg21mIuKEwF5lNiK5QIAAA==
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

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 arch/arm/boot/dts/exynos4.dtsi    | 108 ++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/exynos4210.dtsi |   8 +++
 2 files changed, 116 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index e0278ec..5a5e3ab 100644
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

