Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965264Ab3FTJfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:35:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:52688 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965229Ab3FTJfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:35:11 -0400
X-AuditID: cbfee68f-b7f436d000000f81-0d-51c2ccce7f1f
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
Subject: [PATCH V7 4/4] ARM: dts: Add pcie controller node for
 exynos5440-ssdk5440
Date: Thu, 20 Jun 2013 18:35:09 +0900
Message-id: <00ce01ce6d99$74e1ebf0$5ea5c3d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5tmXHI5Wv6GQ3tQU+PZ4QDetLfhA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t8zY91zZw4FGixq5LNo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmB0GPNfPWMHr8/jWJ0aNvylU2jyebLjJ6LNhU6nHn
	2h42j81L6j3Oz1jI6PF9Ry9QwZZVjB4/X+p4fN4kF8ATxWWTkpqTWZZapG+XwJWxceMHpoKn
	nBUL1lxnamD8z97FyMEhIWAi8fWlcxcjJ5ApJnHh3nq2LkYuDiGBZYwSl/fcY4FImEi8+LCM
	GSKxiFFiwadOJgjnF6PE4n9vWEGq2ATUJL58OcwOYosI+Etcu9rKAlLELDCJVeLXxEtMIAlh
	gRCJz+vWgTWwCKhKTNizgg3kDF4BS4mjexNBwrwCghI/JkNsZhbQkli/8zgThC0vsXnNW2aI
	ixQkdpx9zQixS09i480eNogaEYl9L94xguyVELjAIbFzzQUWiF0CEt8mH2KBeFlWYtMBqDmS
	EgdX3GCZwCg2C8nqWUhWz0KyehaSFQsYWVYxiqYWJBcUJ6UXGesVJ+YWl+al6yXn525ihKSL
	/h2Mdw9YH2JMBlo/kVlKNDkfmG7ySuINjc2MLExNTI2NzC3NSBNWEudVa7EOFBJITyxJzU5N
	LUgtii8qzUktPsTIxMEp1cC47w2rt6zT/+DgHMkJgV7SGtNST9/dosnptENm7yGVVzvf/X1R
	+tJJlnfKT7npO4smuCl+Sp52VWBx66/j/pEvF3euVmu+qxsb2Np6ttp6VVYk99+FjQ/F//+b
	q/9wb7pz+Rdmrvbk3Vuefe+9GOyscsO+1nl3jP0D1zqXmpPLfmk9iap6dGKdEktxRqKhFnNR
	cSIAfEF3UC0DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsVy+t9jAd1zZw4FGnydyGHR/H87q8XfScfY
	LZY0ZVgcmP2Q1eLVmY1sFpcXXmK1+H7D1KJ3wVU2i02Pr7FaXN41h83i7LzjbBYzzu9jsljR
	tJXRYvHF5cwWu1cuYbE4NmMJo8XTB01MDoIea+atYfT4/WsSo0fflKtsHk82XWT0WLCp1OPO
	tT1sHpuX1Hucn7GQ0eP7jl6ggi2rGD1+vtTx+LxJLoAnqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoLyWFssScUqBQQGJxsZK+HaYJoSFuuhYw
	jRG6viFBcD1GBmggYR1jxsaNH5gKnnJWLFhznamB8T97FyMnh4SAicSLD8uYIWwxiQv31rN1
	MXJxCAksYpRY8KmTCcL5xSix+N8bVpAqNgE1iS9fDoN1iwj4S1y72soCUsQsMIlV4tfES0wg
	CWGBEInP69aBNbAIqEpM2LMCaCwHB6+ApcTRvYkgYV4BQYkfk++xgNjMAloS63ceZ4Kw5SU2
	r3kLdZGCxI6zrxkhdulJbLzZwwZRIyKx78U7xgmMArOQjJqFZNQsJKNmIWlZwMiyilE0tSC5
	oDgpPddIrzgxt7g0L10vOT93EyM4HT2T3sG4qsHiEKMAB6MSD6/G5YOBQqyJZcWVuYcYJTiY
	lUR4U+ccChTiTUmsrEotyo8vKs1JLT7EmAz06ERmKdHkfGCqzCuJNzQ2MTOyNDKzMDIxNydN
	WEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGRs8jsbN6ahk+F5dOnLPv8vQDP1+IXT5itSvr
	3gXhTWafpkpcem/y/YXGzsU5bnfj9x//vWX3xl+mFZ8+HPHkLPXTvrBs58IoIflfmzcaCs6u
	d82L7VNhuJqx51/3dOnym8c4bDNWmpz4NtXiw+rE2SY66rN+WM1tm8ZeetTk8qnX33nX94TK
	rD6qxFKckWioxVxUnAgA5qnCcosDAAA=
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
index 68d05e9..de31f0c 100644
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


