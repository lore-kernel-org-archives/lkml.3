Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964999Ab3GEM3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 08:29:45 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43129 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964964Ab3GEM3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 08:29:39 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-d2-51d6bc31c461
From: Cho KyongHo <pullip.cho@samsung.com>
To: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'Device Tree'" <devicetree-discuss@lists.ozlabs.org>
Cc: "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <supash.ramaswamy@linaro.org>,
        "'Keyyoung Park'" <keyyoung.park@samsung.com>,
        "'Grant Grundler'" <grundler@chromium.org>
Subject: [PATCH v7 7/9] ARM: dts: Add description of System MMU of Exynos SoCs
Date: Fri, 05 Jul 2013 21:29:37 +0900
Message-id: <002f01ce797b$5016c190$f04444b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac55d8kVK9DW1GmVSq+gw8GAnSy1BA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t8zA13DPdcCDY5dk7I4MPshq8WrIz+Y
	LBbst7bonL2B3WLzwXUsFr0LrrJZNN6bwGax6fE1VovLu+awWcw4v4/J4sKKjewWUxYdZrVo
	ud7L5MDr8eTgPCaP2Q0XWTzuXNvD5rF5Sb3H5BvLGT3Oz1jI6NG3ZRWjx+dNcgEcUVw2Kak5
	mWWpRfp2CVwZR9ofsBQ8X8VYsW/KScYGxkMdjF2MnBwSAiYSP5tOMUHYYhIX7q1n62Lk4hAS
	WMYosXrZMrii621zGSES0xklbiz7DVX1l1Gi91YrWDubgJbE6rnHwapEBKYwSex98hqsilng
	BpPEhk9tLCBVwgJ+EhvnfmYDsVkEVCX29H0Bs3kFLCVuzbzODGELSvyYfA+snhlo6vqdx5kg
	bHmJzWveMkPcpCCx4+xroG0cQNv0JC7OloQoEZHY9+Id2BESAlM5JB63nmGH2CUg8W3yIRaQ
	egkBWYlNB6DGSEocXHGDZQKj2Cwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSiV5yYW1ya
	l66XnJ+7iRES7RN2MN47YH2IMRlo/URmKdHkfGCyyCuJNzQ2M7IwNTE1NjK3NCNNWEmcV73F
	OlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY8bBG5tS1jJK6L/g8kgRWl5g4MK1w3WDkPNV
	f5uuj6/vqfQv8ZWdvPmEB+/LTda9okEJP050NunNTfCwuP7o3oTJr8M2PXDNM5Srv/b1TDjb
	7Di76Og9Tsolks8CLTs0/zt78p6QDDkY2mt/+o343BnrzcsX9PxNbJoRJbTCe23RiQs+PUeK
	lViKMxINtZiLihMBbNCRzAwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsVy+t9jQV3DPdcCDa5eErI4MPshq8WrIz+Y
	LBbst7bonL2B3WLzwXUsFr0LrrJZNN6bwGax6fE1VovLu+awWcw4v4/J4sKKjewWUxYdZrVo
	ud7L5MDr8eTgPCaP2Q0XWTzuXNvD5rF5Sb3H5BvLGT3Oz1jI6NG3ZRWjx+dNcgEcUQ2MNhmp
	iSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAJysplCXmlAKF
	AhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM460P2ApeL6KsWLflJOMDYyHOhi7GDk5
	JARMJK63zYWyxSQu3FvP1sXIxSEkMJ1R4say31DOX0aJ3lutTCBVbAJaEqvnHmcESYgITGGS
	2PvkNVgVs8ANJokNn9pYQKqEBfwkNs79zAZiswioSuzp+wJm8wpYStyaeZ0ZwhaU+DH5Hlg9
	M9DU9TuPM0HY8hKb17xlhrhJQWLH2ddA2ziAtulJXJwtCVEiIrHvxTvGCYwCs5BMmoVk0iwk
	k2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIziVPJPawbiyweIQowAHoxIPr0XT
	1UAh1sSy4srcQ4wSHMxKIrz2CdcChXhTEiurUovy44tKc1KLDzEmAz06kVlKNDkfmObySuIN
	jU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoFxeWvJHqt1N68wdn68
	dHmfXlbOr+flt0TzWacsznmz6+THfXtsJwbzdUnbHth0ecLHfsnsZbebYrjjNF3XTduygelJ
	vshbc/6XYo9Lkx7VirBk/XviMGP+xCCxDVeOW0TNsFXv6Imdcucsp3fSuxViZSV7f0pMV3q/
	YeNeB4s656xarU/PewPPKrEUZyQaajEXFScCADabObhpAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cho KyongHo <pullip.cho@samsung.com>
