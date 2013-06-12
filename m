Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab3FLKUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 06:20:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30959 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab3FLKUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 06:20:03 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-7a-51b84b508410
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V4 3/3] ARM: dts: Add pcie controller node for Samsung
 EXYNOS5440 SoC
Date: Wed, 12 Jun 2013 19:20:00 +0900
Message-id: <003801ce6756$6578ff80$306afe80$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5nVl/6No59MUxfRaSpVrdRx1c35A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t8zY91A7x2BBssFLJr/b2e1+DvpGLvF
	kqYMiwOzH7JavDqzkc3i8sJLrBbfb5ha9C64ymax6fE1VovLu+awWZydd5zNYsb5fUwWK5q2
	Mlosvric2WL3yiUsFsdmLGG0ePqgiclB0GPNvDWMHr9/TWL06Jtylc3jyaaLjB4LNpV63Lm2
	h81j85J6j/MzFjJ6fN/RC1SwZRWjx8+XOh6fN8kF8ERx2aSk5mSWpRbp2yVwZVzYfZCpoEe0
	Yu6e1awNjA8Euhg5OSQETCQuXprJCGGLSVy4t56ti5GLQ0hgGaPE8R2vmWGKdk5sY4ZITGeU
	mNw0mxXC+cUocWrWYyaQKjYBNYkvXw6zg9giAv4S1662soAUMQtMYpX4NfESUBEHh7BAuMTX
	1fUgNSwCqhIzn0xgAbF5BSwlplzdDGULSvyYfA/MZhbQkli/8zgThC0vsXnNW6iLFCR2nH3N
	CDJSREBPYskbI4gSEYl9L95BfXOGQ2L2HlmIVQIS3yYfYgEplxCQldh0AGqKpMTBFTdYJjCK
	zUKyeBaSxbOQLJ6FZMMCRpZVjKKpBckFxUnpRSZ6xYm5xaV56XrJ+bmbGCGpYsIOxnsHrA8x
	JgOtn8gsJZqcD0w1eSXxhsZmRhamJqbGRuaWZqQJK4nzqrdYBwoJpCeWpGanphakFsUXleak
	Fh9iZOLglGpgXKWWYiIjEuTfGa8XMsllUgKnV3rhwtwrEhme1yRa/83Ze/Bp9CQmr4L4WXLh
	jPLxtaYN0kL5ko+Mph/edOHx47cPFXw4FtUvZ9it1MBovtsrZ53ivH1y21OmGgkUNzqKXmO0
	na7w5WFUU+65jEnRFxZarq8/evLR87r5BQH7nwjdu1/7fLKrEktxRqKhFnNRcSIAlljVRisD	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsVy+t9jQd0A7x2BBi07zS2a/29ntfg76Ri7
	xZKmDIsDsx+yWrw6s5HN4vLCS6wW32+YWvQuuMpmsenxNVaLy7vmsFmcnXeczWLG+X1MFiua
	tjJaLL64nNli98olLBbHZixhtHj6oInJQdBjzbw1jB6/f01i9OibcpXN48mmi4weCzaVety5
	tofNY/OSeo/zMxYyenzf0QtUsGUVo8fPlzoenzfJBfBENTDaZKQmpqQWKaTmJeenZOal2yp5
	B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gD9paRQlphTChQKSCwuVtK3wzQhNMRN1wKm
	MULXNyQIrsfIAA0krGPMuLD7IFNBj2jF3D2rWRsYHwh0MXJySAiYSOyc2MYMYYtJXLi3nq2L
	kYtDSGA6o8TkptmsEM4vRolTsx4zgVSxCahJfPlymB3EFhHwl7h2tZUFpIhZYBKrxK+Jl4CK
	ODiEBcIlvq6uB6lhEVCVmPlkAguIzStgKTHl6mYoW1Dix+R7YDazgJbE+p3HmSBseYnNa95C
	XaQgsePsa0aQkSICehJL3hhBlIhI7HvxjnECo8AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihO
	Ss811CtOzC0uzUvXS87P3cQITkbPpHYwrmywOMQowMGoxMN7wGx7oBBrYllxZe4hRgkOZiUR
	3irtHYFCvCmJlVWpRfnxRaU5qcWHGJOBHp3ILCWanA9MlHkl8YbGJmZGlkZmFkYm5uakCSuJ
	8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwHgm1n+O/SfvyNgvJwSvfrjbxLsz2uj65qqUT2mM
	/BcKDgnO38R6k+vB25mbHdrWiU+xbhRz97+3ZUe27N//jJ8PFU5LmCt2mPvQq+m3fi1I7vH0
	Ob5gk9fh/ALN5Y0rrN//an++7vC2n6veGRw5VRucznJvyqr5MzpfH66tjmZtNvzQ9ERowc+1
	SizFGYmGWsxFxYkAze5zFYoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos5440 has two PCIe controllers which can be used as root complex
