Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab3FGJYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:24:14 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11627 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab3FGJYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:24:10 -0400
X-AuditID: cbfee68f-b7f436d000000f81-fa-51b1a6b81c9a
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
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V3 3/3] ARM: dts: Add pcie controller node for Samsung
 EXYNOS5440 SoC
Date: Fri, 07 Jun 2013 18:24:07 +0900
Message-id: <000f01ce6360$c29c3370$47d49a50$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5jYLu3azxp7/LgQ5CrQ8n775Wo8A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t8zA90dyzYGGszcwGLR/H87q8WSpgyL
	A7Mfslq8OrORzeLywkusFt9vmFr0LrjKZrHp8TVWi8u75rBZnJ13nM1ixvl9TBYrmrYyWiy+
	uJzZYvfKJSwWx2YsYbR4+qCJyUHAY828NYwefVOusnk82XSR0WPBplKPO9f2sHlsXlLvcX7G
	QkaP7zt6gQq2rGL0+PlSx+PzJrkA7igum5TUnMyy1CJ9uwSujCczWlgLbgpUTH1/k7mBcTZv
	FyMnh4SAicTKtW/ZIWwxiQv31rN1MXJxCAksY5SY3nmGGabozo1JTBCJ6YwSv87tYYRwfjFK
	zDzxEqydTUBN4suXw2C2iIC/xLWrrSwgRcwC71kkbv/YxwqSEBYIl3gzaQvYWBYBVYlTB96x
	gNi8ApYS0/ZvZ4WwBSV+TL4HFmcW0JJYv/M4E4QtL7F5zVuokxQkdpx9zQixTE/i0cd5jBA1
	IhL7XrwDu05CYA+HREPfJ1aIZQIS3yYfAhrKAZSQldh0AGqOpMTBFTdYJjCKzUKyehaS1bOQ
	rJ6FZMUCRpZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGCHpoX8H490D1ocYk4HWT2SWEk3O
	B6aXvJJ4Q2MzIwtTE1NjI3NLM9KElcR51VqsA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw
	BiioTJLae/Ppr8J3U85bv1jQ5vw72f1r0RrmS8Exb4+ZXWy/K5OwfJlkRp1DqlNzeO/xB6yv
	5Y3X7WOXeZK/JepGUJMda/xGBdvn+ex5XBOzf/GGiSv8d17TUH61Sj5vZ29SXFmwsY3hmxiT
	f/xfLjlNnFO/QNVT14kji2XV/i3Pfrd8c/RTYinOSDTUYi4qTgQA3vWlEyUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsVy+t9jQd3tyzYGGvy/YW3R/H87q8WSpgyL
	A7Mfslq8OrORzeLywkusFt9vmFr0LrjKZrHp8TVWi8u75rBZnJ13nM1ixvl9TBYrmrYyWiy+
	uJzZYvfKJSwWx2YsYbR4+qCJyUHAY828NYwefVOusnk82XSR0WPBplKPO9f2sHlsXlLvcX7G
	QkaP7zt6gQq2rGL0+PlSx+PzJrkA7qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11D
	SwtzJYW8xNxUWyUXnwBdt8wcoG+UFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmg
	gYR1jBlPZrSwFtwUqJj6/iZzA+Ns3i5GTg4JAROJOzcmMUHYYhIX7q1n62Lk4hASmM4o8evc
	HkYI5xejxMwTL9lBqtgE1CS+fDkMZosI+Etcu9rKAlLELPCeReL2j32sIAlhgXCJN5O2MIPY
	LAKqEqcOvGMBsXkFLCWm7d/OCmELSvyYfA8sziygJbF+53EmCFteYvOat8wQJylI7Dj7mhFi
	mZ7Eo4/zGCFqRCT2vXjHOIFRYBaSUbOQjJqFZNQsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfm
	pesl5+duYgQnn2dSOxhXNlgcYhTgYFTi4f25akOgEGtiWXFl7iFGCQ5mJRHel7M2BgrxpiRW
	VqUW5ccXleakFh9iTAb6dCKzlGhyPjAx5pXEGxqbmBlZGplZGJmYm5MmrCTOe6DVOlBIID2x
	JDU7NbUgtQhmCxMHp1QDY8ap+bPf17P9stLj5ZtZmrnfWOV4eAND2ISKBzcKf7C6xZ4T/H+8
	O+dZ+mKO9LfKtvKsZmGut1JfPKv9XBO958b91WW7txlmz9fWkX4SX6SfYLE5Nc34ppVJwet1
	E37MEH5/YsdiFvZ/QovmOe5kul91TWB7HbtVVmr/xROPRX5Xp74tnajcoMRSnJFoqMVcVJwI
	AImzO3KCAwAA
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
 arch/arm/boot/dts/exynos5440-ssdk5440.dts |    8 ++++++++
 arch/arm/boot/dts/exynos5440.dtsi         |   32 +++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

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
index f6b1c89..ea37e94 100644
--- a/arch/arm/boot/dts/exynos5440.dtsi
+++ b/arch/arm/boot/dts/exynos5440.dtsi
@@ -216,4 +216,36 @@
 		clock-names = "rtc";
 		status = "disabled";
 	};
+
+	pcie0@40000000 {
+		compatible = "samsung,exynos5440-pcie";
+		reg = <0x40000000 0x4000
+			0x290000 0x1000
+			0x270000 0x1000
+			0x271000 0x40>;
+		interrupts = <0 20 0>, <0 21 0>, <0 22 0>;
+		#address-cells = <3>;
+		#size-cells = <2>;
+		device_type = "pci";
+		bus-range = <0x0 0xf>;
+		ranges = <0x00000800 0 0x40000000 0x40000000 0 0x00200000   /* configuration space */
+			  0x81000000 0 0	  0x40200000 0 0x00004000   /* downstream I/O */
+			  0x82000000 0 0	  0x40204000 0 0x10000000>; /* non-prefetchable memory */
+	};
+
+	pcie1@60000000 {
+		compatible = "samsung,exynos5440-pcie";
+		reg = <0x60000000 0x4000
+			0x2a0000 0x1000
+			0x272000 0x1000
+			0x271040 0x40>;
+		interrupts = <0 23 0>, <0 24 0>, <0 25 0>;
+		#address-cells = <3>;
+		#size-cells = <2>;
+		device_type = "pci";
+		bus-range = <0x0 0xf>;
+		ranges = <0x00000800 0 0x60000000 0x60000000 0 0x00200000   /* configuration space */
+			  0x81000000 0 0	  0x60200000 0 0x00004000   /* downstream I/O */
+			  0x82000000 0 0	  0x60204000 0 0x10000000>; /* non-prefetchable memory */
+	};
 };
-- 
1.7.10.4

