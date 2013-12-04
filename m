Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab3LDKKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:10:07 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:34165 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab3LDKJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:09:54 -0500
X-AuditID: cbfee68d-b7f5c6d000004aff-62-529eff7068c7
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, rob.herring@calxeda.com,
        kgene.kim@samsung.com, kishon@ti.com, jg1.han@samsung.com,
        s.nawrocki@samsung.com, t.figa@samsung.com, jwerner@chromium.org,
        k.debski@samsung.com
Subject: [PATCH v2 3/4] dt: exynos5420: Enable support for USB 3.0 PHY
 controller
Date: Wed, 04 Dec 2013 15:39:06 +0530
Message-id: <1386151747-3209-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1386151747-3209-1-git-send-email-gautam.vivek@samsung.com>
References: <1386151747-3209-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkVrfg/7wgg8ebDCwO3q+3ODD7IatF
	8+L1bBaXF15iteg49JjJ4sfrC2wWvQuusllceNrDZrGwbQmLxeVdc9gsZpzfx2SxaFkrs8Xh
	FQeYLA6/aWe1WD/jNYsDv8eCz1fYPWY3XGTx2D93DbvH+RkLGT36tqxi9Dh+YzuTx+dNcgHs
	UVw2Kak5mWWpRfp2CVwZH998Yyx4zFUxY+575gbG2xxdjJwcEgImEv37e1kgbDGJC/fWs3Ux
	cnEICSxllOiZdo+9i5EDrOjSESWI+HRGiWtXtzBBOFOYJL6/mcME0s0moCvR9HYXI4gtIpAu
	8f9uP5jNLDCTSWLKZkmQQcICwRI9d/1BTBYBVYm588JBKngF3CUmnDrBBnGDgsSb28+YQWxO
	AQ+JlRsngE0RAqrZ9fIFM8haCYGX7BLtK4+ANbAICEh8m3yIBeJOWYlNB5gh5khKHFxxg2UC
	o/ACRoZVjKKpBckFxUnpRYZ6xYm5xaV56XrJ+bmbGIFRdPrfs94djLcPWB9iTAYaN5FZSjQ5
	HxiFeSXxhsZmRhamJqbGRuaWZqQJK4nzJj1MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA
	6KHzQffgF+FNIRPSO7u2LxcJTd3lUH/j5mGZQ5rG6xXlReJWC5iL1rotFL04LVQi0KSAu2iX
	pZWkyVl9ziP/9//JblqZqFTxuj1AUrHvdOm23XN21y3TtJ2fPylBwfyY0dlquQfcU8ssJh56
	b3c3eaWVnsGU2BurLxQmyKUK1qQufX7Bj2mWEktxRqKhFnNRcSIAIZDES7gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xoG7B/3lBBjduqVkcvF9vcWD2Q1aL
	5sXr2SwuL7zEatFx6DGTxY/XF9gsehdcZbO48LSHzWJh2xIWi8u75rBZzDi/j8li0bJWZovD
	Kw4wWRx+085qsX7GaxYHfo8Fn6+we8xuuMjisX/uGnaP8zMWMnr0bVnF6HH8xnYmj8+b5ALY
	oxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOADldS
	KEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZnx8842x4DFXxYy575kbGG9z
	dDFycEgImEhcOqLUxcgJZIpJXLi3nq2LkYtDSGA6o8S1q1uYIJwpTBLf38xhAqliE9CVaHq7
	ixHEFhFIl/h/tx/MZhaYySQxZbMkyFBhgWCJnrv+ICaLgKrE3HnhIBW8Au4SE06dYIPYpSDx
	5vYzZhCbU8BDYuXGCWBThIBqdr18wTyBkXcBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxN
	jOAYfSa1g3Flg8UhRgEORiUe3gTOeUFCrIllxZW5hxglOJiVRHgz/wCFeFMSK6tSi/Lji0pz
	UosPMSYDHTWRWUo0OR+YPvJK4g2NTcxNjU0tTSxMzCxJE1YS5z3Qah0oJJCeWJKanZpakFoE
	s4WJg1OqgXHbMUPnAysTi5kzVar5fyh0aIVsdYi/skvsjMPy8lVfZ2cFzbk538P2zrf5jgH1
	hl9ajzexOBld6LsctXyjSFHKdu1T7V9r/t6Nkcn2fv1C6/TZ8L4bye4/3k/n9EnwupL1Pin/
	k5uBYsNEhtYV4iZRzx/tLHt8w4z51YMHBg9my4sdXz3hb7cSS3FGoqEWc1FxIgASJaujFQMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree nodes for USB 3.0 PHY present alongwith
USB 3.0 controller Exynos 5420 SoC. This phy driver is
based on generic phy framework.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/boot/dts/exynos5420.dtsi |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 09aa06c..a88ab00 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -31,6 +31,8 @@
 		i2c1 = &i2c_1;
 		i2c2 = &i2c_2;
 		i2c3 = &i2c_3;
+		usb3phy0 = &usb3_phy0;
+		usb3phy1 = &usb3_phy1;
 	};
 
 	cpus {
@@ -310,4 +312,22 @@
 		clocks = <&clock 431>, <&clock 143>;
 		clock-names = "mixer", "sclk_hdmi";
 	};
+
+	usbphy@12100000 {
+		compatible = "samsung,exynos5420-usb3phy";
+		reg = <0x12100000 0x100>;
+		clocks = <&clock 366>, <&clock 1>, <&clock 152>;
+		clock-names = "phy", "usb3phy_refclk", "usb30_sclk_100m";
+		samsung,syscon-phandle = <&pmu_syscon>;
+		#phy-cells = <0>;
+	};
+
+	usbphy@12500000 {
+		compatible = "samsung,exynos5420-usb3phy";
+		reg = <0x12500000 0x100>;
+		clocks = <&clock 367>, <&clock 1>, <&clock 153>;
+		clock-names = "phy", "usb3phy_refclk", "usb30_sclk_100m";
+		samsung,syscon-phandle = <&pmu_syscon>;
+		#phy-cells = <0>;
+	};
 };
-- 
1.7.6.5

