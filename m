Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbaCNFGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:06:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:23042 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbaCNFGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:06:52 -0400
X-AuditID: cbfee68e-b7f566d000002344-45-53228e6ac639
Date: Fri, 14 Mar 2014 14:06:49 +0900
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
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH v11 12/27] ARM: dts: Add description of System MMU of Exynos
 SoCs
Message-id: <20140314140649.dc5958f420770af48e2376d9@samsung.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.10.14; i686-pc-mingw32)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zI92sPqVgg3nPJS3u3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCM4rJJSc3JLEst0rdL4Mp4tIC9YMt5xoodkzrZGhhXLmXsYuTkkBAwkdj+8jAz
	hC0mceHeerYuRi4OIYFljBJ7Pu1mhyk6cPQhK0RiOqPEtcswzmQmiXmXWtlAqlgEVCVan6xi
	BbHZBLQkVs89zghSJCLQxiTxtfEQC4jDLDCXWeLjtzlgHcICwRKX1/1nAbF5BRwlur+chTrK
	QuJCUwc7RFxQ4sfke2A1zEBTN29rYoWw5SU2r3nLDDJUQqCXQ6L10z92iDMEJL5NBtnGAZSQ
	ldh0AOo5SYmDK26wTGAUmYVk7CwkY2chGbuAkXkVo2hqQXJBcVJ6kZFecWJucWleul5yfu4m
	RkgM9+1gvHnA+hBjMtDKicxSosn5wBSQVxJvaGxmZGFqYmpsZG5pRpqwkjjvoodJQUIC6Ykl
	qdmpqQWpRfFFpTmpxYcYmTg4pRoYV8TMf32G58BGvrLdR4I7HH3D+Fz2f0+aOWH2+sd63Jvn
	GYewCRmuELUNTTl89XbQbe69DwPrxMIvCH5S2BB/dlniI/5tF6ri2G9nRPelq2+Rep579MKe
	11sMPq6++ckryrRklZeNTnPcFqNvfPuFegpZlNf7V/EnWvDG/ZdsYbzk4xO3z0BYiaU4I9FQ
	i7moOBEAAANdxPcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jQd2sPqVggycXBCzu3D3HajH/CJB4
	deQHk8WC/dYWnbM3sFv0LrjKZrHp8TVWi8u75rBZzDi/j8niwoqN7BZTFh1mtTj8pp3V4uSf
	XkaL9TNes1jMvLWGxYHf48nBeUwesxsusnj8O9zP5HHn2h42j81L6j0m31jO6NG3ZRWjx+dN
	ch5Xjp5hCuCMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAH6QEmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8WgBe8GW84wV
	OyZ1sjUwrlzK2MXIySEhYCJx4OhDVghbTOLCvfVsXYxcHEIC0xklrl0GSYA4k5kk5l1qZQOp
	YhFQlWh9sgqsg01AS2L13OOMIEUiAm1MEl8bD7GAOMwCc5klPn6bA9YhLBAscXndfxYQm1fA
	UaL7y1mo3RYSF5o62CHighI/Jt8Dq2EGmrp5WxMrhC0vsXnNW+YJjHyzkJTNQlI2C0nZAkbm
	VYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBCeKZ9A7GVQ0WhxgFOBiVeHhnHFUMFmJNLCuu
	zD3EKMHBrCTCWxWhFCzEm5JYWZValB9fVJqTWnyIMRno74nMUqLJ+cDklVcSb2hsYmZkaWRm
	YWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjA55O2JPbZ3pab3N9Zfq1ksO336W
	sPxh3LgjJeXEeUmbBXu5vX7v85ELj+XTuM6yXHDdvLgtz3+/+Txz+12Da70vWJ7f5bsb6L2K
	Od6QfZr6IYF92ftDExlDbxtLLLKcHOIhezB2ysb/9pKLbxow/jjqWnffWm7vtXnWxdumt34V
	uBxmaib8TF6JpTgj0VCLuag4EQCNpbK4VAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds dts entries for the System MMU devices found on
Exynos4 and Exynos5 SoC series and the System MMU binding
documentation.