for PCIe interface.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Tested on Exynos5440.

Changes since v3:
- Removed 'bus-range' property from DT
- Added 'interrupt-map-mask', 'interrupt-map' properties to DT
- Fixed the start address of MEM space in DT
- Increased the size of I/O space to 64kB in DT
- Added 'clocks', 'clock-names' properties to DT

 arch/arm/boot/dts/exynos5440-ssdk5440.dts |    8 ++++++
 arch/arm/boot/dts/exynos5440.dtsi         |   38 +++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5440-ssdk5440.dts b/arch/arm/boot/dts/exynos5440-ssdk5440.dts
index d55042b..efe7d39 100644
--- a/arch/arm/boot/dts/exynos5440-ssdk5440.dts
+++ b/arch/arm/boot/dts/exynos5440-ssdk5440.dts
@@ -30,4 +30,12 @@
 			clock-frequency = <50000000>;
 		};
 	};
+
+	pcie0@40000000 {
+		reset-gpio = <5>;
+	};
+
+	pcie1@60000000 {
+		reset-gpio = <22>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos5440.dtsi b/arch/arm/boot/dts/exynos5440.dtsi
index f6b1c89..2c15f9d 100644
--- a/arch/arm/boot/dts/exynos5440.dtsi
+++ b/arch/arm/boot/dts/exynos5440.dtsi
@@ -216,4 +216,42 @@
 		clock-names = "rtc";
 		status = "disabled";
 	};
+
+	pcie0@0x290000 {
+		compatible = "samsung,exynos5440-pcie";
+		reg = <0x290000 0x1000
+			0x270000 0x1000
+			0x271000 0x40>;
+		interrupts = <0 20 0>, <0 21 0>, <0 22 0>;
+		clocks = <&clock 28>, <&clock 27>;
+		clock-names = "pcie", "pcie_bus";
+		#address-cells = <3>;
+		#size-cells = <2>;
+		device_type = "pci";
+		ranges = <0x00000800 0 0x40000000 0x40000000 0 0x00200000   /* configuration space */
+			  0x81000000 0 0	  0x40200000 0 0x00010000   /* downstream I/O */
+			  0x82000000 0 0x40210000 0x40210000 0 0x10000000>; /* non-prefetchable memory */
+		#interrupt-cells = <1>;
+		interrupt-map-mask = <0 0 0 0>;
+		interrupt-map = <0x0 0 &gic 53>;
+	};
+
+	pcie1@2a0000 {
+		compatible = "samsung,exynos5440-pcie";
+		reg = <0x2a0000 0x1000
+			0x272000 0x1000
+			0x271040 0x40>;
+		interrupts = <0 23 0>, <0 24 0>, <0 25 0>;
+		clocks = <&clock 29>, <&clock 27>;
+		clock-names = "pcie", "pcie_bus";
+		#address-cells = <3>;
+		#size-cells = <2>;
+		device_type = "pci";
+		ranges = <0x00000800 0 0x60000000 0x60000000 0 0x00200000   /* configuration space */
+			  0x81000000 0 0	  0x60200000 0 0x00010000   /* downstream I/O */
+			  0x82000000 0 0x60210000 0x60210000 0 0x10000000>; /* non-prefetchable memory */
+		#interrupt-cells = <1>;
+		interrupt-map-mask = <0 0 0 0>;
+		interrupt-map = <0x0 0 &gic 56>;
+	};
 };
-- 
1.7.10.4


