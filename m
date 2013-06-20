Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab3FTMo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:44:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18416 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab3FTMoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:44:54 -0400
X-AuditID: cbfee691-b7fef6d000002d62-56-51c2f944d3cb
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
Subject: [PATCH V8 3/4] ARM: dts: Add pcie controller node for Samsung
 EXYNOS5440 SoC
Date: Thu, 20 Jun 2013 21:44:52 +0900
Message-id: <00dd01ce6db3$f56c4490$e044cdb0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5ts+9OsdJUUv/USOOPTYQaMtVcow==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t8zQ12Xn4cCDfaeNLBo/r+d1eLvpGPs
	FkuaMixeHtK0ODD7IavFqzMb2SwuL7zEavH9hqlF74KrbBabHl9jtbi8aw6bxdl5x9ksZpzf
	x2SxceovRov2S8oWK5q2Mlosvric2WL9jNcsFrtXLmGxODZjCaPF0wdNTA6iHmvmrWH0+P1r
	EqNH35SrbB5PNl1k9FiwqdTjzrU9bB6bl9R7nJ+xkNHj+45eoIItqxg9fr7U8Xj6Yy+zx+dN
	cgG8UVw2Kak5mWWpRfp2CVwZx7t0CvbzV5xrusHawDiPp4uRk0NCwETi3uIlrBC2mMSFe+vZ
	uhi5OIQEljFKXD3WzgJT9Oz2DKjEIkaJP8/6mSCcX4wSq5Y/YAepYhNQk/jy5TCYLSLgL3Ht
	aisLSBGzQAebxKZ5m8B2CAuES1y4v5UJxGYRUJVYdvIlWJxXwFJizYqDULagxI/J98BWMwto
	SazfeZwJwpaX2LzmLTPESQoSO86+ZoRYpicx5eE7dogaEYl9L94xgiyWEHjBIXHq62kWiGUC
	Et8mHwKyOYASshKbDkDNkZQ4uOIGywRGsVlIVs9CsnoWktWzkKxYwMiyilE0tSC5oDgpvchU
	rzgxt7g0L10vOT93EyMkvUzcwXj/gPUhxmSg9ROZpUST84HpKa8k3tDYzMjC1MTU2Mjc0ow0
	YSVxXvUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjGpnH0wSO/K+ZdEE59Ozi/b+Py/A
	0MHak9ufr8wp6fbEWS6sYdF9Ea2v0x7LmSx4f3XlkZoLU26IMV0RXrzYwbLEWvb2LDbL9K7n
	uzKl3AIu1T+bfOD9NYFNYja6YrqqPhxZC/hnLHxwdH5FfHiC3uUZKnanM1L0/B32nr8t9cNo
	8raUr/uPeyqxFGckGmoxFxUnAgATYrPMRQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnk+LIzCtJLcpLzFFi42I5/e+xgK7Lz0OBBlN/alo0/9/OavF30jF2
	iyVNGRYvD2laHJj9kNXi1ZmNbBaXF15itfh+w9Sid8FVNotNj6+xWlzeNYfN4uy842wWM87v
	Y7LYOPUXo0X7JWWLFU1bGS0WX1zObLF+xmsWi90rl7BYHJuxhNHi6YMmJgdRjzXz1jB6/P41
	idGjb8pVNo8nmy4yeizYVOpx59oeNo/NS+o9zs9YyOjxfUcvUMGWVYweP1/qeDz9sZfZ4/Mm
	uQDeqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	d5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGce7dAr281eca7rB2sA4
	j6eLkZNDQsBE4tntGWwQtpjEhXvrgWwuDiGBRYwSf571M0E4vxglVi1/wA5SxSagJvHly2Ew
	W0TAX+La1VYWkCJmgQ42iU3zNrGCJIQFwiUu3N/KBGKzCKhKLDv5EizOK2ApsWbFQShbUOLH
	5HssIDazgJbE+p3HmSBseYnNa94yQ5ykILHj7GtGiGV6ElMevmOHqBGR2PfiHeMERoFZSEbN
	QjJqFpJRs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnLyeSe9gXNVgcYhRgINR
	iYdX4/LBQCHWxLLiytxDjBIczEoivKlzDgUK8aYkVlalFuXHF5XmpBYfYkwG+nQis5Rocj4w
	seaVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2O2+P8pP93i
	npYfqbwSnyFRc4jh5830noD0HZsvae46USO9hTPL60e3+Es+QfaE+7VObgo8Gz5FPqvKF0m5
	e2dLdsCFk0XKnUu/TjXk4Xls9VTUNWzXObO3qkddfmj8d6pqmfnozNRrdV1FC/+3e8b5Swvf
	+mux1/tKhLXnWcE9TwrKThbO2qjEUpyRaKjFXFScCABqQpQWogMAAA==
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