---
 .../bindings/iommu/samsung,exynos4210-sysmmu.txt   |  103 +++++++
 arch/arm/boot/dts/exynos4.dtsi                     |  122 ++++++++
 arch/arm/boot/dts/exynos4210.dtsi                  |   25 ++
 arch/arm/boot/dts/exynos4x12.dtsi                  |   76 +++++
 arch/arm/boot/dts/exynos5250.dtsi                  |  291 ++++++++++++++++++++
 5 files changed, 617 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt

diff --git a/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
b/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
new file mode 100644
index 0000000..92f0a33
--- /dev/null
+++ b/Documentation/devicetree/bindings/iommu/samsung,exynos4210-sysmmu.txt
@@ -0,0 +1,103 @@
+Samsung Exynos4210 IOMMU H/W, System MMU (System Memory Management Unit)
+
+Samsung's Exynos architecture contains System MMU that enables scattered
+physical memory chunks visible as a contiguous region to DMA-capable peripheral
+devices like MFC, FIMC, FIMD, GScaler, FIMC-IS and so forth.
+
+System MMU is a sort of IOMMU and support identical translation table format to
+ARMv7 translation tables with minimum set of page properties including access
+permissions, shareability and security protection. In addition, System MMU has
+another capabilities like L2 TLB or block-fetch buffers to minimize translation
+latency.
+
+A System MMU is dedicated to a single master peripheral device.  Thus, it is
+important to specify the correct System MMU in the device node of its master
+device. Whereas a System MMU is dedicated to a master device, the master device
+may have more than one System MMU.
+
+Required properties:
+- compatible: Should be "samsung,exynos4210-sysmmu"
+- reg: A tuple of base address and size of System MMU registers.
+- interrupt-parent: The phandle of the interrupt controller of System MMU
+- interrupts: A tuple of numbers that indicates the interrupt source.
+- clock-names: Should be "sysmmu" if the System MMU is needed to gate its clock.
+               Please refer to the following documents:
+	       Documentation/devicetree/bindings/clock/clock-bindings.txt
+	       Documentation/devicetree/bindings/clock/exynos4-clock.txt
+	       Documentation/devicetree/bindings/clock/exynos5250-clock.txt
+	       Optional "master" if the clock to the System MMU is gated by
+	       another gate clock other than "sysmmu". The System MMU driver
+	       sets "master" the parent of "sysmmu".
+	       Exynos4 SoCs, there needs no "master" clocks.
+	       Exynos5 SoCs, some System MMUs must have "master" clocks.
+- clocks: Required if the System MMU is needed to gate its clock.
+	  Please refer to the documents listed above.
+- samsung,power-domain: Required if the System MMU is needed to gate its power.
+	  Please refer to the following document:
+	  Documentation/devicetree/bindings/arm/exynos/power_domain.txt
+
+Required properties for the master peripheral devices:
+- iommu: phandles to the System MMUs of the device
+
+Examples:
+A System MMU is dedicated to a single master device.
+	gsc_0:  gsc@0x13e00000 {
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
+		interrupt-names = "sysmmu-gsc0";
+		interrupts = <2 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 262>, <&clock 256>;
+		samsung,power-domain = <&pd_gsc>;
+		status = "ok";
+	};
+
+MFC has 2 System MMUs for each port that MFC is attached. Thus it seems natural
+to define 2 System MMUs for each port of the MFC:
+
+	mfc: codec@13400000 {
+		compatible = "samsung,mfc-v5";
+		reg = <0x13400000 0x10000>;
+		interrupts = <0 94 0>;
+		samsung,power-domain = <&pd_mfc>;
+		clocks = <&clock 170>, <&clock 273>;
+		clock-names = "sclk_mfc", "mfc";
+		status = "ok";
+		iommu = <&sysmmu_mfc_l>, <&sysmmu_mfc_r>;
+	};
+
+	sysmmu_mfc_l: sysmmu@13620000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13620000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-mfc-l";
+		interrupts = <5 5>;
+		clock-names = "sysmmu";
+		clocks = <&clock 274>;
+		samsung,power-domain = <&pd_mfc>;
+		status = "ok";
+	};
+
+	sysmmu_mfc_r: sysmmu@13630000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13630000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-mfc-r";
+		interrupts = <5 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock 275>;
+		samsung,power-domain = <&pd_mfc>;
+		status = "ok";
+	};
+
diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index 359694c..ba74ee8 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -161,6 +161,7 @@
 		interrupts = <0 94 0>;
 		samsung,power-domain = <&pd_mfc>;
 		status = "disabled";
