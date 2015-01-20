Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbbATHKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 02:10:40 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:8291 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbbATHKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 02:10:36 -0500
X-AuditID: cbfee68e-f79b46d000002b74-d0-54bdff56c13d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v9 4/7] ARM: dts: Add PPMU dt node for Exynos3250 SoC
Date: Tue, 20 Jan 2015 16:10:06 +0900
Message-id: <1421737809-4010-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421737809-4010-1-git-send-email-cw00.choi@samsung.com>
References: <1421737809-4010-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIIsWRmVeSWpSXmKPExsWyRsSkUDfs/94Qg97rKhaP1yxmstg4Yz2r
	xfUvz1ktJt2fwGLx+oWhRf/j18wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdonXvEXaLVbv+MDoIeKyZt4bRY+esu+wei/e8ZPLYtKqTzWPzknqPvi2rGD0+
	b5ILYI/isklJzcksSy3St0vgyli+ZglLwRXxillLPjA2MB4Q6mLk5JAQMJHoP7OJGcIWk7hw
	bz1bFyMXh5DAUkaJLzdeMcIUTfl8lwkisYhRYsHhWywQThOTxIGZ99hAqtgEtCT2v7gBZosI
	6El0HtvDDmIzC/xhkmjaxAJiCwu4Ssy7vh/MZhFQlbiycQ3YBl4BF4meIzdZIbYpSCxbPhPM
	5gSq377lMliNEFBN8+f3YFdICDxilzjx+is7xCABiW+TDwEN5QBKyEpsOgD1jqTEwRU3WCYw
	Ci9gZFjFKJpakFxQnJReZKRXnJhbXJqXrpecn7uJERhTp/8969vBePOA9SFGAQ5GJR7el6v2
	hgixJpYVV+YeYjQF2jCRWUo0OR8YuXkl8YbGZkYWpiamxkbmlmZK4rwJUj+DhQTSE0tSs1NT
	C1KL4otKc1KLDzEycXBKNTAWLRRT29H2QPF1cTWrkdnaJSmnrmwVM5mjJJG8heOhRMLGuJcy
	G2NZ552w2qC4Xrdp878eH8P9kgf4GvjvfjXjuufAMWVPV+qhv9ozjW64npV6FLak9UM9R67g
	Bw5RTtmjUyTPLv3yYlafbLf23N7jBYVPVZY4blLPqlih9ZzzreK/ZQIvK9uUWIozEg21mIuK
	EwEjN3JPpAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAd2w/3tDDJ7+krF4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3biCzeLxirfsFq17j7BbrNr1h9FBwGPNvDWMHjtn3WX3WLznJZPHplWdbB6bl9R79G1Zxejx
	eZNcAHtUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+Arltm
	DtDxSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCGsaM5WuWsBRcEa+YteQD
	YwPjAaEuRk4OCQETiSmf7zJB2GISF+6tZ+ti5OIQEljEKLHg8C0WCKeJSeLAzHtsIFVsAloS
	+1/cALNFBPQkOo/tYQexmQX+MEk0bWIBsYUFXCXmXd8PZrMIqEpc2biGEcTmFXCR6DlykxVi
	m4LEsuUzwWxOoPrtWy6D1QgB1TR/fs80gZF3ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95Pzc
	TYzgiH0mtYNxZYPFIUYBDkYlHl6HtXtDhFgTy4orcw8xSnAwK4nwTngKFOJNSaysSi3Kjy8q
	zUktPsRoCnTVRGYp0eR8YDLJK4k3NDYxM7I0Mje0MDI2VxLnVbJvCxESSE8sSc1OTS1ILYLp
	Y+LglGpgLL40VfT4stRpD/KPCs2clnHI0d5C+qDUxbMfn7+MdL0gMWOjZP5j69Mp5SmcXxwu
	eaV+5LvZfOWL6XXjbN8bnH5vX/6SVF6nECSxwcBp76L70yd53eaa6JndbMV/gtOrYUueocsi
	Z0bxG08e/v1moJK392Jl4JJ/aWEbY0ouFPavWlMutSsvUImlOCPRUIu5qDgRAPc0KXDuAgAA
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

