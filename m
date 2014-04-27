Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaD0Hr4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:47:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41765 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbaD0HkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:40:16 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-3b-535cb45e3414
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, pullip.cho@samsung.com,
        a.motakis@virtualopensystems.com, grundler@chromium.org,
        joro@8bytes.org, prathyush.k@samsung.com, rahul.sharma@samsung.com,
        sachin.kamat@linaro.org, supash.ramaswamy@linaro.org,
        Varun.Sethi@freescale.com, s.nawrocki@samsung.com, t.figa@samsung.com,
        joshi@samsung.com, Shaik Ameer Basha <shaik.ameer@samsung.com>
Subject: [PATCH v12 31/31] ARM: dts: add System MMU nodes of exynos5420
Date: Sun, 27 Apr 2014 13:08:03 +0530
Message-id: <1398584283-22846-32-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsWyRsSkWjduS0ywwZ2FFhZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltDjycDe7Rcv1XiaL9TNes1is2vWH0WLmrTUsDiIeTw7OY/KY3XCRxePf
	4X4mj52z7rJ73Lm2h81j85J6j8k3ljN69G1ZxejxeZOcx5WjZ5gCuKK4bFJSczLLUov07RK4
	Ms5dvshYsMC6YvWqd4wNjH/1uxg5OSQETCSObjvJCmGLSVy4t56ti5GLQ0hgKaPEpre/mWCK
	ls79ww6RWMQocbtxFZQzgUliwvmtYO1sAoYS2+9dYQVJiAisZpTou3gGrIpZoIdZ4tr+O2Cz
	hAXcJfofTmMDsVkEVCXmnN4BZvMKeEis/9sF1MABtE9BYs4kG5AwJ1D4yZ09LCC2EFDr21Nf
	wBZICCzkkDjwbAU7xBwBiW+TD7FA9MpKbDrADHG2pMTBFTdYJjAKL2BkWMUomlqQXFCclF5k
	qlecmFtcmpeul5yfu4kRGJun/z2buIPx/gHrQ4zJQOMmMkuJJucDYzuvJN7Q2MzIwtTE1NjI
	3NKMNGElcd70R0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhTnVx69qqkWoT8WLvM8NPx
	y3eZN1uFv/h+PVPnU/vyE+XMTc6zP9dOOPj573Ohuzm129NjF3KeLJibuejyxg9PY2YHrn9X
	tNNj+QTnCIsf05Y7mnGfXSA65fyqFTxr0tMC/R35vlm8ro66n/RcbJHyhPaAKZbrAxIdcjzC
	83ae2mF6Zso3x9uCSizFGYmGWsxFxYkAm9x2suMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsVy+t9jAd24LTHBBt3PdCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFt83/WF3aJ3wVU2i02Pr7FaXN41h81ixvl9TBYXVmxkt/jXe5DRYsqi
	w6wWh9+0s1qc/NPLaHHk4W52i5brvUwW62e8ZrFYtesPo8XMW2tYHEQ8nhycx+Qxu+Eii8e/
	w/1MHjtn3WX3uHNtD5vH5iX1HpNvLGf06NuyitHj8yY5jytHzzAFcEU1MNpkpCampBYppOYl
	56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAP2npFCWmFMKFApILC5W0rfD
	NCE0xE3XAqYxQtc3JAiux8gADSSsYcw4d/kiY8EC64rVq94xNjD+1e9i5OSQEDCRWDr3DzuE
	LSZx4d56ti5GLg4hgUWMErcbV7FDOBOYJCac38oKUsUmYCix/d4VVpCEiMBqRom+i2fAqpgF
	epglru2/wwRSJSzgLtH/cBobiM0ioCox5/QOMJtXwENi/d8uoAYOoH0KEnMm2YCEOYHCT+7s
	YQGxhYBa3576wjqBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjODIfya9g3FVg8Uh
	RgEORiUe3h/SMcFCrIllxZW5hxglOJiVRHg5pwOFeFMSK6tSi/Lji0pzUosPMSYDHTWRWUo0
	OR+YlPJK4g2NTcxNjU0tTSxMzCxJE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgdF7t/PW
	6A8347bxvfC/Jp3iYrLw6sZzrXNS570751VmvUuvsD1jy49V/wTurNg+vcr9nVzisSmnRdR/
	Vdb+OBt9as7rEJvfaoc/rXq0Pp7zVF8k8908QbeTV8QtlIy99l8tW7E7qujYLp/L5tLiTwQD
	UvvMdv67/13Y/tMbnVmPZ71UDDqgeKpUiaU4I9FQi7moOBEAJuB7JkADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

