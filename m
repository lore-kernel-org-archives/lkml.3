Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaLPX1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 18:27:19 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:43913 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaLPX1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 18:27:06 -0500
X-AuditID: cbfee68e-f79b46d000002b74-ba-5490bfc56ece
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rafael.j.wysocki@intel.com, mark.rutland@arm.com,
        a.kesavan@samsung.com, tomasz.figa@gmail.com, k.kozlowski@samsung.com,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv4 6/8] ARM: dts: Add PPMU dt node for Exynos4 SoCs
Date: Wed, 17 Dec 2014 08:26:55 +0900
Message-id: <1418772417-5164-7-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1418772417-5164-1-git-send-email-cw00.choi@samsung.com>
References: <1418772417-5164-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42JZI2JSqHt0/4QQg/uX1Swer1nMZHH9y3NW
	i/lHzrFaTLo/gcXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF0usXmSxu
	N65gs3i84i27xapdfxgd+D3WzFvD6LFz1l12j8V7XjJ5bF5S79G3ZRWjx+dNcgFsUVw2Kak5
	mWWpRfp2CVwZs37eZC+YplzRMuUUawPjZJkuRk4OCQETiWs/VzFB2GISF+6tZwOxhQSWMkpM
	7OGCqdnbeA4qvohR4m57FoTdxCRx+7oyiM0moCWx/8UNsBoRARmJqxu3s3QxcnEwCzQyS3xZ
	9h9sgbCAk8TF+93MIDaLgKpEz8U/LCA2r4CLxOnvOxkhlilILFs+kxXE5hRwlWi5sZoJYpmL
	ROfVnawQNdfYJVaeTYWYIyDxbfIhoDkcQHFZiU0HmCFKJCUOrrjBMoFReAEjwypG0dSC5ILi
	pPQiI73ixNzi0rx0veT83E2MwMg5/e9Z3w7GmwesDzEKcDAq8fAGFvaHCLEmlhVX5h5iNAXa
	MJFZSjQ5HxifeSXxhsZmRhamJqbGRuaWZkrivAlSP4OFBNITS1KzU1MLUovii0pzUosPMTJx
	cEo1MM7vfqb7ecOdCX5iPZ+adOWWrN7W2DzdR+L7u67V4k+zctttjK/q9d26dYDxkuql+8Kn
	LC7/tjL7be+58uz9tdzWsvbOG8wrL3hH2fHNq7gR/3z2g5t7Gk68YTjwszVUaGnTjHg3vgO+
	6x9z+S5pOmgzz1Ft3aO9banRLxv8ubSbHxyZV1qeeVKJpTgj0VCLuag4EQDA3xoflwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t9jAd2j+yeEGLTOkLN4vGYxk8X1L89Z
	LeYfOcdqMen+BBaL1y8MLXoXXGWzONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFqt2/WF04PdYM28No8fOWXfZPRbvecnksXlJvUffllWMHp83yQWwRTUw2mSk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAnaykUJaYUwoU
	CkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzJj18yZ7wTTlipYpp1gbGCfLdDFyckgI
	mEjsbTzHBmGLSVy4tx7MFhJYxChxtz0Lwm5ikrh9XRnEZhPQktj/4gZYjYiAjMTVjdtZuhi5
	OJgFGpklviz7zwSSEBZwkrh4v5sZxGYRUJXoufiHBcTmFXCROP19JyPEMgWJZctnsoLYnAKu
	Ei03VjNBLHOR6Ly6k3UCI+8CRoZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMGx+Ux6B+Oq
	BotDjAIcjEo8vIGF/SFCrIllxZW5hxglOJiVRHgtFk0IEeJNSaysSi3Kjy8qzUktPsRoCnTV
	RGYp0eR8YNrIK4k3NDYxM7I0Mje0MDI2VxLnVbJvCxESSE8sSc1OTS1ILYLpY+LglGpgNCqZ
	V2oWkrbE+rhrQEZcS6HBQXGR3AcJ50++vJoi9/ONGc/i8yvCDifcm6d8+8pm9uXfZx1m57TM
	lZG1LsuZsjr46EGh1a9e7tH7azo/nGWNy7qL3Cs5HjFVfOJccEjmwf7Ph83lVhy/8NvaWceA
	3ezR4+q56hEsE9ytSq5bBdbMDPbaMPPcAiWW4oxEQy3mouJEAHUZBVPjAgAA
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

