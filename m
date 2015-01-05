Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbbAELZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:25:48 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:18397 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbbAELZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:25:41 -0500
X-AuditID: cbfee68d-f79296d000004278-35-54aa74b242ca
From: Inha Song <ideal.song@samsung.com>
To: alsa-devel@alsa-project.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        s.nawrocki@samsung.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, kgene@kernel.org,
        sbkim73@samsung.com, lgirdwood@gmail.com, broonie@kernel.org,
        perex@perex.cz, tiwai@suse.de, grant.likely@linaro.org,
        ideal.song@samsung.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [alsa-devel] [PATCH 3/3] ARM: dts: Add sound nodes for
 exynos4412-trats2
Date: Mon, 05 Jan 2015 20:25:17 +0900
Message-id: <1420457117-11030-4-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-reply-to: <1420457117-11030-1-git-send-email-ideal.song@samsung.com>
References: <1420457117-11030-1-git-send-email-ideal.song@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsWyRsSkWHdTyaoQg/N/tCyuXDzEZDH14RM2
	i/lHzrFa9L9ZyGpx4M8ORotdf+8zWpx7tZLRov/xa2aLb1c6mCw2Pb7GanF51xw2ixnn9zFZ
	3L7Ma7H0+kUmiwnT17JYdO7qZ7Vo3XuE3eLwm3ZWi4srvjBZvNz8hslBxGPD5yY2jzXz1jB6
	tDT3sHlc7utl8tg56y67x8rlX9g8Nq3qZPO4c20Pm8fmJfUe+94uY/Po27KK0WPz6WqPz5vk
	AnijuGxSUnMyy1KL9O0SuDL2b9/MVrCWt2LG9veMDYzXuboYOTkkBEwkTm1azAJhi0lcuLee
	rYuRi0NIYCmjxKtlU5lgig6dPM4MkVjEKNE/7Q8ThDOHSWJt3zU2kCo2AQ2J7583A1VxcIgI
	yEscep8HUsMscIVZ4uOKWcwgNcICwRJ7jixhA6lhEVCVOPTcCSTMK+AmceHbaTaIZdoS+xpm
	gtmcAu4Sh86fYASxhYBqnm2aC3aEhMAWDonNmx+BFbEICEh8m3yIBWSmhICsxKYDzBBzJCUO
	rrjBMoFReAEjwypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MwJg9/e9Z7w7G2wesDzEKcDAq
	8fB6nFgZIsSaWFZcmXuI0RRow0RmKdHkfGBiyCuJNzQ2M7IwNTE1NjK3NFMS51WU+hksJJCe
	WJKanZpakFoUX1Sak1p8iJGJg1OqgXH+K2WBFdK2DWWNitMmtJtuklL9cUPjSF31Gf8997U/
	/PpSu2DHvkkRKzKyLr/OTJh77Zjg65V7zDml4kTPC7aueMf6vMXTfqNJgGhBS9/vy1Jbuy/X
	Lw9sn+9i0evWE9Cw6252XPGKj18uvcm1mN/pWXEt9HtvReud0iPd2zrCTvPZapT6iimxFGck
	GmoxFxUnAgAwB8Ez1AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO6mklUhBptXKVlcuXiIyWLqwyds
	FvOPnGO16H+zkNXiwJ8djBa7/t5ntDj3aiWjRf/j18wW3650MFlsenyN1eLyrjlsFjPO72Oy
	uH2Z12Lp9YtMFhOmr2Wx6NzVz2rRuvcIu8XhN+2sFhdXfGGyeLn5DZODiMeGz01sHmvmrWH0
	aGnuYfO43NfL5LFz1l12j5XLv7B5bFrVyeZx59oeNo/NS+o99r1dxubRt2UVo8fm09UenzfJ
	BfBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gB9
	q6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM2L99M1vBWt6KGdvfMzYw
	XufqYuTkkBAwkTh08jgzhC0mceHeerYuRi4OIYFFjBL90/4wQThzmCTW9l1jA6liE9CQ+P55
	M1AHB4eIgLzEofd5IDXMAleYJT6umAU2SVggWGLPkSVsIDUsAqoSh547gYR5BdwkLnw7zQax
	TFtiX8NMMJtTwF3i0PkTjCC2EFDNs01zmScw8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpec
	n7uJEZwQnknvYFzVYHGIUYCDUYmH1+PEyhAh1sSy4srcQ4wSHMxKIryv0leFCPGmJFZWpRbl
	xxeV5qQWH2I0BTpqIrOUaHI+MFnllcQbGpuYGVkamRtaGBmbK4nzKtm3hQgJpCeWpGanphak
	FsH0MXFwSjUwcvCfMb6/r8Mh8M7sF9PiesJlotnmWNdNVNK/6L3PSe+F8Rq9zwoFbmqeT+8H
	XN3ydHu03Mb/TdfYWfvmtE+588gjf93mXn73r448LYHTEn4dmSUyTzLgH7fjnIPW7YIftTZ8
	5i9YMGe94YptDP+quaIy/9Tubw6e9XnpNTfjw0zTj7XtM/v6V4mlOCPRUIu5qDgRAC8tVfce	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add WM1811 audio codec, I2S interface and the sound
machine nodes to enable audio on exynos4412-trats2 board.

Signed-off-by: Inha Song <ideal.song@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts | 38 +++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 29231b4..2943ce7 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -203,6 +203,23 @@
 		};
 	};
 
+	i2c@138A0000 {
+		samsung,i2c-sda-delay = <100>;
+		samsung,i2c-slave-addr = <0x10>;
+		samsung,i2c-max-bus-freq = <100000>;
+		pinctrl-0 = <&i2c4_bus>;
+		pinctrl-names = "default";
+		status = "okay";
+
+		wm1811: wm1811@1a {
+			compatible = "wlf,wm1811";
+			reg = <0x1a>;
+			DCVDD-supply = <&ldo3_reg>;
+			DBVDD1-supply = <&ldo3_reg>;
+			wlf,ldo1ena = <&gpj0 4 0>;
+		};
+	};
+
 	i2c@138D0000 {
 		samsung,i2c-sda-delay = <100>;
 		samsung,i2c-slave-addr = <0x10>;
@@ -838,6 +855,27 @@
 		};
 	};
 
+	i2s0: i2s@03830000 {
+		pinctrl-0 = <&i2s0_bus>;
+		pinctrl-names = "default";
+		status = "okay";
+	};
+
+	sound {
+		compatible = "samsung,trats2-audio";
+		clocks = <&pmu_system_controller 0>;
+		clock-names = "mclk";
+		assigned-clocks = <&pmu_system_controller 0>;
+		assigned-clock-parents =  <&clock CLK_XUSBXTI>;
+		samsung,i2s-controller = <&i2s0>;
+		samsung,model = "wm1811";
+		samsung,audio-routing =
+			"SPK", "SPKOUTLN",
+			"SPK", "SPKOUTLP",
+			"SPK", "SPKOUTRN",
+			"SPK", "SPKOUTRP";
+	};
+
 	exynos-usbphy@125B0000 {
 		status = "okay";
 	};
-- 
2.0.0.390.gcb682f8

