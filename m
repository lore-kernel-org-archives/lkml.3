Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867AbaD0Hsx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 03:48:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31265 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318AbaD0HkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 03:40:12 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-28-535cb45b40d0
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: kgene.kim@samsung.com, tomasz.figa@gmail.com, pullip.cho@samsung.com,
        a.motakis@virtualopensystems.com, grundler@chromium.org,
        joro@8bytes.org, prathyush.k@samsung.com, rahul.sharma@samsung.com,
        sachin.kamat@linaro.org, supash.ramaswamy@linaro.org,
        Varun.Sethi@freescale.com, s.nawrocki@samsung.com, t.figa@samsung.com,
        joshi@samsung.com
Subject: [PATCH v12 30/31] ARM: dts: add System MMU nodes of exynos5250
Date: Sun, 27 Apr 2014 13:08:02 +0530
Message-id: <1398584283-22846-31-git-send-email-shaik.ameer@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
References: <1398584283-22846-1-git-send-email-shaik.ameer@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWyRsSkVjd6S0ywwZ5f8hZ37p5jtZh/BEi8
	OvKDyWLBfmuLztkb2C2+7/rCbtG74CqbxabH11gtLu+aw2Yx4/w+JosLKzayW/zrPchoMWXR
	YVaLw2/aWS1O/ulltGi53stksX7GaxaLVbv+MFrMvLWGxUHY48nBeUwesxsusnj8O9zP5LFz
	1l12jzvX9rB5bF5S7zH5xnJGj74tqxg9Pm+S87hy9AxTAFcUl01Kak5mWWqRvl0CV0Z303bm
	gr+uFRvabzM1MC616GLk5JAQMJF4u+UVO4QtJnHh3nq2LkYuDiGBpYwSSzZeYoIp+rtpBiNE
	YhGjxPdVn1khnAlMElOvL2MBqWITMJTYfu8KWEJEYDWjRN/FM+wgDrPAXSaJOaveMYJUCQu4
	S3w6cBSsg0VAVeLD701gNq+Ah8TMlceZuxg5gPYpSMyZZAMS5gQKP7mzB6xECKj17akvYAsk
	BKZySLx9u4odYo6AxLfJh1ggemUlNh1ghjhbUuLgihssExiFFzAyrGIUTS1ILihOSi8y1StO
	zC0uzUvXS87P3cQIjMjT/55N3MF4/4D1IcZkoHETmaVEk/OBEZ1XEm9obGZkYWpiamxkbmlG
	mrCSOG/6o6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYw7fizr8c259azt2BTZePldlbnu
	olmbBKuOSdVUfvhi/cSQd4KGkdSP7XOOnGMU/nTdiudt/+ljO1L/B8pUbJQ57/Vi+gdvMU2t
	082Vao2BLOUzXO56rY1+WGnQwB75bPfXKxX3quv25BxpWizHe1dDZdK6nvWXbc5dWDB7xeXO
	9cpXrcQ6dwYrsRRnJBpqMRcVJwIAr9RL4d4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAd3oLTHBBu3PhS3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFt83/WF3aJ3wVU2i02Pr7FaXN41h81ixvl9TBYXVmxkt/jXe5DRYsqi
	w6wWh9+0s1qc/NPLaNFyvZfJYv2M1ywWq3b9YbSYeWsNi4Owx5OD85g8ZjdcZPH4d7ifyWPn
	rLvsHneu7WHz2Lyk3mPyjeWMHn1bVjF6fN4k53Hl6BmmAK6oBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKDXlBTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGENYwZ3U3bmQv+ulZsaL/N1MC41KKLkZNDQsBE4u+mGYwQtpjEhXvr
	2boYuTiEBBYxSnxf9ZkVwpnAJDH1+jIWkCo2AUOJ7feugCVEBFYzSvRdPMMO4jAL3GWSmLPq
	HdgsYQF3iU8HjoJ1sAioSnz4vQnM5hXwkJi58jhzFyMH0D4FiTmTbEDCnEDhJ3f2gJUIAbW+
	PfWFdQIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwfH+TGoH48oGi0OMAhyMSjy8
	CyRjgoVYE8uKK3MPMUpwMCuJ8HJOBwrxpiRWVqUW5ccXleakFh9iTAY6aiKzlGhyPjAV5ZXE
	GxqbmJsam1qaWJiYWZImrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QDo8VWp7NB6VY6BhWv
	Pz7k+hPHp2Ct/8mHv/fqvx17rxzV5Onr4P27akexs9s0l9DUys4Olkdbu6qvTlvo8K7pXqPi
	1d2y+q5nrrYr1rxffvdRupxbQ3a2m5z7S7uj/303rFf9uO/RNgdRxk07irdNdf+7brXMD0Wl
	q5act4Muq2ZetHoWExx3Q4mlOCPRUIu5qDgRAC/OZcE7AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cho KyongHo <pullip.cho@samsung.com>

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi |  270 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 267 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 3742331..eebd397 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -82,6 +82,16 @@
 		reg = <0x10044040 0x20>;
 	};
 
+	pd_isp: isp-power-domain@0x10044020 {
+		compatible = "samsung,exynos4210-pd";
+		reg = <0x10044020 0x20>;
+	};
+
+	pd_disp1: disp1-power-domain@0x100440A0 {
+		compatible = "samsung,exynos4210-pd";
+		reg = <0x100440A0 0x20>;
+	};
+
 	clock: clock-controller@10010000 {
 		compatible = "samsung,exynos5250-clock";
 		reg = <0x10010000 0x30000>;
@@ -192,7 +202,7 @@
 		clock-names = "fimg2d";
 	};
 
