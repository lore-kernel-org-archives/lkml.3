Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbbALMfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:35:20 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:22243 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbbALMfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:35:13 -0500
X-AuditID: cbfee691-f79b86d000004a5a-83-54b3bf752e5d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kgene@kernel.org
Cc: kyungmin.park@samsung.com, rafael.j.wysocki@intel.com,
        mark.rutland@arm.com, a.kesavan@samsung.com, tomasz.figa@gmail.com,
        k.kozlowski@samsung.com, b.zolnierkie@samsung.com, robh+dt@kernel.org,
        cw00.choi@samsung.com, inki.dae@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv8 5/9] ARM: dts: Add PPMU dt node for Exynos3250 SoC
Date: Mon, 12 Jan 2015 21:34:53 +0900
Message-id: <1421066097-26237-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1421066097-26237-1-git-send-email-cw00.choi@samsung.com>
References: <1421066097-26237-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42JZI2JSolu6f3OIwfb5/BaP1yxmstg4Yz2r
	xfUvz1ktJt2fwGLx+oWhRf/j18wWZ5vesFtsenyN1eLyrjlsFp97jzBazDi/j8li6fWLTBa3
	G1ewWTxe8ZbdonXvEXaLVbv+MDoIeKyZt4bRY+esu+wei/e8ZPLYtKqTzWPzknqPvi2rGD0+
	b5ILYI/isklJzcksSy3St0vgynj7/htjwRXxirUP1jA3MB4Q6mLk5JAQMJFYcvsgG4QtJnHh
	3nowW0hgKaPElU0yMDV991azdDFyAcUXMUo07fjGCuE0MUnc7L3IBFLFJqAlsf/FDbBuEQE9
	ic5je9hBbGaBP0wSTZtYQGxhAReJhZ3fwGwWAVWJyWeXMYLYvAKuEl177jBCbFOQWLZ8JiuI
	zSngJvFu9xqgmRxAy1wlbqyvB9krIfCSXeLa/GdsEHMEJL5NPsQCUiMhICux6QAzxBhJiYMr
	brBMYBRewMiwilE0tSC5oDgpvchUrzgxt7g0L10vOT93EyMwnk7/ezZxB+P9A9aHGAU4GJV4
	eC2kNocIsSaWFVfmHmI0BdowkVlKNDkfGLV5JfGGxmZGFqYmpsZG5pZmSuK8OtI/g4UE0hNL
	UrNTUwtSi+KLSnNSiw8xMnFwSjUwRke94eM0WLaF2V6c+czl/0XGv9I5nh02rpy98GPYxIfO
	N0ykBBf0Wm+/mCye+mL/ZJb4H01LTRT8X+XpVPyq8J6rcPiTSsUj5v8qXDxnA6xM+NZODNm/
	fv83hY0HeBZmnvvtGJJ89cb8354fJ5qWZXR96MusKOaN+vt1tdXD4sAddnMcw6bcVmIpzkg0
	1GIuKk4EAE3YVceiAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jAd3S/ZtDDFYeZLN4vGYxk8XGGetZ
	La5/ec5qMen+BBaL1y8MLfofv2a2ONv0ht1i0+NrrBaXd81hs/jce4TRYsb5fUwWS69fZLK4
	3bgCqH/FW3aL1r1H2C1W7frD6CDgsWbeGkaPnbPusnss3vOSyWPTqk42j81L6j36tqxi9Pi8
	SS6APaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH
	6HglhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bb998YC66IV6x9sIa5
	gfGAUBcjJ4eEgIlE373VLBC2mMSFe+vZuhi5OIQEFjFKNO34xgrhNDFJ3Oy9yARSxSagJbH/
	xQ02EFtEQE+i89gedhCbWeAPk0TTJrBJwgIuEgs7v4HZLAKqEpPPLmMEsXkFXCW69txhhNim
	ILFs+UxWEJtTwE3i3e41QDM5gJa5StxYXz+BkXcBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k
	/NxNjOB4fSa1g3Flg8UhRgEORiUeXgupzSFCrIllxZW5hxglOJiVRHhdy4BCvCmJlVWpRfnx
	RaU5qcWHGE2BjprILCWanA9MJXkl8YbGJmZGlkbmhhZGxuZK4rxK9m0hQgLpiSWp2ampBalF
	MH1MHJxSDYxTXs+ROi7/6exW852sVYULJjmY//vx0fpA754fZYc7xdRrtl7m05Fv2WM553em
	1DrBtX/3fVr2UUd3yf28zu5J93dLXo4W1lBelMDv4vX5uT6nw+7Ar0vPTtKRCTAqbmGvTFmz
	xvTNxxlbMtomCsutq5Ap3LCw2Knu7qHMXUv3JH4yOuxXwCakxFKckWioxVxUnAgAncubIO0C	AAA=
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
index 2246549..9ed1260 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -515,6 +515,80 @@
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