CC: Rob Herring <robherring2@gmail.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |   86 +++++++
 arch/arm/boot/dts/exynos4.dtsi                     |  107 ++++++++
 arch/arm/boot/dts/exynos4210.dtsi                  |   23 +-
 arch/arm/boot/dts/exynos4x12.dtsi                  |   77 +++++-
 arch/arm/boot/dts/exynos5250.dtsi                  |  266 +++++++++++++++++++-
 arch/arm/boot/dts/exynos5420.dtsi                  |  205 ++++++++++++++-
 6 files changed, 758 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt

diff --git a/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt b/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
new file mode 100644
index 0000000..e4417bb
--- /dev/null
+++ b/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
@@ -0,0 +1,86 @@
+Samsung Exynos IOMMU H/W, System MMU (System Memory Management Unit)
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
+- compatible: Should be one of:
+		"samsung,sysmmu-v1"
+		"samsung,sysmmu-v2"
+		"samsung,sysmmu-v3.1"
+		"samsung,sysmmu-v3.2"
+		"samsung,sysmmu-v3.3"
+
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
+- mmu-masters: A phandle to device nodes representing the master for which
+               the System MMU can provide a translation. Any additional values
+	       after the phandle will be ignored because a System MMU never
+	       have two or more masters. "#stream-id-cells" specified in the
+	       master's node will be also ignored.
+	       If more than one phandle is specified, only the first phandle
+	       will be treated.
+
+Examples:
+	gsc_0: gsc@13e00000 {
+		compatible = "samsung,exynos5-gsc";
+		reg = <0x13e00000 0x1000>;
+		interrupts = <0 85 0>;
+		samsung,power-domain = <&pd_gsc>;
+		clocks = <&clock 256>;
+		clock-names = "gscl";
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
+		mmu-masters = <&gsc_0>;
+	};
diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index 08452e1..2d5350d 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -516,4 +516,111 @@
 		samsung,power-domain = <&pd_lcd0>;
 		status = "disabled";
 	};
+
+	sysmmu_mfc_l: sysmmu@13620000 {
+		compatible = "samsung,sysmmu-v2";
+		reg = <0x13620000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 5>;
+		clock-names = "sysmmu";
+		clocks = <&clock 274>;
+		samsung,power-domain = <&pd_mfc>;
+		mmu-masters = <&mfc>;
+	};
+
+	sysmmu_mfc_r: sysmmu@13630000 {
+		compatible = "samsung,sysmmu-v2";
+		reg = <0x13630000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock 275>;
+		samsung,power-domain = <&pd_mfc>;
+		mmu-masters = <&mfc>;
+	};
+
+	sysmmu_tv: sysmmu@12E20000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x12E20000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 4>;
+		clock-names = "sysmmu";
+		clocks = <&clock 272>;
+		samsung,power-domain = <&pd_tv>;
+	};
+
+	sysmmu_fimc0: sysmmu@11A20000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x11A20000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 2>;
+		clock-names = "sysmmu";
+		clocks = <&clock 263>;
+		samsung,power-domain = <&pd_cam>;
+		mmu-masters = <&fimc_0>;
+	};
+
+	sysmmu_fimc1: sysmmu@11A30000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x11A30000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 3>;
+		clock-names = "sysmmu";
+		clocks = <&clock 264>;
+		samsung,power-domain = <&pd_cam>;
+		mmu-masters = <&fimc_1>;
+	};
+
+	sysmmu_fimc2: sysmmu@11A40000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x11A40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 4>;
+		clock-names = "sysmmu";
+		clocks = <&clock 265>;
+		samsung,power-domain = <&pd_cam>;
+		mmu-masters = <&fimc_2>;
+	};
+
+	sysmmu_fimc3: sysmmu@11A50000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x11A50000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 5>;
+		clock-names = "sysmmu";
+		clocks = <&clock 266>;
+		samsung,power-domain = <&pd_cam>;
+		mmu-masters = <&fimc_3>;
+	};
+
+	sysmmu_jpeg: sysmmu@11A60000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x11A60000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock 267>;
+		samsung,power-domain = <&pd_cam>;
+	};
+
+	sysmmu_rotator: sysmmu@12A30000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x12A30000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 0>;
+		clock-names = "sysmmu";
+		clocks = <&clock 281>;
+		samsung,power-domain = <&pd_lcd0>;
+	};
+
+	sysmmu_fimd0: sysmmu@11E20000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x11E20000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 2>;
+		clock-names = "sysmmu";
+		clocks = <&clock 287>;
+		samsung,power-domain = <&pd_lcd0>;
+		mmu-masters = <&fimd>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index 48ecd7a..fac6dc6 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -114,7 +114,7 @@
 		status = "disabled";
 	};
 
