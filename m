Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbbAZERW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 23:17:22 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:35520 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbbAZEQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 23:16:49 -0500
X-AuditID: cbfee691-f79b86d000004a5a-cf-54c5bfa5034b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        sangbae90.lee@samsung.com, inki.dae@samsung.com, cw00.choi@samsung.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v10 5/7] ARM: dts: Add PPMU dt node for Exynos4 SoCs
Date: Mon, 26 Jan 2015 13:16:31 +0900
Message-id: <1422245793-8552-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1422245793-8552-1-git-send-email-cw00.choi@samsung.com>
References: <1422245793-8552-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWyRsSkQHfp/qMhBqt7LS0er1nMZLFxxnpW
	i+tfnrNaTLo/gcXi9QtDi/7Hr5ktzja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27ReveI+wWxz8dZLFYtesPo4Ogx5p5axg9ds66y+6xeM9LJo9NqzrZPDYvqffo
	27KK0ePzJrkA9igum5TUnMyy1CJ9uwSujC8H1rMVHFGu+LK/ib2BcY9MFyMnh4SAicT5Hb3M
	ELaYxIV769lAbCGBpYwS/7s5YWqW/N/F1MXIBRSfzihxr/00C4TTxCSx4dorFpAqNgEtif0v
	boB1iwjoSXQe28MOUsQsMJ1ZYvKCiawgCWEBF4mWNdeYQGwWAVWJ5Zf/gtm8QPHOd4fYINYp
	SCxbPhOsnlPAVWJiw3PGLkYOoG0uEt+/c4HMlBD4yi7x9+1vqDkCEt8mH2IBqZEQkJXYdADq
	G0mJgytusExgFF7AyLCKUTS1ILmgOCm9yFSvODG3uDQvXS85P3cTIzC2Tv97NnEH4/0D1ocY
	BTgYlXh4NRqPhgixJpYVV+YeYjQF2jCRWUo0OR8YwXkl8YbGZkYWpiamxkbmlmZK4rw60j+D
	hQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTCqbNNQTbLWNLka+ZxrxYV75wVltfYYvb5Rk57w
	8EGAs9GGpDDVNULL37oKrOkVeOwhx9Mwb9GqeaH5rjwb7MxeBOxIbE0N31PUfsIizl7um2P8
	p5ys20t/NmydJX2z6620X75icN+if5ar4uTfPVu69umVR7s6JCcfZ5txZvvi3+wHGraHrJ+h
	xFKckWioxVxUnAgAOek3PagCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t9jQd2l+4+GGJyYoG/xeM1iJouNM9az
	Wlz/8pzVYtL9CSwWr18YWvQ/fs1scbbpDbvFpsfXWC0u75rDZvG59wijxYzz+5gsll6/yGRx
	u3EFm8XjFW/ZLVr3HmG3OP7pIIvFql1/GB0EPdbMW8PosXPWXXaPxXteMnlsWtXJ5rF5Sb1H
	35ZVjB6fN8kFsEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5
	+AToumXmAH2gpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcz4cmA9W8ER
	5Yov+5vYGxj3yHQxcnJICJhILPm/iwnCFpO4cG89WxcjF4eQwHRGiXvtp1kgnCYmiQ3XXrGA
	VLEJaEnsf3GDDcQWEdCT6Dy2hx2kiFlgOrPE5AUTWUESwgIuEi1rroGNZRFQlVh++S+YzQsU
	73x3iA1inYLEsuUzweo5BVwlJjY8Z+xi5ADa5iLx/TvXBEbeBYwMqxhFUwuSC4qT0nMN9YoT
	c4tL89L1kvNzNzGCY/eZ1A7GlQ0WhxgFOBiVeHgbmo+GCLEmlhVX5h5ilOBgVhLhLZ8CFOJN
	SaysSi3Kjy8qzUktPsRoCnTURGYp0eR8YFrJK4k3NDYxM7I0Mje0MDI2VxLnVbJvCxESSE8s
	Sc1OTS1ILYLpY+LglGpgrK4VnPjh+HPuW7wryxfpB2yc6D9p28+ADxlzl7xdt9JrUYXL2ndO
	25P5ZmYYWH31cL228vLp2/Xp91mC/bZdmG8001j2XRtf+o4nf5i2XjS4nnnpse+Cf+tW3bc+
	vV31epPPiY+fZmZxf5qbV75INd/7hKLN8bO5Lxyu8vw8EFY4u/7c2vznXOuUWIozEg21mIuK
	EwEM1dj18wIAAA==
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

