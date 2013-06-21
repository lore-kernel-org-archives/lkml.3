Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965812Ab3FUD0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 23:26:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52458 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965601Ab3FUD0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 23:26:14 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-b2-51c3c7d5ed70
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
Subject: [PATCH V9 4/4] ARM: dts: Add pcie controller node for
 exynos5440-ssdk5440
Date: Fri, 21 Jun 2013 12:26:13 +0900
Message-id: <002401ce6e2f$14c20160$3e460420$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5uLw1iKbjar6HPR5ePTc4nM6HAKA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t8zA92rxw8HGry8rWDR/H87q8XfScfY
	LZY0ZVi8PKRpcWD2Q1aLV2c2sllcXniJ1eL7DVOL3gVX2Sw2Pb7GanF51xw2i7PzjrNZzDi/
	j8li49RfjBbtl5QtVjRtZbRYfHE5s8X6Ga9ZLHavXMJicWzGEkaLpw+amBxEPdbMW8Po8fvX
	JEaPvilX2TyebLrI6LFgU6nHnWt72Dw2L6n3OD9jIaPH9x29QAVbVjF6/Hyp4/H0x15mj8+b
	5AJ4o7hsUlJzMstSi/TtErgyNn/Yz1bwlLPi5dO1rA2M/9m7GDk4JARMJE7Oyu1i5AQyxSQu
	3FvP1sXIxSEksIxRYtbKXewQCROJbz9bmSASixgl/q84ywrh/GKU+Lp1PyNIFZuAmsSXL4fB
	OkQE/CWuXW1lASliFuhgk9g0bxMrSEJYIESi/8BXFhCbRUBV4uW7+YwgZ/AKWEr822ULEuYV
	EJT4MfkeWAmzgJbE+p3HmSBseYnNa94yQ1ykILHj7GtGiF16EjcOXISqEZHY9+IdI8heCYE3
	HBLbD69ngtglIPFt8iEWiJdlJTYdgJojKXFwxQ2WCYxis5CsnoVk9Swkq2chWbGAkWUVo2hq
	QXJBcVJ6kYlecWJucWleul5yfu4mRkhymbCD8d4B60OMyUDrJzJLiSbnA5NTXkm8obGZkYWp
	iamxkbmlGWnCSuK86i3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYLaZ4LX5quk7QQTOQ
	4fjVr4ICez+WbprRL/1XNW3apuce+ZGsL65wLVwz+Z3uk4l7ev+xVbeIf7RkqOi+4J103vpB
	3lldoeMaO8w+3FPxtSlzCMr1YGDxv6mgvmTZ1WRPI6G4SXViTrUCLmFXRM/utY2omjfVWrhZ
	5NLTN3Ny1t350+fY+sNSiaU4I9FQi7moOBEAdhV2MkQDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnk+LIzCtJLcpLzFFi42I5/e+xgO7V44cDDeaukrJo/r+d1eLvpGPs
	FkuaMixeHtK0ODD7IavFqzMb2SwuL7zEavH9hqlF74KrbBabHl9jtbi8aw6bxdl5x9ksZpzf
	x2SxceovRov2S8oWK5q2Mlosvric2WL9jNcsFrtXLmGxODZjCaPF0wdNTA6iHmvmrWH0+P1r
	EqNH35SrbB5PNl1k9FiwqdTjzrU9bB6bl9R7nJ+xkNHj+45eoIItqxg9fr7U8Xj6Yy+zx+dN
	cgG8UQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	7yoplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYMzZ/2M9W8JSz4uXTtawN
	jP/Zuxg5OSQETCS+/WxlgrDFJC7cW8/WxcjFISSwiFHi/4qzrBDOL0aJr1v3M4JUsQmoSXz5
	chisW0TAX+La1VYWkCJmgQ42iU3zNrGCJIQFQiT6D3xlAbFZBFQlXr6bD9TMwcErYCnxb5ct
	SJhXQFDix+R7YCXMAloS63ceZ4Kw5SU2r3nLDHGRgsSOs68ZIXbpSdw4cBGqRkRi34t3jBMY
	BWYhGTULyahZSEbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZw8nomvYNxVYPF
	IUYBDkYlHt4ApcOBQqyJZcWVuYcYJTiYlUR4xSYChXhTEiurUovy44tKc1KLDzEmAz06kVlK
	NDkfmFjzSuINjU3MjCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoGx632P
	TzlL8HMtO5vVt/PUNTo/Tfzf9P+OoILWKvVZT/9PXX8v0ZXn+tPp9+9rnk9nWlzyMfHIpqqS
	0E65NfVSRr6lZ2pnL5BVUc1xCw/u9qpmY2rPE+NtsBWav3H+vAsfnS68SHLZcFR+zttdSUcN
	rHc9k1B/P8nNftW5e4zTJE2e6lYdl/mgxFKckWioxVxUnAgAfqVxbaIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds pcie controller node for exynos5440-ssdk5440,
and also adds a phandle for pin controller node.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/boot/dts/exynos5440-ssdk5440.dts |    8 ++++++++
 arch/arm/boot/dts/exynos5440.dtsi         |    2 +-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/exynos5440-ssdk5440.dts b/arch/arm/boot/dts/exynos5440-ssdk5440.dts
index f32cd77..ede7727 100644
--- a/arch/arm/boot/dts/exynos5440-ssdk5440.dts
+++ b/arch/arm/boot/dts/exynos5440-ssdk5440.dts
@@ -65,4 +65,12 @@
 			clock-frequency = <50000000>;
 		};
 	};
+
+	pcie@290000 {
+		reset-gpio = <&pin_ctrl 5 0>;
+	};
+
+	pcie@2a0000 {
+		reset-gpio = <&pin_ctrl 22 0>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos5440.dtsi b/arch/arm/boot/dts/exynos5440.dtsi
index 1ac4f5b..ff7f5d8 100644
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
-- 
1.7.10.4