-	g2d@12800000 {
+	g2d: g2d@12800000 {
 		compatible = "samsung,s5pv210-g2d";
 		reg = <0x12800000 0x1000>;
 		interrupts = <0 89 0>;
@@ -152,4 +152,25 @@
 			samsung,lcd-wb;
 		};
 	};
+
+	sysmmu_g2d: sysmmu@12A20000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x12A20000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 7>;
+		clock-names = "sysmmu";
+		clocks = <&clock 280>;
+		samsung,power-domain = <&pd_lcd0>;
+		mmu-masters = <&g2d>;
+	};
+
+	sysmmu_fimd1: sysmmu@12220000 {
+		compatible = "samsung,sysmmu-v1";
+		interrupt-parent = <&combiner>;
+		reg = <0x12220000 0x1000>;
+		interrupts = <5 3>;
+		clock-names = "sysmmu";
+		clocks = <&clock 291>;
+		samsung,power-domain = <&pd_lcd1>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index 5c412aa..447745b 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -93,7 +93,7 @@
 		interrupts = <0 72 0>;
 	};
 
-	g2d@10800000 {
+	g2d: g2d@10800000 {
 		compatible = "samsung,exynos4212-g2d";
 		reg = <0x10800000 0x1000>;
 		interrupts = <0 89 0>;
@@ -209,4 +209,79 @@
 		clock-names = "biu", "ciu";
 		status = "disabled";
 	};
+
+	sysmmu_g2d: sysmmu@10A40000{
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x10A40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 7>;
+		clock-names = "sysmmu";
+		mmu-masters = <&g2d>;
+	};
+
+	sysmmu_fimc_isp: sysmmu@12260000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x12260000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <16 2>;
+		samsung,power-domain = <&pd_isp>;
+		clock-names = "sysmmu";
+		clocks = <&clock 362>;
+		mmu-masters = <&fimc_is>;
+	};
+
+	sysmmu_fimc_drc: sysmmu@12270000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x12270000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <16 3>;
+		samsung,power-domain = <&pd_isp>;
+		clock-names = "sysmmu";
+		clocks = <&clock 363>;
+		mmu-masters = <&fimc_is>;
+	};
+
+	sysmmu_fimc_fd: sysmmu@122A0000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x122A0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <16 4>;
+		samsung,power-domain = <&pd_isp>;
+		clock-names = "sysmmu";
+		clocks = <&clock 364>;
+		mmu-masters = <&fimc_is>;
+	};
+
+	sysmmu_fimc_mcuctl: sysmmu@122B0000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x122B0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <16 5>;
+		samsung,power-domain = <&pd_isp>;
+		clock-names = "sysmmu";
+		clocks = <&clock 376>;
+		mmu-masters = <&fimc_is>;
+	};
+
+	sysmmu_fimc_lite0: sysmmu@123B0000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x123B0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <16 0>;
+		samsung,power-domain = <&pd_isp>;
+		clock-names = "sysmmu";
+		clocks = <&clock 366>;
+		mmu-masters = <&fimc_lite_0>;
+	};
+
+	sysmmu_fimc_lite1: sysmmu@123C0000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x123C0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <16 1>;
+		samsung,power-domain = <&pd_isp>;
+		clock-names = "sysmmu";
+		clocks = <&clock 365>;
+		mmu-masters = <&fimc_lite_1>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 8f6300f..df336ea 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -80,6 +80,16 @@
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
@@ -679,7 +689,7 @@
 				"sclk_hdmiphy", "mout_hdmi";
 	};
 
