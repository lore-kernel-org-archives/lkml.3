Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbaLIOPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:15:51 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26705 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305AbaLIONQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:13:16 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-77-548703742f5b
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, kgene.kim@samsung.com,
        rafael.j.wysocki@intel.com, a.kesavan@samsung.com,
        tomasz.figa@gmail.com, b.zolnierkie@samsung.com,
        k.kozlowski@samsung.com, cw00.choi@samsung.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC PATCHv2 5/7] ARM: dts: Add PPMU dt node for Exynos3250
Date: Tue, 09 Dec 2014 23:13:04 +0900
Message-id: <1418134386-14681-6-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.5.5
In-reply-to: <1418134386-14681-1-git-send-email-cw00.choi@samsung.com>
References: <1418134386-14681-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkRLeEuT3E4NY2BYvHaxYzWWycsZ7V
	4vqX56wW84+cY7V4/cLQonfBVTaLs01v2C02Pb7GanF51xw2i8+9RxgtZpzfx2Rxu3EFm8Xj
	FW/ZLVbt+sPowOexc9Zddo/Fe14yeWxeUu/Rt2UVo8fnTXIBrFFcNimpOZllqUX6dglcGb/O
	LmQq2CJacXWteAPjW4EuRk4OCQETiUkN19kgbDGJC/fWA9lcHEICSxkl7n5dxAhTdOPpUqjE
	IkaJ5sv/2CGcJiaJN7t2s4JUsQloSex/cQNslIiAlcTp/x3MIEXMAueZJJYs3M8MkhAWcJGY
	9+YZWBGLgKrEzqvTwOK8Aq4SN1d/YYJYpyCxbPlMsKGcAm4STbsbWUBsIaCaDydawTZLCBxj
	l9j29ioTxCABiW+TDwEVcQAlZCU2HWCGmCMpcXDFDZYJjMILGBlWMYqmFiQXFCelF5noFSfm
	Fpfmpesl5+duYgTGyul/zybsYLx3wPoQowAHoxIPr4ZlW4gQa2JZcWXuIUZToA0TmaVEk/OB
	EZlXEm9obGZkYWpiamxkbmmmJM77WupnsJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGnCYH
	/UnOHhPezZG2DXTVz6654M1zacuMHI7pU1feYjycdPZ8zPvGJUk3Vj+0LdtcpvH55iOZ05+M
	ju+dyKMidis741jdhMVTOcRaZK/cyZV5fT29jnHzxGemF2c8bL27kVdbsbzo5q8g0ZeBjnW9
	TVySFyyXhz7c0O0UHZiXyVu8PVz/K6OXEktxRqKhFnNRcSIA4v0yiJACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t9jAd0S5vYQg2tbJCwer1nMZLFxxnpW
	i+tfnrNazD9yjtXi9QtDi94FV9kszja9YbfY9Pgaq8XlXXPYLD73HmG0mHF+H5PF7cYVbBaP
	V7xlt1i16w+jA5/Hzll32T0W73nJ5LF5Sb1H35ZVjB6fN8kFsEY1MNpkpCampBYppOYl56dk
	5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAB2qpFCWmFMKFApILC5W0rfDNCE0
	xE3XAqYxQtc3JAiux8gADSSsYcz4dXYhU8EW0Yqra8UbGN8KdDFyckgImEjceLqUDcIWk7hw
	bz2QzcUhJLCIUaL58j92CKeJSeLNrt2sIFVsAloS+1/cAOsQEbCSOP2/gxmkiFngPJPEkoX7
	mUESwgIuEvPePAMrYhFQldh5dRpYnFfAVeLm6i9MEOsUJJYtnwk2lFPATaJpdyMLiC0EVPPh
	RCv7BEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCI/GZ1A7GlQ0WhxgFOBiVeHg1
	LdtChFgTy4orcw8xSnAwK4nwTjkKFOJNSaysSi3Kjy8qzUktPsRoCnTVRGYp0eR8YJLIK4k3
	NDYxM7I0Mje0MDI2VxLnVbIHahJITyxJzU5NLUgtgulj4uCUamBce/P6MZfNV+ZI+Ri0b74c
	6PMmvbbzYmCuzzNrn5rgNxkMOrM3nl586FSKzJd5vklM28S4+9+u27jtuu8+G4b2c9fe5dhO
	OcAkcqj22bTUrCedFnV3+5bOL+FI/sR9fA9DYuXi747zXgRH1/Ytnc6eZOG9OnaT/I4r32bd
	zr/h3R37QPVPx7o2JZbijERDLeai4kQAWtOGRNoCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add PPMU (Performance Profiling Monitoring Units) dt node
to estimate the utilization of each IP in Exynos SoC throught DEVFREQ Event
subsystem.

This patch adds following PPMU dt nodes:
- PPMU_DMC0	0x106a0000
- PPMU_DMC1	0x106b0000
- PPMU_RIGHTBUS 0x112A0000
- PPMU_LEFTBUS  0x116A0000
- PPMU_CAMIF    0x11AC0000
- PPMU_LCD0     0x11E40000
- PPMU_3D       0x13220000
- PPMU_MFC_L    0x13660000
- PPMU_CPU	0x106c0000

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos3250.dtsi | 66 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/arch/arm/boot/dts/exynos3250.dtsi b/arch/arm/boot/dts/exynos3250.dtsi
index c743f60..70a9120 100644
--- a/arch/arm/boot/dts/exynos3250.dtsi
+++ b/arch/arm/boot/dts/exynos3250.dtsi
@@ -529,6 +529,72 @@
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
+		ppmu_g3d: ppmu_g3d@13220000 {
+			compatible = "samsung,exynos-ppmu";
+			reg = <0x13220000 0x2000>;
+			clocks = <&cmu CLK_PPMUG3D>;
+			clock-names = "ppmu";
+			status = "disabled";
+		};
+
+		ppmu_mfc_l: ppmu_mfc_l@13660000 {
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

