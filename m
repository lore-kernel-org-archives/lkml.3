Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbbAWFDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:03:55 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:23420 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297AbbAWFDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:03:48 -0500
X-AuditID: cbfee68f-f791c6d000004834-6b-54c1d63173e1
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
Subject: [alsa-devel] [PATCH v4 3/3] ARM: dts: Add sound nodes for
 exynos4412-trats2
Date: Fri, 23 Jan 2015 14:03:30 +0900
Message-id: <1421989410-12490-4-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-reply-to: <1421989410-12490-1-git-send-email-ideal.song@samsung.com>
References: <1421989410-12490-1-git-send-email-ideal.song@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsWyRsSkRNfw2sEQgz3z1SyuXDzEZDH14RM2
	i/lHzrFa9L9ZyGpx4M8ORotdf+8zWpx7tZLRov/xa2aLb1c6mCw2Pb7GanF51xw2ixnn9zFZ
	3L7Ma7H0+kUmiwnT17JYdO7qZ7Vo3XuE3eLwm3ZWi4srvjBZvNz8hslBxGPD5yY2jzXz1jB6
	tDT3sHlc7utl8tg56y67x8rlX9g8Nq3qZPO4c20Pm8fmJfUe+94uY/Po27KK0WPz6WqPz5vk
	AnijuGxSUnMyy1KL9O0SuDJWz77HUvCQr2LbtcNMDYz3ubsYOTkkBEwk7r39xw5hi0lcuLee
	rYuRi0NIYCmjRPuNfkaYor03PzNBJKYzSnTPh3HmMElMnLGaDaSKTUBD4vvnzcxdjBwcIgLy
	Eofe54HUMAtcYZb4uGIWM0iNsECYRN/J6awgNouAqsTH75vAVvMKuEm8fPeJCWKbtsS+hpls
	IHM4Bdwlfh/iBQkLAZUcvHmTGaJkB4fE1BViEGMEJL5NPsQCUi4hICux6QBUiaTEwRU3WCYw
	Ci9gZFjFKJpakFxQnJReZKxXnJhbXJqXrpecn7uJERixp/8969/BePeA9SFGAQ5GJR7ehi0H
	Q4RYE8uKK3MPMZoCbZjILCWanA9MC3kl8YbGZkYWpiamxkbmlmZK4rwLpX4GCwmkJ5akZqem
	FqQWxReV5qQWH2Jk4uCUamDc88A4yUmc+Rj7VNFtnx+u83a9LLbcOXv5a5VL/htdQw5eadyd
	wla9ImR2XBvzhXcX79t4XXvkNqNnzpFH2wuUt17MVzc9l/TadINI69nuq7f1bzy/PutobJ7k
	Nr7Feq+KTBPb1dP7DxttvM/Zf3HzmY6ZttuYHs5zniZvu117xXpp8+dpd9gFlFiKMxINtZiL
	ihMBrZDk89MCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoK7htYMhBi/OyVhcuXiIyWLqwyds
	FvOPnGO16H+zkNXiwJ8djBa7/t5ntDj3aiWjRf/j18wW3650MFlsenyN1eLyrjlsFjPO72Oy
	uH2Z12Lp9YtMFhOmr2Wx6NzVz2rRuvcIu8XhN+2sFhdXfGGyeLn5DZODiMeGz01sHmvmrWH0
	aGnuYfO43NfL5LFz1l12j5XLv7B5bFrVyeZx59oeNo/NS+o99r1dxubRt2UVo8fm09UenzfJ
	BfBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gB9
	q6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMWD37HkvBQ76KbdcOMzUw
	3ufuYuTkkBAwkdh78zMThC0mceHeerYuRi4OIYHpjBLd80ESIM4cJomJM1azgVSxCWhIfP+8
	mbmLkYNDREBe4tD7PJAaZoErzBIfV8xiBqkRFgiT6Ds5nRXEZhFQlfj4fRM7iM0r4Cbx8t0n
	qG3aEvsaZrKBzOEUcJf4fYgXJCwEVHLw5k3mCYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXr
	JefnbmIEJ4RnUjsYVzZYHGIU4GBU4uFt2HIwRIg1say4MvcQowQHs5II75MDQCHelMTKqtSi
	/Pii0pzU4kOMpkBHTWSWEk3OByarvJJ4Q2MTMyNLI3NDCyNjcyVxXiX7thAhgfTEktTs1NSC
	1CKYPiYOTqkGxqXFvKr6E5Wm3S0rnSv48VppmY7C55Zzl39NXfjEXzP60ES1iT/LSy+7mEy/
	Gmp8ksFMXOR08pfFYgseNP7v3rGH1/Sb2cO28ylP4rUqvjHO1WlvsE1+oHg27a7mWVaD8vBL
	vH4VTs6NS7sOTfiZkPvC4t0eNdGWzwd0/9y9sG9mNU/u+zcPzyixFGckGmoxFxUnAgATlcB+
	HgMAAA==
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
 arch/arm/boot/dts/exynos4412-trats2.dts | 42 +++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 29231b4..6205b98 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -203,6 +203,25 @@
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
+			clocks = <&pmu_system_controller 0>;
+			clock-names = "MCLK1";
+			DCVDD-supply = <&ldo3_reg>;
+			DBVDD1-supply = <&ldo3_reg>;
+			wlf,ldo1ena = <&gpj0 4 0>;
+		};
+	};
+
 	i2c@138D0000 {
 		samsung,i2c-sda-delay = <100>;
 		samsung,i2c-slave-addr = <0x10>;
@@ -838,6 +857,24 @@
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
+		samsung,i2s-controller = <&i2s0>;
+		samsung,model = "Trats2";
+		samsung,audio-codec = <&wm1811>;
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
@@ -865,6 +902,11 @@
 	};
 };
 
+&pmu_system_controller {
+	assigned-clocks = <&pmu_system_controller 0>;
+	assigned-clock-parents =  <&clock CLK_XUSBXTI>;
+};
+
 &pinctrl_0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&sleep0>;
-- 
2.0.0.390.gcb682f8

