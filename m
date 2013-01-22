Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab3AVPZP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 10:25:15 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:63504 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab3AVPZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 10:25:09 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-9b-50feaf542463
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, kgene.kim@samsung.com,
        grant.likely@secretlab.ca, dianders@chromium.org, balbi@ti.com,
        thomas.abraham@linaro.org, sylvester.nawrocki@gmail.com,
        tomasz.figa@gmail.com, p.paneri@samsung.com
Subject: [PATCH v2 1/2] ARM: Exynos5250: Enabling samsung-usbphy driver
Date: Tue, 22 Jan 2013 21:01:19 +0530
Message-id: <1358868680-5757-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1358868680-5757-1-git-send-email-gautam.vivek@samsung.com>
References: <1358868680-5757-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsWyRsSkSjdk/b8Ag+5fPBaXd81hs5hxfh+T
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZSzZs421YDt7xZ91VQ2ML1i7GDk5JARMJFb/
	2ccEYYtJXLi3nq2LkYtDSGApo8Tc5/PYuxg5wIrenFWHiE9nlNjzaCojhDOZSeL9x/UsIN1s
	AroSTW93MYLYIgKqEp/bFrCDFDELLGaSuLtxJlhCWMBd4tKCGcwgNgtQ0cvtL1lBNvACxW/M
	iIW4QkHize1nYCWcAh4SBzf9AbtUCKhk68JLrCAzJQTus0kcmLucDWKOgMS3yYdYIC6Vldh0
	gBlijqTEwRU3WCYwCi9gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERiUp/89k97BuKrB
	4hCjAAejEg/vg/t/A4RYE8uKK3MPMUpwMCuJ8OrW/wsQ4k1JrKxKLcqPLyrNSS0+xJgMtHwi
	s5Rocj4wYvJK4g2NTcxNjU0tjYzMTE1JE1YS52U89SRASCA9sSQ1OzW1ILUIZgsTB6dUA6PY
	9qTl3OzWTxLXXjysdW/K+maFKpOXu2sS7rk9N7xwS15J91rh9i8XDqhPP9p0YPZm4YPnblny
	W23dO3Pn1yW7Ug7WyLTabjGrtYva0VYRzZW75y/TlgmzZC6wb9nBerTo5e4tb/b8vPB57+aZ
	c7//65hQzbh/56G1nHK6bbY6Oz1mq9b+C2T6pcRSnJFoqMVcVJwIAJxBrnGOAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t9jQd3g9f8CDP59tLK4vGsOm8WM8/uY
	LBYta2V2YPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFjyZ5t
	rAXb2Sv+rKtqYHzB2sXIwSEhYCLx5qx6FyMnkCkmceHeerYuRi4OIYHpjBJ7Hk1lhHAmM0m8
	/7ieBaSKTUBXountLkYQW0RAVeJz2wJ2kCJmgcVMEnc3zgRLCAu4S1xaMIMZxGYBKnq5/SXY
	Nl6g+I0ZsRDbFCTe3H4GVsIp4CFxcNMfVhBbCKhk68JLrBMYeRcwMqxiFE0tSC4oTkrPNdIr
	TswtLs1L10vOz93ECA75Z9I7GFc1WBxiFOBgVOLhfXD/b4AQa2JZcWXuIUYJDmYlEV7d+n8B
	QrwpiZVVqUX58UWlOanFhxiTgY6ayCwlmpwPjMe8knhDYxNzU2NTSxMLEzNL0oSVxHkZTz0J
	EBJITyxJzU5NLUgtgtnCxMEp1cCY5RBaFs4rJ3zgqrXwTtEOgTXztuob/5++4NLRVuPoKtGF
	r7h+c5X5x69yn5XpGyCm8Lr5evNGqeythhH1M6+za5puuf94j82uhO7C7HeX9rXbK2x4tNUq
	yUWrrvpgipub0z5GDZMk9fLHqnMD+fKVjmX5a4R0bW7RfNC95ZDlzkzn6t8fZJRYijMSDbWY
	i4oTAdDTe+G9AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding usbphy node for Exynos5250 along with the
necessary device data to be parsed.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5250.dtsi |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 30485de..610e338 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -275,6 +275,21 @@
 		#size-cells = <0>;
 	};
 
+	usbphy@12130000 {
+		compatible = "samsung,exynos5250-usbphy";
+		reg = <0x12130000 0x100>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		usbphy-sys {
+			      /* USB device and host PHY_CONTROL registers */
+			reg = <0x10040704 0x8>,
+			      /* USB2.0 PHY configuration register */
+			      <0x10050230 0x4>;
+		};
+	};
+
 	amba {
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
1.7.6.5

