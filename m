Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965272Ab3FTJeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:34:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33515 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965172Ab3FTJeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:34:05 -0400
X-AuditID: cbfee68f-b7f436d000000f81-02-51c2cc8c7209
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
Subject: [PATCH V7 3/4] ARM: dts: Add pcie controller node for Samsung
 EXYNOS5440 SoC
Date: Thu, 20 Jun 2013 18:34:03 +0900
Message-id: <00cd01ce6d99$4daeac80$e90c0580$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5tmUthOZK+C8zzTDSCOzagLCB4mQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t8zY92eM4cCDf41yVo0/9/OavF30jF2
	iyVNGRYHZj9ktXh1ZiObxeWFl1gtvt8wtehdcJXNYtPja6wWl3fNYbM4O+84m8WM8/uYLFY0
	bWW0WHxxObPF7pVLWCyOzVjCaPH0QROTg6DHmnlrGD1+/5rE6NE35Sqbx5NNFxk9Fmwq9bhz
	bQ+bx+Yl9R7nZyxk9Pi+oxeoYMsqRo+fL3U8Pm+SC+CJ4rJJSc3JLEst0rdL4Mo43qVTsJ+/
	4lzTDdYGxnk8XYycHBICJhIP1x1lhLDFJC7cW8/WxcjFISSwjFFiz8vvTF2MHGBFpz4yQ8Sn
	M0p0r/rMCOH8YpSYsmoKE0g3m4CaxJcvh9lBbBEBf4lrV1tZQIqYBSaxSvyaeAmsSFggXKL/
	0DqwIhYBVYnVt5eA2bwClhJNV99B2YISPybfYwGxmQW0JNbvPM4EYctLbF7zlhniVAWJHWdf
	M0Is05NYu+0IK0SNiMS+F+/ArpMQOMEhseDmOVaIZQIS3yYfYoF4R1Zi0wGoOZISB1fcYJnA
	KDYLyepZSFbPQrJ6FpIVCxhZVjGKphYkFxQnpRcZ6xUn5haX5qXrJefnbmKEpIv+HYx3D1gf
	YkwGWj+RWUo0OR+YbvJK4g2NzYwsTE1MjY3MLc1IE1YS51VrsQ4UEkhPLEnNTk0tSC2KLyrN
	SS0+xMjEwSnVwNjuc0dNwrjtIfdXpsPWp7QWfMs/dmVeWACHhNd7uammMbfm3Ti8QGf3sQYh
	Pb570w+4Ht8XcdGjbPfDezlvtmrWBR1c8TTlTY/Cov8J0ppxUxewxny1eHO/7oXisWhRn/gl
	nd1vN026zPWkZVnv3vdfL8Rf2CXxkuWSwEsVvTbHcyG2i38mTg9SYinOSDTUYi4qTgQAM12k
	IC0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsVy+t9jQd2eM4cCDa51iVs0/9/OavF30jF2
	iyVNGRYHZj9ktXh1ZiObxeWFl1gtvt8wtehdcJXNYtPja6wWl3fNYbM4O+84m8WM8/uYLFY0
	bWW0WHxxObPF7pVLWCyOzVjCaPH0QROTg6DHmnlrGD1+/5rE6NE35Sqbx5NNFxk9Fmwq9bhz
	bQ+bx+Yl9R7nZyxk9Pi+oxeoYMsqRo+fL3U8Pm+SC+CJamC0yUhNTEktUkjNS85PycxLt1Xy
	Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAH6S0mhLDGnFCgUkFhcrKRvh2lCaIibrgVM
	Y4Sub0gQXI+RARpIWMeYcbxLp2A/f8W5phusDYzzeLoYOTgkBEwkTn1k7mLkBDLFJC7cW8/W
	xcjFISQwnVGie9VnRgjnF6PElFVTmECq2ATUJL58OcwOYosI+Etcu9rKAlLELDCJVeLXxEtg
	RcIC4RL9h9aBFbEIqEqsvr0EzOYVsJRouvoOyhaU+DH5HguIzSygJbF+53EmCFteYvOat1An
	KUjsOPuaEWKZnsTabUdYIWpEJPa9eMc4gVFgFpJRs5CMmoVk1CwkLQsYWVYxiqYWJBcUJ6Xn
	GukVJ+YWl+al6yXn525iBCejZ9I7GFc1WBxiFOBgVOLh1bh8MFCINbGsuDL3EKMEB7OSCG/q
	nEOBQrwpiZVVqUX58UWlOanFhxiTgT6dyCwlmpwPTJR5JfGGxiZmRpZGZhZGJubmpAkrifMe
	bLUOFBJITyxJzU5NLUgtgtnCxMEp1cBYY3Or/7c0n2/iFZXrTpx35l2J/auUyXz3P8eHfoeM
	tYUfVx0JYPq9yWrpidUac+z2d3voTay+ZiDFc4J1W+byh/tL+PMjGZa19DnJbti759bPaQzv
	OmU2K/LK/tjIG25Sc4npxWemtwcjprJoPPnqcj1F53SGhvVvl1kfczjaF6SfaF9z29lUiaU4
	I9FQi7moOBEARmHRD4oDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exynos5440 has two PCIe controllers which can be used as root complex
for PCIe interface.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/boot/dts/exynos5440.dtsi |   38 +++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/arm/boot/dts/exynos5440.dtsi b/arch/arm/boot/dts/exynos5440.dtsi
index 03d40c0..68d05e9 100644
--- a/arch/arm/boot/dts/exynos5440.dtsi
+++ b/arch/arm/boot/dts/exynos5440.dtsi
@@ -230,4 +230,42 @@
 		clocks = <&clock 24>;
 		clock-names = "usbhost";
 	};
+
+	pcie@290000 {
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
+	pcie@2a0000 {
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


