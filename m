Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab3JGB5P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 21:57:15 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13709 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab3JGB5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 21:57:11 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-0b-525214f53bb3
Date: Mon, 07 Oct 2013 10:57:08 +0900
From: Cho KyongHo <pullip.cho@samsung.com>
To: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux DeviceTree <devicetree@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>
Cc: Antonios Motakis <a.motakis@virtualopensystems.com>,
        Grant Grundler <grundler@chromium.org>, Joerg Roedel <joro@8bytes.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Prathyush <prathyush.k@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Subash Patel <supash.ramaswamy@linaro.org>,
        Varun Sethi <Varun.Sethi@freescale.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v10 11/20] ARM: dts: Add description of System MMU of Exynos
 SoCs
Message-id: <20131007105708.ff767cf5b9c8be82a581597a@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t8zY92vIkFBBqsadC3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaLluu9TBbrZ7xmsZh5aw2Lg4DHk4PzmDxmN1xk8fh3uJ/J4861PWwem5fUe0y+sZzRo2/L
	KkaPz5vkPK4cPcMUwBnFZZOSmpNZllqkb5fAlbHs2zbmgrMvGSvW3b7G2MC4fDdjFyMHh4SA
	icTzLcpdjJxAppjEhXvr2boYuTiEBJYxSkw6t4QNImEise3FHyaIxHRGiStLHjCDJIQEJjFJ
	rH6kDWKzCKhK9Nx/C9bAJqAlsXrucUaQBhGBNiaJr42HWEAcZoHTzBKrdq9gBlktLBAsseFI
	IkgDr4CjxMUdz9khtllIXGjqYIeIC0r8mHyPBcRmBhq6eVsTK4QtL7F5zVtmiPqZHBLnfwVD
	HCEg8W0yyC6Qz2QlNh2AKpGUOLjiBssERpFZSKbOQjJ1FpKpCxiZVzGKphYkFxQnpReZ6BUn
	5haX5qXrJefnbmKExPGEHYz3DlgfYkwGWjmRWUo0OR+YBvJK4g2NzYwsTE1MjY3MLc1IE1YS
	51VvsQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwLhMw+L5mjkvtqnpvr9u1Wtfu+bhXkaP
	ChHreE3NmZv50oJurqx5VLD3wx3/X3mXT+c+/sr4NFr/4Dk7u4nR06etj676qptzcLeU3fGP
	XYtWzq7nefV/68aJ7DfnJ7yS/RP68t/rhX7PJjG73jq00so0XCvfWjlOwcIiW+zNp8eZvdu1
	ijZnqSUrsRRnJBpqMRcVJwIAyeBYLPkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t9jQd2vIkFBBl+2qljcuXuO1WL+ESDx
	6sgPJosF+60tOmdvYLfoXXCVzWLT42usFpd3zWGzmHF+H5PFhRUb2S2mLDrManH4TTurxck/
	vYwWLdd7mSzWz3jNYjHz1hoWBwGPJwfnMXnMbrjI4vHvcD+Tx51re9g8Ni+p95h8YzmjR9+W
	VYwenzfJeVw5eoYpgDOqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB+gNJYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPGsm/b
	mAvOvmSsWHf7GmMD4/LdjF2MnBwSAiYS2178YYKwxSQu3FvP1sXIxSEkMJ1R4sqSB8wgCSGB
	SUwSqx9pg9gsAqoSPfffsoHYbAJaEqvnHmcEaRARaGOS+Np4iAXEYRY4zSyxavcKoG4ODmGB
	YIkNRxJBGngFHCUu7njODrHNQuJCUwc7RFxQ4sfkeywgNjPQ0M3bmlghbHmJzWveMk9g5JuF
	pGwWkrJZSMoWMDKvYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAhOFM+kdzCuarA4xCjAwajE
	w7vjfmCQEGtiWXFl7iFGCQ5mJRHeS3VAId6UxMqq1KL8+KLSnNTiQ4zJQG9PZJYSTc4HJrG8
	knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamBs2vqhSfPSnzfa
	2ydM0hSJj5AKMHr84v9z08dKSzLLtMvEn0jtrNr5JDrc4ZqJaVvivP7Ud50CjJKX9ss0vJhS
	/jwj+OCcx2q19+fe0K6YN/eL7gtfJ8XIRoOz+58/5k6ZWCd263jdty0nfzcHpzEfYLG8Yzbh
	oZifyuytAZ8l2Y5fNJj8Vk5biaU4I9FQi7moOBEAfT8b11gDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds dts entries for the System MMU devices found on
