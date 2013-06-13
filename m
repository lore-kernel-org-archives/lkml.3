Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab3FMNXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:23:32 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59065 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab3FMNX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:23:28 -0400
X-AuditID: cbfee68f-b7f436d000000f81-d3-51b9c7cf5125
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
Subject: [PATCH V5 3/3] ARM: dts: Add pcie controller node for Samsung
 EXYNOS5440 SoC
Date: Thu, 13 Jun 2013 22:23:27 +0900
Message-id: <000d01ce6839$3047a7b0$90d6f710$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5oOSv8qQGnmL7BQ06oETm+Cuu/eA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t8zI93zx3cGGjxZpGDR/H87q8XfScfY
	LZY0ZVgcmP2Q1eLVmY1sFpcXXmK1+H7D1KJ3wVU2i02Pr7FaXN41h83i7LzjbBYzzu9jsljR
	tJXRYvHF5cwWu1cuYbE4NmMJo8XTB01MDoIea+atYfT4/WsSo0fflKtsHk82XWT0WLCp1OPO
	tT1sHpuX1Hucn7GQ0eP7jl6ggi2rGD1+vtTx+LxJLoAnissmJTUnsyy1SN8ugStj8qHNLAW9
	ohWf/15hbWC8KNDFyMkhIWAisWDlPFYIW0ziwr31bCC2kMAyRontTz1gaiYeWMjUxcgFFF/E
	KLFs30MmiKJfjBI75+aC2GwCahJfvhxmB7FFBPwlrl1tZQFpYBaYxCrxa+IlsAZhgXCJL1MO
	MYLYLAKqEgs6l4PFeQUsJeZsf80GYQtK/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aIixQkdpx9
	DTSHA2iZnsTb96kQJSIS+168YwTZKyFwhkPibcMUJohdAhLfJh9iAamXEJCV2HQAaoykxMEV
	N1gmMIrNQrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXFSelFxnrFibnFpXnpesn5uZsYIcmifwfj
	3QPWhxiTgdZPZJYSTc4HJpu8knhDYzMjC1MTU2Mjc0sz0oSVxHnVWqwDhQTSE0tSs1NTC1KL
	4otKc1KLDzEycXBKNTBKODyRYnLmSmcxlv1Qrbe3jHvuwmmbuStPhQpcPfXiQMVXQaGkLUE8
	6W/Y1BucRc49vTKxVGxukJiccp28f+Nc1WnhH0tzXxt+D3mcoXNSlWu+vxSr1FeuCo6/+zfs
	c7uaK+Py2XNzbsbtMEcJAfG1kvx8jy99FLrQfKnX8q/qVLnv50798FFiKc5INNRiLipOBACL
	6a0WLAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsVy+t9jAd3zx3cGGrw9K23R/H87q8XfScfY
	LZY0ZVgcmP2Q1eLVmY1sFpcXXmK1+H7D1KJ3wVU2i02Pr7FaXN41h83i7LzjbBYzzu9jsljR
	tJXRYvHF5cwWu1cuYbE4NmMJo8XTB01MDoIea+atYfT4/WsSo0fflKtsHk82XWT0WLCp1OPO
	tT1sHpuX1Hucn7GQ0eP7jl6ggi2rGD1+vtTx+LxJLoAnqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoLyWFssScUqBQQGJxsZK+HaYJoSFuuhYw
	jRG6viFBcD1GBmggYR1jxuRDm1kKekUrPv+9wtrAeFGgi5GTQ0LARGLigYVMELaYxIV769m6
	GLk4hAQWMUos2/cQLCEk8ItRYufcXBCbTUBN4suXw+wgtoiAv8S1q60sIA3MApNYJX5NvATW
	ICwQLvFlyiFGEJtFQFViQedysDivgKXEnO2v2SBsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nL
	DHGRgsSOs6+B5nAALdOTePs+FaJERGLfi3eMExgFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJB
	cVJ6rqFecWJucWleul5yfu4mRnAyeia1g3Flg8UhRgEORiUe3hetOwKFWBPLiitzDzFKcDAr
	ifDenLozUIg3JbGyKrUoP76oNCe1+BBjMtCjE5mlRJPzgYkyryTe0NjEzMjSyMzCyMTcnDRh
	JXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoYRf9ZXWk4b3t13uNz3Akpa4pClXyEz7lvLbj4
	/kvwPZnGrJSuEzKO9ZWv4g8WLrWLa5tsWyO0UVfyW/ikjW/a3xRvnurWu3CCnoCHybWDESo/
	lG/8mKy2vLot+b3qb4aOW5e6/GwKF1S/u/ZgsecqthNqipJCkx1PvVg1teSg1TfzFqdHwR0V
	SizFGYmGWsxFxYkAAj91XIoDAAA=
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

 arch/arm/boot/dts/exynos5440-ssdk5440.dts |    8 ++++++
 arch/arm/boot/dts/exynos5440.dtsi         |   40 ++++++++++++++++++++++++++++-
 2 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5440-ssdk5440.dts b/arch/arm/boot/dts/exynos5440-ssdk5440.dts
index d55042b..198b3c1 100644
--- a/arch/arm/boot/dts/exynos5440-ssdk5440.dts
+++ b/arch/arm/boot/dts/exynos5440-ssdk5440.dts
@@ -30,4 +30,12 @@
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
index f6b1c89..9d40e0e 100644
--- a/arch/arm/boot/dts/exynos5440.dtsi
+++ b/arch/arm/boot/dts/exynos5440.dtsi
@@ -113,7 +113,7 @@
 		clock-names = "spi", "spi_busclk0";
 	};
 
-	pinctrl {
+	pin_ctrl: pinctrl {
 		compatible = "samsung,exynos5440-pinctrl";
 		reg = <0xE0000 0x1000>;
 		interrupts = <0 37 0>, <0 38 0>, <0 39 0>, <0 40 0>,
@@ -216,4 +216,42 @@
 		clock-names = "rtc";
 		status = "disabled";
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


