Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab3COH6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 03:58:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36097 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab3COH63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 03:58:29 -0400
X-AuditID: cbfee690-b7f656d0000007e3-43-5142d4a3eb54
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, balbi@ti.com, rob.herring@calxeda.com,
        kgene.kim@samsung.com, thomas.abraham@linaro.org,
        grant.likely@secretlab.ca, dianders@chromium.org, jg1.han@samsung.com,
        p.paneri@samsung.com
Subject: [PATCH v4 2/2] ARM: Exynos5250: Enabling samsung-usb3phy driver
Date: Fri, 15 Mar 2013 13:26:11 +0530
Message-id: <1363334171-21812-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1363334171-21812-1-git-send-email-gautam.vivek@samsung.com>
References: <1363334171-21812-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsWyRsSkSnfxFadAg7WPFSwO3q+3ODD7IavF
	2WUH2SxendnIZnF54SVWi94FV4GsXXPYLGac38dksWhZK7PF+S2dTBaHVxxgsjg2YwmjA4/H
	gs9X2D1mN1xk8bhzbQ+bx/kZCxk9+rasYvT4+VLH4/iN7UwenzfJBXBEcdmkpOZklqUW6dsl
	cGVMuXaCrWA5e8X6Wy+YGhg/s3YxcnJICJhIzLh2CsoWk7hwbz1bFyMXh5DAUkaJ9ns74Ira
	fv5igkhMZ5R42rmVBcKZwiRxeu4qdpAqNgFdiaa3uxhBbBGBdIn/d/sZQYqYBW4xSmyZeReo
	nYNDWMBD4nNvNkgNi4CqxLd7U8DqeYHCyw5fZYbYpiDx5vYzMJtTwFNi4tJ3LCC2EFDNnY6V
	zCAzJQSusUt8ePuWEWKQgMS3yYdYQOZLCMhKbDoANUdS4uCKGywTGIUXMDKsYhRNLUguKE5K
	LzLRK07MLS7NS9dLzs/dxAiMmtP/nk3YwXjvgPUhxmSgcROZpUST84FRl1cSb2hsZmRhamJq
	bGRuaUaasJI4r3qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxi7BbBM+r7tLNibs+qFW
	9y/leWlA2tPzO1a92p/UaJqQfOfeiWWVv6brHteyCtWcYy778bzrhLcf/u41qrgl6bD3YtgS
	iUkLqrp1FFn2/a0u8fnz4uG9XhG/a/9v+OtWqn15Y/Eq7kv2zZtHrLkurzySNnXyBkXuR8Kx
	z/Lv786/8mr7v3VLJ31RYinOSDTUYi4qTgQAWgKK0rACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jQd3FV5wCDc68FrU4eL/e4sDsh6wW
	Z5cdZLN4dWYjm8XlhZdYLXoXXAWyds1hs5hxfh+TxaJlrcwW57d0MlkcXnGAyeLYjCWMDjwe
	Cz5fYfeY3XCRxePOtT1sHudnLGT06NuyitHj50sdj+M3tjN5fN4kF8AR1cBok5GamJJapJCa
	l5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0rZJCWWJOKVAoILG4WEnf
	DtOE0BA3XQuYxghd35AguB4jAzSQsIYxY8q1E2wFy9kr1t96wdTA+Jm1i5GTQ0LARKLt5y8m
	CFtM4sK99WxdjFwcQgLTGSWedm5lgXCmMEmcnruKHaSKTUBXountLkYQW0QgXeL/3X5GkCJm
	gVuMEltm3gUaxcEhLOAh8bk3G6SGRUBV4tu9KWD1vEDhZYevMkNsU5B4c/sZmM0p4Ckxcek7
	FhBbCKjmTsdK5gmMvAsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBMfkM6kdjCsbLA4x
	CnAwKvHwHuh3CBRiTSwrrsw9xCjBwawkwuvp5RgoxJuSWFmVWpQfX1Sak1p8iDEZ6KqJzFKi
	yfnAdJFXEm9obGJuamxqaWJhYmZJmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYzJYs9Z
	dJPj373/7TftQLfr9Ekzps9yaG9m2XnzmpP9y/RextxQPZsz/u9Z+3nj2yaFh2/gsd7hNPfc
	rbPzchw+L7gv961byXFVl0LEoaf1JWu/fl8k7ODW7yht5HLgyKSPb3mt7DgrCtqOxLRkzvj5
	78fatCNFPwMWpAssb2qJum/b8vmjv4kSS3FGoqEWc1FxIgCt37J2DQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding usb3.0 phy node for Exynos5250 along with the
necessary device data to be parsed.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 5ef9c1e..5b6f8c8 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -398,6 +398,20 @@
 		dma-names = "tx", "rx";
 	};
 
+	usbphy@12100000 {
+		compatible = "samsung,exynos5250-usb3phy";
+		reg = <0x12100000 0x100>;
+		clocks = <&clock 1>, <&clock 286>;
+		clock-names = "ext_xtal", "usbdrd30";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		usbphy-sys {
+			reg = <0x10040704 0x8>;
+		};
+	};
+
 	usb@12110000 {
 		compatible = "samsung,exynos4210-ehci";
 		reg = <0x12110000 0x100>;
-- 
1.7.6.5