Exynos4 and Exynos5 SoC series and the System MMU binding
documentation.

CC: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |   76 +++++
 arch/arm/boot/dts/exynos4.dtsi                     |  105 +++++++
 arch/arm/boot/dts/exynos4210.dtsi                  |   21 ++
 arch/arm/boot/dts/exynos4x12.dtsi                  |   82 ++++++
 arch/arm/boot/dts/exynos5250.dtsi                  |  262 +++++++++++++++++
 arch/arm/boot/dts/exynos5420.dtsi                  |  296 ++++++++++++++++++++
 6 files changed, 842 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt

diff --git a/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt b/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
new file mode 100644
index 0000000..3eaacec
--- /dev/null
+++ b/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
@@ -0,0 +1,76 @@
+Samsung Exynos4210 IOMMU H/W, System MMU (System Memory Management Unit)
+
+Samsung's Exynos architecture contains System MMUs that enables scattered
+physical memory chunks visible as a contiguous region to DMA-capable peripheral
+devices like MFC, FIMC, FIMD, GScaler, FIMC-IS and so forth.
+
+System MMU is an IOMMU and supports identical translation table format to
+ARMv7 translation tables with minimum set of page properties including access
+permissions, shareability and security protection. In addition, System MMU has
+another capabilities like L2 TLB or block-fetch buffers to minimize translation
+latency.
+
+System MMUs are in many to one relation with peripheral devices, i.e. single
+peripheral device might have multiple System MMUs (usually one for each bus
+master), but one System MMU can handle transactions from only one peripheral
+device. The relation between a System MMU and the peripheral device needs to be
+defined in device node of the peripheral device.
+
+MFC in all Exynos SoCs and FIMD, M2M Scalers and G2D in Exynos5420 has 2 System
+MMUs.
+* MFC has one System MMU on its left and right bus.
+* FIMD in Exynos5420 has one System MMU for window 0 and 4, the other system MMU
+  for window 1, 2 and 3.
+* M2M Scalers and G2D in Exynos5420 has one System MMU on the read channel and
+  the other System MMU on the write channel.
+The drivers must consider how to handle those System MMUs. One of the idea is
+to implement child devices or sub-devices which are the client devices of the
+System MMU.
+
+Required properties:
+- compatible: Should be "samsung,exynos4210-sysmmu"
+- reg: A tuple of base address and size of System MMU registers.
+- interrupt-parent: The phandle of the interrupt controller of System MMU
+- interrupts: An interrupt specifier for interrupt signal of System MMU,
+	      according to the format defined by a particular interrupt
+	      controller.
+- clock-names: Should be "sysmmu" if the System MMU is needed to gate its clock.
+               Please refer to the following documents:
+	       Documentation/devicetree/bindings/clock/clock-bindings.txt
+	       Documentation/devicetree/bindings/clock/exynos4-clock.txt
+	       Documentation/devicetree/bindings/clock/exynos5250-clock.txt
+	       Documentation/devicetree/bindings/clock/exynos5420-clock.txt
+	       Optional "master" if the clock to the System MMU is gated by
+	       another gate clock other than "sysmmu". The System MMU driver
+	       sets "master" the parent of "sysmmu".
+	       Exynos4 SoCs, there needs no "master" clockj.
+	       Exynos5 SoCs, some System MMUs must have "master" clocks.
+- clocks: Required if the System MMU is needed to gate its clock.
+	  Please refer to the documents listed above.
+- samsung,power-domain: Required if the System MMU is needed to gate its power.
+	  Please refer to the following document:
+	  Documentation/devicetree/bindings/arm/exynos/power_domain.txt
+
+Required properties for the master peripheral devices:
+- iommu: phandles to the System MMU of the device
+
+Examples:
+	gsc_0: gsc@13e00000 {
+		compatible = "samsung,exynos5-gsc";
+		reg = <0x13e00000 0x1000>;
+		interrupts = <0 85 0>;
+		samsung,power-domain = <&pd_gsc>;
+		clocks = <&clock 256>;
+		clock-names = "gscl";
+		iommu = <&sysmmu_gsc1>;
+	};
+
+	sysmmu_gsc0: sysmmu@13E80000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13E80000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <2 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 262>, <&clock 256>;
+		samsung,power-domain = <&pd_gsc>;
+	};
diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index caadc02..b599599 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -117,6 +117,7 @@
 			clock-names = "fimc", "sclk_fimc";
 			samsung,power-domain = <&pd_cam>;
 			samsung,sysreg = <&sys_reg>;