This patch adds System MMU nodes of exynos5420 except
System MMUs in Image Subsystem.

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 arch/arm/boot/dts/exynos5420.dtsi |  209 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 206 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index c3a9a66..1fc0c9f 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -125,7 +125,7 @@
 		clock-names = "pll_ref", "pll_in", "sclk_audio", "sclk_pcm_in";
 	};
 
-	codec@11000000 {
+	mfc: codec@11000000 {
 		compatible = "samsung,mfc-v7";
 		reg = <0x11000000 0x10000>;
 		interrupts = <0 96 0>;
@@ -472,7 +472,7 @@
 		phy-names = "dp";
 	};
 
-	fimd@14400000 {
+	fimd: fimd@14400000 {
 		samsung,power-domain = <&disp_pd>;
 		clocks = <&clock CLK_SCLK_FIMD1>, <&clock CLK_FIMD1>;
 		clock-names = "sclk_fimd", "fimd";
@@ -644,7 +644,7 @@
 		status = "disabled";
 	};
 
-	mixer@14450000 {
+	mixer: mixer@14450000 {
 		compatible = "samsung,exynos5420-mixer";
 		reg = <0x14450000 0x10000>;
 		interrupts = <0 94 0>;
@@ -732,4 +732,207 @@
 		clock-names = "secss";
 		samsung,power-domain = <&g2d_pd>;
 	};
+
+	sysmmu_g2dr: sysmmu@10A60000 {
+		compatible = "samsung,sysmmu-v3.2";
+		reg = <0x10A60000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <24 5>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_G2D>, <&clock CLK_G2D>;
+	};
+
+	sysmmu_g2dw: sysmmu@10A70000 {
+		compatible = "samsung,sysmmu-v3.2";
+		reg = <0x10A70000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <22 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_G2D>, <&clock CLK_G2D>;
+	};
+
+	sysmmu_scaler0r: sysmmu@12880000 {
+		compatible = "samsung,sysmmu-v3.2";
+		reg = <0x12880000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <22 4>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_MSCL0>, <&clock CLK_MSCL0>;
+	};
+
+	sysmmu_scaler1r: sysmmu@12890000 {
+		compatible = "samsung,sysmmu-v3.2";
+		reg = <0x12890000 0x1000>;
+		interrupts = <0 186 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_MSCL1>, <&clock CLK_MSCL1>;
+	};
+
+	sysmmu_scaler2r: sysmmu@128A0000 {
+		compatible = "samsung,sysmmu-v3.2";
+		reg = <0x128A0000 0x1000>;
+		interrupts = <0 188 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_MSCL2>, <&clock CLK_MSCL2>;
+	};
+
+	sysmmu_scaler0w: sysmmu@128C0000 {
+		compatible = "samsung,sysmmu-v3.2";
+		reg = <0x128C0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <27 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_MSCL0>, <&clock CLK_MSCL0>;
+	};
+
+	sysmmu_scaler1w: sysmmu@128D0000 {
+		compatible = "samsung,sysmmu-v3.2";
+		reg = <0x128D0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <22 6>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_MSCL1>, <&clock CLK_MSCL1>;
+	};
+
+	sysmmu_scaler2w: sysmmu@128E0000 {
+		compatible = "samsung,sysmmu-v3.2";
+		reg = <0x128E0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <19 6>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_MSCL2>, <&clock CLK_MSCL2>;
+	};
+
+	sysmmu_mfc_l: sysmmu@11200000 {
+		compatible = "samsung,sysmmu-v2";
+		reg = <0x11200000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <8 5>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_MFCL>, <&clock CLK_MFC>;
+		mmu-masters = <&mfc>;
+		samsung,power-domain = <&mfc_pd>;
+	};
+
+	sysmmu_mfc_r: sysmmu@11210000 {
+		compatible = "samsung,sysmmu-v2";
+		reg = <0x11210000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <6 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_MFCR>, <&clock CLK_MFC>;
+		mmu-masters = <&mfc>;
+		samsung,power-domain = <&mfc_pd>;
+	};
+
+	sysmmu_rotator: sysmmu@11D40000 {
+		compatible = "samsung,sysmmu-v3.1";
+		reg = <0x11D40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_ROTATOR>, <&clock CLK_ROTATOR>;
+	};
+
+	sysmmu_fimc_lite0: sysmmu@13C40000 {
+		compatible = "samsung,sysmmu-v3.3";
+		reg = <0x13C40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <3 4>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_FIMCL0>, <&clock CLK_FIMC_LITE0>;
+		samsung,power-domain = <&gsc_pd>;
+	};
+
+	sysmmu_fimc_lite1: sysmmu@13C50000 {
+		compatible = "samsung,sysmmu-v3.3";
+		reg = <0x13C50000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <24 1>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_FIMCL1>, <&clock CLK_FIMC_LITE1>;
+		samsung,power-domain = <&gsc_pd>;
+	};
+
+	sysmmu_fimc_lite3: sysmmu@13D50000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x13D50000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <2 4>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_FIMCL3>, <&clock CLK_FIMC_LITE3>;
+		samsung,power-domain = <&gsc_pd>;
+	};
+
+	sysmmu_gsc0: sysmmu@13E80000 {
+		compatible = "samsung,sysmmu-v3.3";
+		reg = <0x13E80000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <2 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_GSCL0>, <&clock CLK_GSCL0>;
+		samsung,power-domain = <&gsc_pd>;
+		mmu-masters = <&gsc_0>;
+	};
+
+	sysmmu_gsc1: sysmmu@13E90000 {
+		compatible = "samsung,sysmmu-v3.3";
+		reg = <0x13E90000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <2 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_GSCL1>, <&clock CLK_GSCL1>;
+		samsung,power-domain = <&gsc_pd>;
+		mmu-masters = <&gsc_1>;
+	};
+
+	sysmmu_fimd0w04: sysmmu@14640000 {
+		compatible = "samsung,sysmmu-v3.3";
+		reg = <0x14640000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <3 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_FIMD1M0>, <&clock CLK_FIMD1>;
+		samsung,power-domain = <&disp_pd>;
+		mmu-masters = <&fimd>;
+	};
+
+	sysmmu_fimd0w123: sysmmu@14680000 {
+		compatible = "samsung,sysmmu-v3.3";
+		reg = <0x14680000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <3 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_FIMD1M1>, <&clock CLK_FIMD1>;
+		samsung,power-domain = <&disp_pd>;
+		mmu-masters = <&fimd>;
+	};
+
+	sysmmu_tv: sysmmu@14650000 {
+		compatible = "samsung,sysmmu-v3.3";
+		reg = <0x14650000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <7 4>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_MIXER>, <&clock CLK_MIXER>;
+		samsung,power-domain = <&disp_pd>;
+		mmu-masters = <&mixer>;
+	};
+
+	sysmmu_jpeg: sysmmu@11F10000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x11F10000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_JPEG>, <&clock CLK_JPEG>;
+	};
+
+	sysmmu_jpeg2: sysmmu@11F20000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x11F20000 0x1000>;
+		interrupts = <0 169 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_JPEG>, <&clock CLK_JPEG2>;
+	};
 };
-- 
1.7.9.5