+		iommu = <&sysmmu_mfc_l>, <&sysmmu_mfc_r>;
 	};
 
 	serial@13800000 {
@@ -395,5 +396,126 @@
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
+		interrupt-names = "sysmmu-mfc-l";
+		interrupts = <5 5>;
+		clock-names = "sysmmu";
+		clocks = <&clock 274>;
+		samsung,power-domain = <&pd_mfc>;
+		status = "ok";
+	};
+
+	sysmmu_mfc_r: sysmmu@13630000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13630000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-mfc-r";
+		interrupts = <5 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock 275>;
+		samsung,power-domain = <&pd_mfc>;
+		status = "ok";
+	};
+
+	sysmmu_tv: sysmmu@13E20000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13E20000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-tv";
+		interrupts = <5 4>;
+		clock-names = "sysmmu";
+		clocks = <&clock 272>;
+		samsung,power-domain = <&pd_tv>;
+		status = "ok";
+	};
+
+	sysmmu_fimc0: sysmmu@11A20000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11A20000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimc0";
+		interrupts = <4 2>;
+		clock-names = "sysmmu";
+		clocks = <&clock 263>;
+		samsung,power-domain = <&pd_cam>;
+		status = "ok";
+	};
+
+	sysmmu_fimc1: sysmmu@11A30000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11A30000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimc1";
+		interrupts = <4 3>;
+		clock-names = "sysmmu";
+		clocks = <&clock 264>;
+		samsung,power-domain = <&pd_cam>;
+		status = "ok";
+	};
+
+	sysmmu_fimc2: sysmmu@11A40000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11A40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimc2";
+		interrupts = <4 4>;
+		clock-names = "sysmmu";
+		clocks = <&clock 265>;
+		samsung,power-domain = <&pd_cam>;
+		status = "ok";
+	};
+
+	sysmmu_fimc3: sysmmu@11A50000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11A50000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimc3";
+		interrupts = <4 5>;
+		clock-names = "sysmmu";
+		clocks = <&clock 266>;
+		samsung,power-domain = <&pd_cam>;
+		status = "ok";
+	};
+
+	sysmmu_jpeg: sysmmu@11A60000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11A60000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-jpeg";
+		interrupts = <4 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock 267>;
+		samsung,power-domain = <&pd_cam>;
+		status = "ok";
+	};
+
+	sysmmu_rotator: sysmmu@12A30000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x12A30000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-rotator";
+		interrupts = <5 0>;
+		clock-names = "sysmmu";
+		clocks = <&clock 281>;
+		samsung,power-domain = <&pd_lcd0>;
+		status = "ok";
+	};
+
+	sysmmu_fimd0: sysmmu@11E20000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11E20000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimd0";
+		interrupts = <5 2>;
+		clock-names = "sysmmu";
+		clocks = <&clock 287>;
+		samsung,power-domain = <&pd_lcd0>;
+		status = "ok";
 	};
 };
diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index 54710de..09b13da 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -119,5 +119,30 @@
 		reg = <0x12800000 0x1000>;
 		interrupts = <0 89 0>;
 		status = "disabled";
+		iommu = <&sysmmu_g2d>;
+	};
+
+	sysmmu_g2d: sysmmu@12A20000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x12A20000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-g2d";
+		interrupts = <4 7>;
+		clock-names = "sysmmu";
+		clocks = <&clock 280>;
+		samsung,power-domain = <&pd_lcd0>;
+		status = "ok";
+	};
+
+	sysmmu_fimd1: sysmmu@12220000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimd1";
+		reg = <0x12220000 0x1000>;
+		interrupts = <5 3>;
+		clock-names = "sysmmu";
+		clocks = <&clock 291>;
+		samsung,power-domain = <&pd_lcd1>;
+		status = "ok";
 	};
 };
diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index e3380a7..681db32 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -79,4 +79,80 @@
 		interrupts = <0 89 0>;
 		status = "disabled";
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
+		clock-names = "sysmmu";
+		clocks = <&clock 365>;
+		status = "ok";
+	};
 };
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index fc9fb3d..130d23d 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -66,6 +66,16 @@
 		reg = <0x10044040 0x20>;
 	};
 