+			iommu = <&sysmmu_fimc0>;
 			status = "disabled";
 		};
 
@@ -128,6 +129,7 @@
 			clock-names = "fimc", "sclk_fimc";
 			samsung,power-domain = <&pd_cam>;
 			samsung,sysreg = <&sys_reg>;
+			iommu = <&sysmmu_fimc1>;
 			status = "disabled";
 		};
 
@@ -139,6 +141,7 @@
 			clock-names = "fimc", "sclk_fimc";
 			samsung,power-domain = <&pd_cam>;
 			samsung,sysreg = <&sys_reg>;
+			iommu = <&sysmmu_fimc2>;
 			status = "disabled";
 		};
 
@@ -150,6 +153,7 @@
 			clock-names = "fimc", "sclk_fimc";
 			samsung,power-domain = <&pd_cam>;
 			samsung,sysreg = <&sys_reg>;
+			iommu = <&sysmmu_fimc3>;
 			status = "disabled";
 		};
 
@@ -505,5 +509,106 @@
 		clock-names = "sclk_fimd", "fimd";
 		samsung,power-domain = <&pd_lcd0>;
 		status = "disabled";
+		iommu = <&sysmmu_fimd0>;
+	};
+
+	sysmmu_mfc_l: sysmmu@13620000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13620000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 5>;
+		clock-names = "sysmmu";
+		clocks = <&clock 274>;
+		samsung,power-domain = <&pd_mfc>;
+	};
+
+	sysmmu_mfc_r: sysmmu@13630000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13630000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock 275>;
+		samsung,power-domain = <&pd_mfc>;
+	};
+
+	sysmmu_tv: sysmmu@12E20000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x12E20000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 4>;
+		clock-names = "sysmmu";
+		clocks = <&clock 272>;
+		samsung,power-domain = <&pd_tv>;
+	};
+
+	sysmmu_fimc0: sysmmu@11A20000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11A20000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 2>;
+		clock-names = "sysmmu";
+		clocks = <&clock 263>;
+		samsung,power-domain = <&pd_cam>;
+	};
+
+	sysmmu_fimc1: sysmmu@11A30000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11A30000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 3>;
+		clock-names = "sysmmu";
+		clocks = <&clock 264>;
+		samsung,power-domain = <&pd_cam>;
+	};
+
+	sysmmu_fimc2: sysmmu@11A40000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11A40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 4>;
+		clock-names = "sysmmu";
+		clocks = <&clock 265>;
+		samsung,power-domain = <&pd_cam>;
+	};
+
+	sysmmu_fimc3: sysmmu@11A50000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11A50000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 5>;
+		clock-names = "sysmmu";
+		clocks = <&clock 266>;
+		samsung,power-domain = <&pd_cam>;
+	};
+
+	sysmmu_jpeg: sysmmu@11A60000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11A60000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock 267>;
+		samsung,power-domain = <&pd_cam>;
+	};
+
+	sysmmu_rotator: sysmmu@12A30000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x12A30000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 0>;
+		clock-names = "sysmmu";
+		clocks = <&clock 281>;
+		samsung,power-domain = <&pd_lcd0>;
+	};
+
+	sysmmu_fimd0: sysmmu@11E20000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11E20000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 2>;
+		clock-names = "sysmmu";
+		clocks = <&clock 287>;
+		samsung,power-domain = <&pd_lcd0>;
 	};
 };
diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index 057d682..8959109 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -124,6 +124,27 @@
 		clocks = <&clock 177>, <&clock 277>;
 		clock-names = "sclk_fimg2d", "fimg2d";
 		status = "disabled";
+		iommu = <&sysmmu_g2d>;
+	};
+
+	sysmmu_g2d: sysmmu@12A20000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x12A20000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 7>;
+		clock-names = "sysmmu";
+		clocks = <&clock 280>;
+		samsung,power-domain = <&pd_lcd0>;
+	};
+
+	sysmmu_fimd1: sysmmu@12220000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		interrupt-parent = <&combiner>;
+		reg = <0x12220000 0x1000>;
+		interrupts = <5 3>;
+		clock-names = "sysmmu";
+		clocks = <&clock 291>;
+		samsung,power-domain = <&pd_lcd1>;
 	};
 
 	camera {
diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index ad531fe..fcfe118 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -176,4 +176,86 @@
 			};
 		};
 	};
