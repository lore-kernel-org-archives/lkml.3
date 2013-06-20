Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3FTHMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:12:30 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63521 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab3FTHM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:12:26 -0400
X-AuditID: cbfee68f-b7f436d000000f81-fd-51c2ab593c8a
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
Subject: [PATCH V6 3/3] ARM: dts: Add pcie controller node for Samsung
 EXYNOS5440 SoC
Date: Thu, 20 Jun 2013 16:12:24 +0900
Message-id: <00c201ce6d85$83b072a0$8b1157e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5thX0YCGcdfkQDT66/bR6PRaTttA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t8zY93I1YcCDb5e4LRo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmB0GPNfPWMHr8/jWJ0aNvylU2jyebLjJ6LNhU6nHn
	2h42j81L6j3Oz1jI6PF9Ry9QwZZVjB4/X+p4fN4kF8ATxWWTkpqTWZZapG+XwJVxs/0Ne8FP
	kYpPT46zNDAeEuhi5OSQEDCReLfzKzOELSZx4d56NhBbSGAZo8SMbTYwNfeubmXtYuQCii9i
	lJj09xETRNEvRom9C8xAbDYBNYkvXw6zg9giAv4S1662soA0MAtMYpX4NfESWIOwQLjEmqYm
	sA0sAqoSVz7vYAWxeQUsJbZt+QZlC0r8mHyPBcRmFtCSWL/zOBOELS+xec1bqEsVJHacfc0I
	sUxPYt36f+wQNSIS+168YwRZLCFwhkOi+8MzqGUCEt8mHwIaygGUkJXYdABqjqTEwRU3WCYw
	is1CsnoWktWzkKyehWTFAkaWVYyiqQXJBcVJ6UXGesWJucWleel6yfm5mxgh6aJ/B+PdA9aH
	GJOB1k9klhJNzgemm7ySeENjMyMLUxNTYyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pz
	UosPMTJxcEo1MBZ3HfS9MufsXcFUlRPpX1y8+2f/m3O+ZpEx64LPxz44F811LlK56Oy8/8Cm
	ZxVbVBl/1vfYzJzHxVKzdpmFnkyJqG7U+at1i+6d2VS09br6j/t29QpFNxbqeDNMjWP0E+I4
	ob2u/0Yr9/Z0r53LjhZ9U5otfDHlQMv99w4Cog5buhTTJr1bYqrEUpyRaKjFXFScCAAQv6Y4
	LQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsVy+t9jAd3I1YcCDU68ZrZo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmB0GPNfPWMHr8/jWJ0aNvylU2jyebLjJ6LNhU6nHn
	2h42j81L6j3Oz1jI6PF9Ry9QwZZVjB4/X+p4fN4kF8AT1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0l5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsI4x42b7G/aCnyIVn54cZ2lgPCTQxcjJISFgInHv6lZWCFtM4sK99Wxd
	jFwcQgKLGCUm/X3EBJIQEvjFKLF3gRmIzSagJvHly2F2EFtEwF/i2tVWFpAGZoFJrBK/Jl4C
	axAWCJdY09TEBmKzCKhKXPm8A2wDr4ClxLYt36BsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nL
	DHGRgsSOs68ZIZbpSaxb/48dokZEYt+Ld4wTGAVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFx
	UnqukV5xYm5xaV66XnJ+7iZGcDp6Jr2DcVWDxSFGAQ5GJR5ejcsHA4VYE8uKK3MPMUpwMCuJ
	8KbOORQoxJuSWFmVWpQfX1Sak1p8iDEZ6NOJzFKiyfnAVJlXEm9obGJmZGlkZmFkYm5OmrCS
	OO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYxO85dY7pt4ftHz+n1KqzYLTuv+bbrvlQJb08v1
	93pjO0Rvp2+LyFgg5TKT1/zfHkOFObcqFVbd3sT+fI3xiY1WC1wvrJv1o57zUvzfVS1d05ys
	Ja8tPNu7RWauXotvrPBmhzROsTl+q8yvFVVk+/061LKpZLf4fH+Pq/tVTk9Tf3LB1GyyxWQN
	JZbijERDLeai4kQAtNhZ1YsDAAA=
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
 arch/arm/boot/dts/exynos5440-ssdk5440.dts |    8 ++++++
 arch/arm/boot/dts/exynos5440.dtsi         |   40 ++++++++++++++++++++++++++++-
 2 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5440-ssdk5440.dts b/arch/arm/boot/dts/exynos5440-ssdk5440.dts
index f32cd77..3d93804 100644
--- a/arch/arm/boot/dts/exynos5440-ssdk5440.dts
+++ b/arch/arm/boot/dts/exynos5440-ssdk5440.dts
@@ -65,4 +65,12 @@
 			clock-frequency = <50000000>;
 		};
 	};
+
+	pcie0@290000 {
+		reset-gpio = <&pin_ctrl 5 0>;
+	};
+
+	pcie1@2a0000 {
+		reset-gpio = <&pin_ctrl 22 0>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos5440.dtsi b/arch/arm/boot/dts/exynos5440.dtsi
index 03d40c0..6295eda 100644
--- a/arch/arm/boot/dts/exynos5440.dtsi
+++ b/arch/arm/boot/dts/exynos5440.dtsi
@@ -126,7 +126,7 @@
 		clock-names = "spi", "spi_busclk0";
 	};
 
-	pinctrl {
+	pin_ctrl: pinctrl {
 		compatible = "samsung,exynos5440-pinctrl";
 		reg = <0xE0000 0x1000>;
 		interrupts = <0 37 0>, <0 38 0>, <0 39 0>, <0 40 0>,
@@ -230,4 +230,42 @@
 		clocks = <&clock 24>;
 		clock-names = "usbhost";
 	};
+
+	pcie0@290000 {
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
+		ranges = <0x00000800 0 0x40000000 0x40000000 0 0x00001000   /* configuration space */
+			  0x81000000 0 0	  0x40001000 0 0x00010000   /* downstream I/O */
+			  0x82000000 0 0x40011000 0x40011000 0 0x1ffef000>; /* non-prefetchable memory */
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
+		ranges = <0x00000800 0 0x60000000 0x60000000 0 0x00001000   /* configuration space */
+			  0x81000000 0 0	  0x60001000 0 0x00010000   /* downstream I/O */
+			  0x82000000 0 0x60011000 0x60011000 0 0x1ffef000>; /* non-prefetchable memory */
+		#interrupt-cells = <1>;
+		interrupt-map-mask = <0 0 0 0>;
+		interrupt-map = <0x0 0 &gic 56>;
+	};
 };
-- 
1.7.10.4