-	mixer {
+	mixer: mixer {
 		compatible = "samsung,exynos5250-mixer";
 		reg = <0x14450000 0x10000>;
 		interrupts = <0 94 0>;
@@ -700,7 +710,7 @@
 		phy-names = "dp";
 	};
 
-	fimd@14400000 {
+	fimd: fimd@14400000 {
 		clocks = <&clock 133>, <&clock 339>;
 		clock-names = "sclk_fimd", "fimd";
 	};
@@ -715,4 +725,256 @@
 		io-channel-ranges;
 		status = "disabled";
 	};
+
+	sysmmu_g2d: sysmmu@10A60000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x10A60000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <24 5>;
+		clock-names = "sysmmu";
+		clocks = <&clock 361>;
+	};
+
+	sysmmu_mfc_r: sysmmu@11200000 {
+		compatible = "samsung,sysmmu-v2";
+		reg = <0x11200000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <6 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 268>, <&clock 266>;
+		samsung,power-domain = <&pd_mfc>;
+	};
+
+	sysmmu_mfc_l: sysmmu@11210000 {
+		compatible = "samsung,sysmmu-v2";
+		reg = <0x11210000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <8 5>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 267>, <&clock 266>;
+		samsung,power-domain = <&pd_mfc>;
+	};
+
+	sysmmu_rotator: sysmmu@11D40000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x11D40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 0>;
+		clock-names = "sysmmu";
+		clocks = <&clock 272>;
+	};
+
+	sysmmu_fimc_isp: sysmmu@13260000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x13260000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <10 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock 361>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_drc: sysmmu@13270000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x13270000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <11 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock 362>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_scc: sysmmu@13280000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x13280000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 2>;
+		clock-names = "sysmmu";
+		clocks = <&clock 364>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_scp: sysmmu@13290000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x13290000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <3 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock 365>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_fd: sysmmu@132A0000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x132A0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 0>;
+		clock-names = "sysmmu";
+		clocks = <&clock 363>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_mcuctl: sysmmu@132B0000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x132B0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 4>;
+		clock-names = "sysmmu";
+		clocks = <&clock 366>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_odc: sysmmu@132C0000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x132C0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <11 0>;
+		clock-names = "sysmmu";
+		clocks = <&clock 367>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_dis0: sysmmu@132D0000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x132D0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <10 4>;
+		clock-names = "sysmmu";
+		clocks = <&clock 368>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_dis1: sysmmu@132E0000{
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x132E0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <9 4>;
+		clock-names = "sysmmu";
+		clocks = <&clock 369>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_3dnr: sysmmu@132F0000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x132F0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <5 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock 370>;
+		samsung,power-domain = <&pd_isp>;
+	};
+
+	sysmmu_fimc_lite0: sysmmu@13C40000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x13C40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <3 4>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 346>, <&clock 345>;
+		samsung,power-domain = <&pd_gsc>;
+	};
+
+	sysmmu_fimc_lite1: sysmmu@13C50000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x13C50000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <24 1>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 347>, <&clock 345>;
+		samsung,power-domain = <&pd_gsc>;
+	};
+
+	sysmmu_gsc0: sysmmu@13E80000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x13E80000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <2 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 262>, <&clock 256>;
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
+		clocks = <&clock 263>, <&clock 257>;
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
+		clocks = <&clock 264>, <&clock 258>;
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
+		clocks = <&clock 265>, <&clock 259>;
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
+		clocks = <&clock 350>;
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
+		clocks = <&clock 349>;
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
+		clocks = <&clock 273>, <&clock 270>;
+		samsung,power-domain = <&pd_gsc>;
+	};
+
+	sysmmu_mdma0: sysmmu@10A40000{
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x10A40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <7 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 373>, <&clock 372>;
+	};
+
+	sysmmu_mdma1: sysmmu@11D50000{
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x11D50000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <7 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 274>, <&clock 271>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 45e2e65..a736f09 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -470,7 +470,7 @@
 		phy-names = "dp";
 	};
 