+
+	sysmmu_g2d: sysmmu@10A40000{
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x10A40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-g2d";
+		interrupts = <4 7>;
+		clock-names = "sysmmu";
+		status = "ok";
+	};
+
+	sysmmu_fimc_isp: sysmmu@12260000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x12260000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimc_isp";
+		interrupts = <16 2>;
+		samsung,power-domain = <&pd_isp>;
+		clock-names = "sysmmu";
+		clocks = <&clock 362>;
+		status = "ok";
+	};
+
+	sysmmu_fimc_drc: sysmmu@12270000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x12270000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimc_drc";
+		interrupts = <16 3>;
+		samsung,power-domain = <&pd_isp>;
+		clock-names = "sysmmu";
+		clocks = <&clock 363>;
+		status = "ok";
+	};
+
+	sysmmu_fimc_fd: sysmmu@122A0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x122A0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimc_fd";
+		interrupts = <16 4>;
+		samsung,power-domain = <&pd_isp>;
+		clock-names = "sysmmu";
+		clocks = <&clock 364>;
+		status = "ok";
+	};
+
+	sysmmu_fimc_mcuctl: sysmmu@122B0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x122B0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimc_mcuctl";
+		interrupts = <16 5>;
+		samsung,power-domain = <&pd_isp>;
+		clock-names = "sysmmu";
+		clocks = <&clock 376>;
+		status = "ok";
+	};
+
+	sysmmu_fimc_lite0: sysmmu@123B0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x123B0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimc_lite0";
+		interrupts = <16 0>;
+		samsung,power-domain = <&pd_isp>;
+		clock-names = "sysmmu";
+		clocks = <&clock 366>;
+		status = "ok";
+	};
+
+	sysmmu_fimc_lite1: sysmmu@123C0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x123C0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimc_lite1";
+		interrupts = <16 1>;
+		samsung,power-domain = <&pd_isp>;
+		clock-names = "sysmmu";
+		clocks = <&clock 365>;
+		status = "ok";
+	};
 };
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 7d7cc77..948ac48 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -78,6 +78,16 @@
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
@@ -577,6 +587,7 @@
 		samsung,power-domain = <&pd_gsc>;
 		clocks = <&clock 256>;
 		clock-names = "gscl";
