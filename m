Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030417Ab3FUHZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:25:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20126 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030336Ab3FUHZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:25:54 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-5e-51c40000269c
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
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V10 3/4] ARM: dts: Add pcie controller node for Samsung
 EXYNOS5440 SoC
Date: Fri, 21 Jun 2013 16:25:51 +0900
Message-id: <003c01ce6e50$8f55d890$ae0189b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5uUI3TybM2zsuMRXaVqkteDwsW/w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t8zY10GhiOBBg+7DCya/29ntfg76Ri7
	xZKmDIuXhzQtDsx+yGrx6sxGNovLCy+xWny/YWrRu+Aqm8Wmx9dYLS7vmsNmcXbecTaLGef3
	MVlsnPqL0aL9krLFiqatjBaLLy5ntlg/4zWLxe6VS1gsjs1Ywmjx9EETk4Oox5p5axg9fv+a
	xOjRN+Uqm8eTTRcZPRZsKvW4c20Pm8fmJfUe52csZPT4vqMXqGDLKkaPny91PJ7+2Mvs8XmT
	XABvFJdNSmpOZllqkb5dAlfGzdN9LAX3+Ssedac3MO7h6WLk5JAQMJG48uAgC4QtJnHh3nq2
	LkYuDiGBZYwSZ+b1MMMUNTWdY4JILGKU2HtmAlTVL0aJJ5e+sYNUsQmoSXz5chjMFhHwl7h2
	tZUFpIhZoINNYtO8TawgCWGBCIkF+/qYQGwWAVWJZ6/XMnYxcnDwClhK/NmkAxLmFRCU+DH5
	HthJzAJaEut3HmeCsOUlNq95C3WRgsSOs68ZIXbpSew7t4QZokZEYt+Ld4wgeyUE3nBIbHwP
	UcQiICDxbfIhFpBdEgKyEpsOQM2RlDi44gbLBEaxWUhWz0KyehaS1bOQrFjAyLKKUTS1ILmg
	OCm9yESvODG3uDQvXS85P3cTIyS5TNjBeO+A9SHGZKD1E5mlRJPzgckpryTe0NjMyMLUxNTY
	yNzSjDRhJXFe9RbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2Mud0Ss0tEhCqmKZ1k6v5S
	VjJtz97q/Mmn3n3UPuDwOcF38Z6v0/d9qn62yEaPca3ufMcyZc1lKesj4qo3X59+cM/67LYZ
	RR/42q+ZzOHRTGtU7uHv1Oz0OBQj4Wjd2ij83lu5cLHBlPt39/x1thc5dzvy/wWvJH9d+7yk
	W2s+xdnv6jcIW/hAiaU4I9FQi7moOBEA+rDaS0QDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjk+LIzCtJLcpLzFFi42I5/e+xgC4Dw5FAg3uzNC2a/29ntfg76Ri7
	xZKmDIuXhzQtDsx+yGrx6sxGNovLCy+xWny/YWrRu+Aqm8Wmx9dYLS7vmsNmcXbecTaLGef3
	MVlsnPqL0aL9krLFiqatjBaLLy5ntlg/4zWLxe6VS1gsjs1Ywmjx9EETk4Oox5p5axg9fv+a
	xOjRN+Uqm8eTTRcZPRZsKvW4c20Pm8fmJfUe52csZPT4vqMXqGDLKkaPny91PJ7+2Mvs8XmT
	XABvVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	u0oKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjJun+1gK7vNXPOpOb2Dc
	w9PFyMkhIWAi0dR0jgnCFpO4cG89WxcjF4eQwCJGib1nJkA5vxglnlz6xg5SxSagJvHly2Ew
	W0TAX+La1VYWkCJmgQ42iU3zNrGCJIQFIiQW7OsDG8sioCrx7PVaxi5GDg5eAUuJP5t0QMK8
	AoISPybfYwGxmQW0JNbvPM4EYctLbF7zlhniIgWJHWdfM0Ls0pPYd24JM0SNiMS+F+8YJzAK
	zEIyahaSUbOQjJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjODU9Ux6B+OqBotD
	jAIcjEo8vAFKhwOFWBPLiitzDzFKcDArifAG3wEK8aYkVlalFuXHF5XmpBYfYkwGenQis5Ro
	cj4wreaVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUAyPX0fsL
	NoqsfdS1O/jQMcYl5dvLp9dVLd4+35ovW2hNxcGOlQtnbE0xqWqcrexfvvf9G/t533ZuSw9/
	c6RzgWtAVfPbi19v7pZckn49LO6e2OorzV0HmU9HrOPs/qaW9G9lTbOf658AQf4Ibft0r7yQ
	+Zcu2UZVGvzUnJTw/Uyo4e68F0vnebEpsRRnJBpqMRcVJwIAhMjRIKEDAAA=
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
index 03d40c0..1ac4f5b 100644
--- a/arch/arm/boot/dts/exynos5440.dtsi
+++ b/arch/arm/boot/dts/exynos5440.dtsi
@@ -230,4 +230,42 @@
 		clocks = <&clock 24>;
 		clock-names = "usbhost";
 	};
+
+	pcie@290000 {
+		compatible = "samsung,exynos5440-pcie", "snps,dw-pcie";
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
+		compatible = "samsung,exynos5440-pcie", "snps,dw-pcie";
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