-	fimd@14400000 {
+	fimd: fimd@14400000 {
 		samsung,power-domain = <&disp_pd>;
 		clocks = <&clock 147>, <&clock 421>;
 		clock-names = "sclk_fimd", "fimd";
@@ -641,7 +641,7 @@
 		status = "disabled";
 	};
 
-	mixer@14450000 {
+	mixer: mixer@14450000 {
 		compatible = "samsung,exynos5420-mixer";
 		reg = <0x14450000 0x10000>;
 		interrupts = <0 94 0>;
@@ -720,4 +720,205 @@
 		clock-names = "watchdog";
 		samsung,syscon-phandle = <&pmu_system_controller>;
         };
+
+	sysmmu_g2dr: sysmmu@10A60000 {
+		compatible = "samsung,sysmmu-v3.2";
+		reg = <0x10A60000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <24 5>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 482>, <&clock 481>;
+	};
+
+	sysmmu_g2dw: sysmmu@10A70000 {
+		compatible = "samsung,sysmmu-v3.2";
+		reg = <0x10A60000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <22 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 482>, <&clock 481>;
+	};
+
+	sysmmu_scaler0r: sysmmu@12880000 {
+		compatible = "samsung,sysmmu-v3.2";
+		reg = <0x12880000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <22 4>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 384>, <&clock 381>;
+	};
+
+	sysmmu_scaler1r: sysmmu@12890000 {
+		compatible = "samsung,sysmmu-v3.2";
+		reg = <0x12890000 0x1000>;
+		interrupts = <0 186 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 385>, <&clock 382>;
+	};
+
+	sysmmu_scaler2r: sysmmu@128A0000 {
+		compatible = "samsung,sysmmu-v3.2";
+		reg = <0x128A0000 0x1000>;
+		interrupts = <0 188 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 386>, <&clock 383>;
+	};
+
+	sysmmu_scaler0w: sysmmu@128C0000 {
+		compatible = "samsung,sysmmu-v3.2";
+		reg = <0x128C0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <27 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 384>, <&clock 381>;
+	};
+
+	sysmmu_scaler1w: sysmmu@128D0000 {
+		compatible = "samsung,sysmmu-v3.2";
+		reg = <0x128D0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <22 6>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 385>, <&clock 382>;
+	};
+
+	sysmmu_scaler2w: sysmmu@128E0000 {
+		compatible = "samsung,sysmmu-v3.2";
+		reg = <0x128E0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <19 6>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 386>, <&clock 383>;
+	};
+
+	sysmmu_mfc_r: sysmmu@11200000 {
+		compatible = "samsung,sysmmu-v2";
+		reg = <0x11200000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <6 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 402>, <&clock 401>;
+		samsung,power-domain = <&mfc_pd>;
+	};
+
+	sysmmu_mfc_l: sysmmu@11210000 {
+		compatible = "samsung,sysmmu-v2";
+		reg = <0x11210000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <8 5>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 403>, <&clock 401>;
+		samsung,power-domain = <&mfc_pd>;
+	};
+
+	sysmmu_rotator: sysmmu@11D40000 {
+		compatible = "samsung,sysmmu-v3.1";
+		reg = <0x11D40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <4 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 443>, <&clock 441>;
+	};
+
+	sysmmu_fimc_lite0: sysmmu@13C40000 {
+		compatible = "samsung,sysmmu-v3.3";
+		reg = <0x13C40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <3 4>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 492>, <&clock 496>;
+		samsung,power-domain = <&gsc_pd>;
+	};
+
+	sysmmu_fimc_lite1: sysmmu@13C50000 {
+		compatible = "samsung,sysmmu-v3.3";
+		reg = <0x13C50000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <24 1>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 493>, <&clock 497>;
+		samsung,power-domain = <&gsc_pd>;
+	};
+
+	sysmmu_fimc_lite3: sysmmu@13D50000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x13D50000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <2 4>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 494>, <&clock 495>;
+		samsung,power-domain = <&gsc_pd>;
+	};
+
+	sysmmu_gsc0: sysmmu@13E80000 {
+		compatible = "samsung,sysmmu-v3.3";
+		reg = <0x13E80000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupts = <2 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 461>, <&clock 465>;
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
+		clocks = <&clock 462>, <&clock 466>;
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
+		clocks = <&clock 422>, <&clock 421>;
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
+		clocks = <&clock 423>, <&clock 421>;
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
+		clocks = <&clock 502>, <&clock 431>;
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
+		clocks = <&clock 453>, <&clock 451>;
+	};
+
+	sysmmu_jpeg2: sysmmu@11F20000 {
+		compatible = "samsung,sysmmu-v1";
+		reg = <0x11F20000 0x1000>;
+		interrupts = <0 169 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 453>, <&clock 452>;
+	};
 };
-- 
1.7.9.5