+		iommu = <&sysmmu_gsc1>;
 	};
 
 	gsc_1:  gsc@13e10000 {
@@ -586,6 +597,7 @@
 		samsung,power-domain = <&pd_gsc>;
 		clocks = <&clock 257>;
 		clock-names = "gscl";
+		iommu = <&sysmmu_gsc1>;
 	};
 
 	gsc_2:  gsc@13e20000 {
@@ -595,6 +607,7 @@
 		samsung,power-domain = <&pd_gsc>;
 		clocks = <&clock 258>;
 		clock-names = "gscl";
+		iommu = <&sysmmu_gsc2>;
 	};
 
 	gsc_3:  gsc@13e30000 {
@@ -604,6 +617,7 @@
 		samsung,power-domain = <&pd_gsc>;
 		clocks = <&clock 259>;
 		clock-names = "gscl";
+		iommu = <&sysmmu_gsc3>;
 	};
 
 	hdmi {
@@ -620,6 +634,7 @@
 		compatible = "samsung,exynos5250-mixer";
 		reg = <0x14450000 0x10000>;
 		interrupts = <0 94 0>;
+		iommu = <&sysmmu_tv>;
 	};
 
 	dp_phy: video-phy@10040720 {
@@ -638,6 +653,7 @@
 	fimd@14400000 {
 		clocks = <&clock 133>, <&clock 339>;
 		clock-names = "sclk_fimd", "fimd";
+		iommu = <&sysmmu_fimd1>;
 	};
 
 	adc: adc@12D10000 {
@@ -650,4 +666,250 @@
 		io-channel-ranges;
 		status = "disabled";
 	};
+
+	sysmmu_g2d: sysmmu@10A60000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x10A60000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <24 5>;
+		clock-names = "sysmmu";
+		clocks = <&clock 361>;
+	};
+
+	sysmmu_mfc_r: sysmmu@11200000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11200000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <6 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 268>, <&clock 266>;
+		samsung,power-domain = <&pd_mfc>;
+	};
+
+	sysmmu_mfc_l: sysmmu@11210000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11210000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <8 5>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 267>, <&clock 266>;
+		samsung,power-domain = <&pd_mfc>;
+	};
+
+	sysmmu_rotator: sysmmu@11D40000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11D40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 0>;
+		clock-names = "sysmmu";
+		clocks = <&clock 272>;
+	};
+
+	sysmmu_fimc_isp: sysmmu@13260000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13260000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <10 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock 361>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_drc: sysmmu@13270000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13270000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <11 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock 362>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_scc: sysmmu@13280000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13280000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 2>;
+		clock-names = "sysmmu";
+		clocks = <&clock 364>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_scp: sysmmu@13290000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13290000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <3 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock 365>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_fd: sysmmu@132A0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x132A0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 0>;
+		clock-names = "sysmmu";
+		clocks = <&clock 363>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_mcuctl: sysmmu@132B0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x132B0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 4>;
+		clock-names = "sysmmu";
+		clocks = <&clock 366>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_odc: sysmmu@132C0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x132C0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <11 0>;
+		clock-names = "sysmmu";
+		clocks = <&clock 367>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_dis0: sysmmu@132D0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x132D0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <10 4>;
+		clock-names = "sysmmu";
+		clocks = <&clock 368>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_dis1: sysmmu@132E0000{
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x132E0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <9 4>;
+		clock-names = "sysmmu";
+		clocks = <&clock 369>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_3dnr: sysmmu@132F0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x132F0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock 370>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_lite0: sysmmu@13C40000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13C40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <3 4>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 346>, <&clock 345>;
+		samsung,power-domain = <&pd_gsc>;
+	};
+
+	sysmmu_fimc_lite1: sysmmu@13C50000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13C50000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <24 1>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 347>, <&clock 345>;
+		samsung,power-domain = <&pd_gsc>;
+	};
+
+	sysmmu_gsc0: sysmmu@13E80000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13E80000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <2 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 262>, <&clock 256>;
+		samsung,power-domain = <&pd_gsc>;
+	};
+
+	sysmmu_gsc1: sysmmu@13E90000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13E90000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <2 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 263>, <&clock 257>;
+		samsung,power-domain = <&pd_gsc>;
+	};
+
+	sysmmu_gsc2: sysmmu@13EA0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13EA0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <2 4>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 264>, <&clock 258>;
+		samsung,power-domain = <&pd_gsc>;
+	};
+
+	sysmmu_gsc3: sysmmu@13EB0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13EB0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <2 6>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 265>, <&clock 259>;
+		samsung,power-domain = <&pd_gsc>;
+	};
+
+	sysmmu_fimd1: sysmmu@14640000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x14640000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <3 2>;
+		clock-names = "sysmmu";
+		clocks = <&clock 350>;
+		samsung,power-domain = <&pd_disp1>;
+	};
+
+	sysmmu_tv: sysmmu@14650000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x14650000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <7 4>;
+		clock-names = "sysmmu";
+		clocks = <&clock 349>;
+		samsung,power-domain = <&pd_disp1>;
+	};
+
+	sysmmu_jpeg: sysmmu@11F20000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11F20000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 273>, <&clock 270>;
+		samsung,power-domain = <&pd_gsc>;
+	};
+
+	sysmmu_mdma0: sysmmu@10A40000{
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x10A40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <7 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 373>, <&clock 372>;
+	};
+
+	sysmmu_mdma1: sysmmu@11D50000{
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11D50000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <7 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 274>, <&clock 271>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index d537cd7..360b5ab 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -235,4 +235,300 @@
 		io-channel-ranges;
 		status = "disabled";
 	};