+	pd_isp: mfc-power-domain@0x10044020 {
+		compatible = "samsung,exynos4210-pd";
+		reg = <0x10044020 0x20>;
+	};
+
+	pd_disp1: mfc-power-domain@0x100440A0 {
+		compatible = "samsung,exynos4210-pd";
+		reg = <0x100440A0 0x20>;
+	};
+
 	clock: clock-controller@0x10010000 {
 		compatible = "samsung,exynos5250-clock";
 		reg = <0x10010000 0x30000>;
@@ -180,6 +190,7 @@
 		reg = <0x11000000 0x10000>;
 		interrupts = <0 96 0>;
 		samsung,power-domain = <&pd_mfc>;
+		iommu = <&sysmmu_mfc_l &sysmmu_mfc_l>;
 	};
 
 	rtc {
@@ -571,6 +582,7 @@
 		samsung,power-domain = <&pd_gsc>;
 		clocks = <&clock 256>;
 		clock-names = "gscl";
+		iommu = <&sysmmu_gsc1>;
 	};
 
 	gsc_1:  gsc@0x13e10000 {
@@ -580,6 +592,7 @@
 		samsung,power-domain = <&pd_gsc>;
 		clocks = <&clock 257>;
 		clock-names = "gscl";
+		iommu = <&sysmmu_gsc1>;
 	};
 
 	gsc_2:  gsc@0x13e20000 {
@@ -589,6 +602,7 @@
 		samsung,power-domain = <&pd_gsc>;
 		clocks = <&clock 258>;
 		clock-names = "gscl";
+		iommu = <&sysmmu_gsc2>;
 	};
 
 	gsc_3:  gsc@0x13e30000 {
@@ -598,6 +612,7 @@
 		samsung,power-domain = <&pd_gsc>;
 		clocks = <&clock 259>;
 		clock-names = "gscl";
+		iommu = <&sysmmu_gsc3>;
 	};
 
 	hdmi {
@@ -614,6 +629,7 @@
 		compatible = "samsung,exynos5-mixer";
 		reg = <0x14450000 0x10000>;
 		interrupts = <0 94 0>;
+		iommu = <&sysmmu_tv>;
 	};
 
 	dp-controller {
@@ -638,5 +654,280 @@
 		interrupts = <18 4>, <18 5>, <18 6>;
 		clocks = <&clock 133>, <&clock 339>;
 		clock-names = "sclk_fimd", "fimd";
+		iommu = <&sysmmu_fimd1>;
+	};
+
+	sysmmu_mfc_l: sysmmu@11210000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11210000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-mfc_l";
+		interrupts = <8 5>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 267>, <&clock 266>;
+		samsung,power-domain = <&pd_mfc>;
+		status = "ok";
+	};
+
+	sysmmu_mfc_r: sysmmu@11200000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11200000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-mfc_r";
+		interrupts = <6 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 268>, <&clock 266>;
+		samsung,power-domain = <&pd_mfc>;
+		status = "ok";
+	};
+
+	sysmmu_tv: sysmmu@14650000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x14650000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-tv";
+		interrupts = <7 4>;
+		clock-names = "sysmmu";
+		clocks = <&clock 349>;
+		samsung,power-domain = <&pd_disp1>;
+		status = "ok";
+	};
+
+	sysmmu_gsc0: sysmmu@13E80000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13E80000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-gsc0";
+		interrupts = <2 0>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 262>, <&clock 256>;
+		samsung,power-domain = <&pd_gsc>;
+		status = "ok";
+	};
+
+	sysmmu_gsc1: sysmmu@13E90000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13E90000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-gsc1";
+		interrupts = <2 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 263>, <&clock 257>;
+		samsung,power-domain = <&pd_gsc>;
+		status = "ok";
+	};
+
+	sysmmu_gsc2: sysmmu@13EA0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13EA0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-gsc2";
+		interrupts = <2 4>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 264>, <&clock 258>;
+		samsung,power-domain = <&pd_gsc>;
+		status = "ok";
+	};
+
+	sysmmu_gsc3: sysmmu@13EB0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13EB0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-gsc3";
+		interrupts = <2 6>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 265>, <&clock 259>;
+		samsung,power-domain = <&pd_gsc>;
+		status = "ok";
+	};
+
+	sysmmu_fimd1: sysmmu@14640000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x14640000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimd1";
+		interrupts = <3 2>;
+		clock-names = "sysmmu";
+		clocks = <&clock 350>;
+		samsung,power-domain = <&pd_disp1>;
+		status = "ok";
+	};
+
+	sysmmu_rotator: sysmmu@11D40000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11D40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-rotator";
+		interrupts = <4 0>;
+		clock-names = "sysmmu";
+		clocks = <&clock 272>;
+		status = "ok";
+	};
+
+	sysmmu_fimc_isp: sysmmu@13260000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13260000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimc_isp";
+		interrupts = <10 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock 361>;
+		samsung,power-domain = <&pd_isp>;
+		status = "ok";
+	};
+
+	sysmmu_fimc_drc: sysmmu@13270000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13270000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimc_drc";
+		interrupts = <11 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock 362>;
+		samsung,power-domain = <&pd_isp>;
+		status = "ok";
+	};
+
+	sysmmu_fimc_fd: sysmmu@132A0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x132A0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimc_fd";
+		interrupts = <5 0>;
+		clock-names = "sysmmu";
+		clocks = <&clock 363>;
+		samsung,power-domain = <&pd_isp>;
+		status = "ok";
+	};
+
+	sysmmu_fimc_scc: sysmmu@13280000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13280000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimc_scalerc";
+		interrupts = <5 2>;
+		clock-names = "sysmmu";
+		clocks = <&clock 364>;
+		samsung,power-domain = <&pd_isp>;
+		status = "ok";
+	};
+
+	sysmmu_fimc_scp: sysmmu@13290000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13290000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimc_scalerp";
+		interrupts = <3 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock 365>;
+		samsung,power-domain = <&pd_isp>;
+		status = "ok";
+	};
+
+	sysmmu_fimc_mcuctl: sysmmu@132B0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x132B0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimc_mcuctl";
+		interrupts = <5 4>;
+		clock-names = "sysmmu";
+		clocks = <&clock 366>;
+		samsung,power-domain = <&pd_isp>;
+		status = "ok";
+	};
+
+	sysmmu_fimc_odc: sysmmu@132C0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x132C0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimc_odc";
+		interrupts = <11 0>;
+		clock-names = "sysmmu";
+		clocks = <&clock 367>;
+		samsung,power-domain = <&pd_isp>;
+		status = "ok";
+	};
+
+	sysmmu_fimc_dis0: sysmmu@132D0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x132D0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimc_dis0";
+		interrupts = <10 4>;
+		clock-names = "sysmmu";
+		clocks = <&clock 368>;
+		samsung,power-domain = <&pd_isp>;
+		status = "ok";
+	};
+
+	sysmmu_fimc_dis1: sysmmu@132E0000{
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x132E0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimc_dis1";
+		interrupts = <9 4>;
+		clock-names = "sysmmu";
+		clocks = <&clock 369>;
+		samsung,power-domain = <&pd_isp>;
+		status = "ok";
+	};
+
+	sysmmu_fimc_3dnr: sysmmu@132F0000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x132F0000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimc_3dnr";
+		interrupts = <5 6>;
+		clock-names = "sysmmu";
+		clocks = <&clock 370>;
+		samsung,power-domain = <&pd_isp>;
+		status = "ok";
+	};
+
+	sysmmu_fimc_lite0: sysmmu@13C40000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13C40000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimc_lite0";
+		interrupts = <3 4>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 346>, <&clock 345>;
+		samsung,power-domain = <&pd_gsc>;
+		status = "ok";
+	};
+
+	sysmmu_fimc_lite1: sysmmu@13C50000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x13C50000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-fimc_lite1";
+		interrupts = <24 1>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 347>, <&clock 345>;
+		samsung,power-domain = <&pd_gsc>;
+		status = "ok";
+	};
+
+	sysmmu_fimc_jpeg: sysmmu@11F20000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x11F20000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-jpeg";
+		interrupts = <4 2>;
+		clock-names = "sysmmu", "master";
+		clocks = <&clock 273>, <&clock 270>;
+		samsung,power-domain = <&pd_gsc>;
+		status = "ok";
+	};
+
+	sysmmu_fimc_2d: sysmmu@10A60000 {
+		compatible = "samsung,exynos4210-sysmmu";
+		reg = <0x10A60000 0x1000>;
+		interrupt-parent = <&combiner>;
+		interrupt-names = "sysmmu-2d";
+		interrupts = <24 5>;
+		clock-names = "sysmmu";
+		clocks = <&clock 361>;
+		status = "ok";
 	};
 };
-- 
1.7.2.5


