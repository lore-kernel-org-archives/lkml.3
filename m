Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab3CWEJW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 00:09:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59700 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab3CWEJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 00:09:20 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-9a-514d2aef096a
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
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com>
In-reply-to: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com>
Subject: [PATCH 6/6] ARM: dts: Add pcie controller node for Samsung EXYNOS5440
 SoC
Date: Sat, 23 Mar 2013 13:09:18 +0900
Message-id: <00c501ce277c$30e49dc0$92add940$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ne5IlJNJTIxgLT4K5aVV6JypTrgAAI7VA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t8zI933Wr6BBj8WCls0/9/OarGkKcPi
	wOyHrBavzmxks7i88BKrxfcbpha9C66yWWx6fI3V4vKuOWwWZ+cdZ7OYcX4fk8WKpq2MFosv
	Lme22L1yCYvFsRlLGC2ePmhichDwWDNvDaNH35SrbB5PNl1k9FiwqdTjzrU9bB6bl9R7nJ+x
	kNHj+45eoIItqxg9fr7U8fi8SS6AO4rLJiU1J7MstUjfLoEr40t/eMErgYr7E2+xNzAu5+1i
	5OSQEDCReLb5GBuELSZx4d56IJuLQ0hgGaPExvXdzDBFDSdesYLYQgLTGSX6NydAFP1ilOie
	184IkmATUJP48uUwO4gtIuAvce1qKwtIEbPAZxaJ5ZPPsEN020rcPTkXbCqngJ3E41aQIk4O
	YYEQiY3NK8E2sAioSjTNfgVUw8HBC1Q/8yUXSJhXQFDix+R7YOXMAloS63ceZ4Kw5SU2r3kL
	Vi4hoC7x6K8uxAlGEm23zrFClIhI7HvxjhHilyscEmv3KkBsEpD4NvkQC0SrrMSmA1DvSkoc
	XHGDZQKjxCwki2chWTwLyeJZSDYsYGRZxSiaWpBcUJyUXmSqV5yYW1yal66XnJ+7iRGSRCbu
	YLx/wPoQYzLQ+onMUqLJ+cAklFcSb2hsZmRhamJqbGRuaUaasJI4r3qLdaCQQHpiSWp2ampB
	alF8UWlOavEhRiYOTqkGRsVva9u9a9P6/X94HTppwdta/7Z22u29tXmXxUJWV2z7fDZ2r9Dp
	WI9vsUKBrttcLBX1So5v7snJFhOoYVbmSv66UYdZqXnVTtM931NrH32TCn4qKBDFZrDq159s
	+wU1L+/PZf7+aQHfOV2B6U951konnWN3Cyvd7/R4oehlhrqa1FtavyvMlViKMxINtZiLihMB
	hDu4tzgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42I5/e+xoO57Ld9Ag9c9fBbN/7ezWixpyrA4
	MPshq8WrMxvZLC4vvMRq8f2GqUXvgqtsFpseX2O1uLxrDpvF2XnH2SxmnN/HZLGiaSujxeKL
	y5ktdq9cwmJxbMYSRounD5qYHAQ81sxbw+jRN+Uqm8eTTRcZPRZsKvW4c20Pm8fmJfUe52cs
	ZPT4vqMXqGDLKkaPny91PD5vkgvgjmpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0
	tDBXUshLzE21VXLxCdB1y8wB+kZJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEa
	SFjHmPGlP7zglUDF/Ym32BsYl/N2MXJySAiYSDSceMUKYYtJXLi3ng3EFhKYzijRvzmhi5EL
	yP7FKNE9r50RJMEmoCbx5cthdhBbRMBf4trVVhaQImaBzywSyyefYYfotpW4e3IuM4jNKWAn
	8bgVpIiTQ1ggRGJj80qwbSwCqhJNs18B1XBw8ALVz3zJBRLmFRCU+DH5Hlg5s4CWxPqdx5kg
	bHmJzWvegpVLCKhLPPqrC3GCkUTbrXOsECUiEvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsY
	RVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgpPUM6kdjCsbLA4xCnAwKvHwBlT7BAqxJpYVV+Ye
	YpTgYFYS4b2n4RsoxJuSWFmVWpQfX1Sak1p8iDEZ6M+JzFKiyfnABJpXEm9obGJmZGlkZmFk
	Ym5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYw9a+7o810o5rv36o7p+a5mP+cf3QYv
	VQzPPyxQK1iVUN6Y1esxpeL4Ra5w68R9xZ/+s7evlpeYNf9Y2+LC1kdmv69sKvzTFZwwcd/F
	XpOdstvWLnxrw1mzdlOSI7P0+skzj82oX5LxdppJzPpkRuuG1osMll/+LG4VeuhR4zPbxTLQ
	/mzB5otKLMUZiYZazEXFiQAlxKdSlgMAAA==
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
 arch/arm/boot/dts/exynos5440-ssdk5440.dts |    8 +++++++
 arch/arm/boot/dts/exynos5440.dtsi         |   32 +++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5440-ssdk5440.dts b/arch/arm/boot/dts/exynos5440-ssdk5440.dts
index a21eb4c..746f9fc 100644
--- a/arch/arm/boot/dts/exynos5440-ssdk5440.dts
+++ b/arch/arm/boot/dts/exynos5440-ssdk5440.dts
@@ -34,4 +34,12 @@
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
index c374a31..41b2d2c 100644
--- a/arch/arm/boot/dts/exynos5440.dtsi
+++ b/arch/arm/boot/dts/exynos5440.dtsi
@@ -178,4 +178,36 @@
 		clocks = <&clock 21>;
 		clock-names = "rtc";
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
1.7.2.5