-	codec@11000000 {
+	mfc: codec@11000000 {
 		compatible = "samsung,mfc-v6";
 		reg = <0x11000000 0x10000>;
 		interrupts = <0 96 0>;
@@ -692,7 +702,7 @@
 				"sclk_hdmiphy", "mout_hdmi";
 	};
 
-	mixer {
+	mixer: mixer {
 		compatible = "samsung,exynos5250-mixer";
 		reg = <0x14450000 0x10000>;
 		interrupts = <0 94 0>;
@@ -713,7 +723,7 @@
 		phy-names = "dp";
 	};
 
-	fimd@14400000 {
+	fimd: fimd@14400000 {
 		clocks = <&clock CLK_SCLK_FIMD1>, <&clock CLK_FIMD1>;
 		clock-names = "sclk_fimd", "fimd";
 	};
@@ -736,4 +746,258 @@
 		clocks = <&clock 348>;
 		clock-names = "secss";
 	};
+
+	sysmmu_g2d: sysmmu@10A60000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x10A60000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <24 5>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_2D>;
+	};
+
+	sysmmu_mfc_r: sysmmu@11200000 {
+		compatible = "samsung,sysmmu-v2";
+		reg = <0x11200000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <6 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_MFCR>, <&clock CLK_MFC>;
+		mmu-masters = <&mfc>;
+		samsung,power-domain = <&pd_mfc>;
+	};
+
+	sysmmu_mfc_l: sysmmu@11210000 {
+		compatible = "samsung,sysmmu-v2";
+		reg = <0x11210000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <8 5>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_MFCL>, <&clock CLK_MFC>;
+		mmu-masters = <&mfc>;
+		samsung,power-domain = <&pd_mfc>;
+	};
+
+	sysmmu_rotator: sysmmu@11D40000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x11D40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 0>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_ROTATOR>;
+	};
+
+	sysmmu_fimc_isp: sysmmu@13260000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x13260000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <10 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_FIMC_ISP>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_drc: sysmmu@13270000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x13270000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <11 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_FIMC_DRC>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_scc: sysmmu@13280000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x13280000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 2>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_FIMC_SCC>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_scp: sysmmu@13290000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x13290000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <3 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_FIMC_SCP>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_fd: sysmmu@132A0000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x132A0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 0>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_FIMC_FD>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_mcuctl: sysmmu@132B0000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x132B0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 4>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_FIMC_MCU>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_odc: sysmmu@132C0000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x132C0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <11 0>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_FIMC_ODC>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_dis0: sysmmu@132D0000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x132D0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <10 4>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_FIMC_DIS0>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_dis1: sysmmu@132E0000{
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x132E0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <9 4>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_FIMC_DIS1>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_3dnr: sysmmu@132F0000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x132F0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_FIMC_3DNR>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_lite0: sysmmu@13C40000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x13C40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <3 4>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_FIMC_LITE0>, <&clock CLK_CAMIF_TOP>;
+		samsung,power-domain = <&pd_gsc>;
+	};
+
+	sysmmu_fimc_lite1: sysmmu@13C50000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x13C50000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <24 1>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_FIMC_LITE1>, <&clock CLK_CAMIF_TOP>;
+		samsung,power-domain = <&pd_gsc>;
+	};
+
+	sysmmu_gsc0: sysmmu@13E80000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x13E80000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <2 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_GSCL0>, <&clock CLK_GSCL0>;
+		samsung,power-domain = <&pd_gsc>;
+		mmu-masters = <&gsc_0>;
+	};
+
+	sysmmu_gsc1: sysmmu@13E90000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x13E90000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <2 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_GSCL1>, <&clock CLK_GSCL1>;
+		samsung,power-domain = <&pd_gsc>;
+		mmu-masters = <&gsc_1>;
+	};
+
+	sysmmu_gsc2: sysmmu@13EA0000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x13EA0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <2 4>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_GSCL2>, <&clock CLK_GSCL2>;
+		samsung,power-domain = <&pd_gsc>;
+		mmu-masters = <&gsc_2>;
+	};
+
+	sysmmu_gsc3: sysmmu@13EB0000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x13EB0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <2 6>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_GSCL3>, <&clock CLK_GSCL3>;
+		samsung,power-domain = <&pd_gsc>;
+		mmu-masters = <&gsc_3>;
+	};
+
+	sysmmu_fimd1: sysmmu@14640000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x14640000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <3 2>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_FIMD1>;
+		samsung,power-domain = <&pd_disp1>;
+		mmu-masters = <&fimd>;
+	};
+
+	sysmmu_tv: sysmmu@14650000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x14650000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <7 4>;
+		clock-names = "sysmmu";
+		clocks = <&clock CLK_SMMU_TV>;
+		samsung,power-domain = <&pd_disp1>;
+		mmu-masters = <&mixer>;
+	};
+
+	sysmmu_jpeg: sysmmu@11F20000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x11F20000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_JPEG>, <&clock CLK_JPEG>;
+		samsung,power-domain = <&pd_gsc>;
+	};
+
+	sysmmu_mdma0: sysmmu@10A40000{
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x10A40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <7 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_MDMA0>, <&clock CLK_MDMA0>;
+	};
+
+	sysmmu_mdma1: sysmmu@11D50000{
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x11D50000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <7 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock CLK_SMMU_MDMA1>, <&clock CLK_MDMA1>;
+	};
 };
-- 
1.7.9.5