+
+	sysmmu_g2d_rd: sysmmu@10A60000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x10A60000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <24 5>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 482>, <&clock 481>;
+		samsung,power-domain = <&g2d_pd>;
+	};
+
+	sysmmu_g2d_wr: sysmmu@10A70000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x10A70000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <22 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 482>, <&clock 481>;
+		samsung,power-domain = <&g2d_pd>;
+	};
+
+	sysmmu_mfc_r: sysmmu@11200000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11200000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <6 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 403>, <&clock 401>;
+		samsung,power-domain = <&mfc_pd>;
+	};
+
+	sysmmu_mfc_l: sysmmu@11210000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11210000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <8 5>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 402>, <&clock 401>;
+		samsung,power-domain = <&mfc_pd>;
+	};
+
+	sysmmu_rotator: sysmmu@11D40000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11D40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 443>, <&clock 441>;
+	};
+
+	sysmmu_jpeg: sysmmu@11F10000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11F10000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 453>, <&clock 451>;
+	};
+
+	sysmmu_jpeg2: sysmmu@11F20000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11F20000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <0 169 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 453>, <&clock 452>;
+	};
+
+	sysmmu_3aa: sysmmu@13CC0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13CC0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <23 6>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 491>, <&clock 467>;
+		samsung,power-domain = <&gsc_pd>;
+	};
+
+	sysmmu_msc0_rd: sysmmu@12880000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x12880000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <22 4>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 384>, <&clock 381>;
+		samsung,power-domain = <&msc_pd>;
+	};
+
+	sysmmu_msc0_wr: sysmmu@128C0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x128C0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <27 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 384>, <&clock 381>;
+		samsung,power-domain = <&msc_pd>;
+	};
+
+	sysmmu_msc1_rd: sysmmu@12890000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x12890000 0x1000>;
+		interrupts = <0 186 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 385>, <&clock 382>;
+		samsung,power-domain = <&msc_pd>;
+	};
+
+	sysmmu_msc1_wr: sysmmu@128D0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x128D0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <22 6>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 385>, <&clock 382>;
+		samsung,power-domain = <&msc_pd>;
+	};
+
+	sysmmu_msc2_rd: sysmmu@128A0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x128A0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <0 188 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 386>, <&clock 383>;
+		samsung,power-domain = <&msc_pd>;
+	};
+
+	sysmmu_msc2_wr: sysmmu@128E0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x128E0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <19 6>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 386>, <&clock 383>;
+		samsung,power-domain = <&msc_pd>;
+	};
+
+	sysmmu_fimc_isp: sysmmu@13260000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13260000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <10 6>;
+		samsung,power-domain = <&isp_pd>;
+	};
+
+	sysmmu_fimc_drc: sysmmu@13270000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13270000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 6>;
+		samsung,power-domain = <&isp_pd>;
+	};
+
+	sysmmu_fimc_scc: sysmmu@13280000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13280000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 2>;
+		samsung,power-domain = <&isp_pd>;
+	};
+
+	sysmmu_fimc_scp: sysmmu@13290000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13290000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <3 6>;
+		samsung,power-domain = <&isp_pd>;
+	};
+
+	sysmmu_fimc_fd: sysmmu@132A0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x132A0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 0>;
+		samsung,power-domain = <&isp_pd>;
+	};
+
+	sysmmu_fimc_mcuctl: sysmmu@132B0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x132B0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 4>;
+		samsung,power-domain = <&isp_pd>;
+	};
+
+	sysmmu_fimc_odc: sysmmu@132C0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x132C0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <11 0>;
+		samsung,power-domain = <&isp_pd>;
+	};
+
+	sysmmu_fimc_dis0: sysmmu@132D0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x132D0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <10 4>;
+		samsung,power-domain = <&isp_pd>;
+	};
+
+	sysmmu_fimc_dis1: sysmmu@132E0000{
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x132E0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <9 4>;
+		samsung,power-domain = <&isp_pd>;
+	};
+
+	sysmmu_fimc_3dnr: sysmmu@132F0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x132F0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 6>;
+		samsung,power-domain = <&isp_pd>;
+	};
+
+	sysmmu_fimc_lite0: sysmmu@13C40000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13C40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <3 4>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 492>, <&clock 496>;
+		samsung,power-domain = <&gsc_pd>;
+	};
+
+	sysmmu_fimc_lite1: sysmmu@13C50000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13C50000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <24 1>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 493>, <&clock 497>;
+		samsung,power-domain = <&gsc_pd>;
+	};
+
+	sysmmu_fimc_lite3: sysmmu@13D50000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13D50000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <2 4>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 494>, <&clock 495>;
+		samsung,power-domain = <&gsc_pd>;
+	};
+
+	sysmmu_gsc0: sysmmu@13E80000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13E80000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <2 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 461>, <&clock 465>;
+		samsung,power-domain = <&gsc_pd>;
+	};
+
+	sysmmu_gsc1: sysmmu@13E90000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13E90000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <2 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 462>, <&clock 466>;
+		samsung,power-domain = <&gsc_pd>;
+	};
+
+	sysmmu_fimd1_w04: sysmmu@14640000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x14640000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <3 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 422>, <&clock 421>;
+		samsung,power-domain = <&disp_pd>;
+	};
+
+	sysmmu_fimd1_w123: sysmmu@14680000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x14680000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <3 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 422>, <&clock 421>;
+		samsung,power-domain = <&disp_pd>;
+	};
+
+	sysmmu_tv: sysmmu@14650000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x14650000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <7 4>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 502>, <&clock 431>;
+		samsung,power-domain = <&disp_pd>;
+	};
 };
-- 
1.7.2.5

