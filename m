Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbbASJuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:50:16 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:44908 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959AbbASJtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:49:24 -0500
X-AuditID: cbfee68d-f79296d000004278-c2-54bcd2f31bad
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
Subject: [alsa-devel] [PATCH v2 3/3] ARM: dts: Add sound nodes for
 exynos4412-trats2
Date: Mon, 19 Jan 2015 18:48:22 +0900
Message-id: <1421660902-29679-4-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-reply-to: <1421660902-29679-1-git-send-email-ideal.song@samsung.com>
References: <1421660902-29679-1-git-send-email-ideal.song@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsWyRsSkRPfzpT0hBtt+altcuXiIyWLqwyds
	FvOPnGO16H+zkNXiwJ8djBa7/t5ntDj3aiWjRf/j18wW3650MFlsenyN1eLyrjlsFjPO72Oy
	uH2Z12Lp9YtMFhOmr2Wx6NzVz2rRuvcIu8XhN+2sFhdXfGGyeLn5DZODiMeGz01sHmvmrWH0
	aGnuYfO43NfL5LFz1l12j5XLv7B5bFrVyeZx59oeNo/NS+o99r1dxubRt2UVo8fm09UenzfJ
	BfBGcdmkpOZklqUW6dslcGVc2cJRcJW34sW1bWwNjN+5uhg5OSQETCQ+bF/JBmGLSVy4tx7I
	5uIQEljKKLHjwRU2mKLJb3sZIRLTGSXOz5nJBOHMYZI49+kFM0gVm4CGxPfPm4FsDg4RAXmJ
	Q+/zQGqYBa4wS3xcMQusRlggTOLGmVMsIDaLgKrE+sZljCA2r4CbxPPFZ9ghtmlL7GuYCbaZ
	U8BdounGSbAaIaCacxMXgJ0nIbCWQ+LMwVZGiEECEt8mH2IBWSwhICux6QAzxBxJiYMrbrBM
	YBRewMiwilE0tSC5oDgpvchQrzgxt7g0L10vOT93EyMwZk//e9a7g/H2AetDjAIcjEo8vBt8
	94QIsSaWFVfmHmI0BdowkVlKNDkfmBjySuINjc2MLExNTI2NzC3NlMR5FaV+BgsJpCeWpGan
	phakFsUXleakFh9iZOLglGpg3BmbUaDzolEoYe9XTrNS/y9y7/gr4p57X7kZ/GPvd7UNF72r
	RJ/tT1GTt1+z/jzTZ25TC9vDLo2lOxZkOW9ffmrzqqiFYTxZ3peSNxrs8Ftze27ELQ0/n+TX
	YQEz2p22B7i57WhqOP1sTdMeO/lQMa+fD8889uHsiZp1fqlM5vxpUbO9vla2KbEUZyQaajEX
	FScCAEi+sWTUAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoO7nS3tCDD5eU7K4cvEQk8XUh0/Y
	LOYfOcdq0f9mIavFgT87GC12/b3PaHHu1UpGi/7Hr5ktvl3pYLLY9Pgaq8XlXXPYLGac38dk
	cfsyr8XS6xeZLCZMX8ti0bmrn9Wide8RdovDb9pZLS6u+MJk8XLzGyYHEY8Nn5vYPNbMW8Po
	0dLcw+Zxua+XyWPnrLvsHiuXf2Hz2LSqk83jzrU9bB6bl9R77Hu7jM2jb8sqRo/Np6s9Pm+S
	C+CNamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAH6
	VkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMOYcWULR8FV3ooX17axNTB+
	5+pi5OSQEDCRmPy2lxHCFpO4cG89WxcjF4eQwHRGifNzZjJBOHOYJM59esEMUsUmoCHx/fNm
	IJuDQ0RAXuLQ+zyQGmaBK8wSH1fMAqsRFgiTuHHmFAuIzSKgKrG+cRnYBl4BN4nni8+wQ2zT
	ltjXMJMNxOYUcJdounESrEYIqObcxAVsExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P
	3cQITgjPpHYwrmywOMQowMGoxMPLEbAnRIg1say4MvcQowQHs5IIL+MFoBBvSmJlVWpRfnxR
	aU5q8SFGU6CrJjJLiSbnA5NVXkm8obGJmZGlkbmhhZGxuZI4r5J9W4iQQHpiSWp2ampBahFM
	HxMHp1QDY/NapT9sGQti22xmaf7yDctxOPH/yb6SY38E84OXSDeWu1nK5HZWPn/jrhY2O0qD
	/fzsoAjD7z4dkbmz737mXzvjkoztBuZXWgw/PmTd+CKtHlVQynrj0DslIddNkXc23Wiw8PUP
	+7VrudI6xavLF/0vkuhyFd48ceOGTwVF5+/MusJ20eDoeSWW4oxEQy3mouJEABlaRyEeAwAA
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
 arch/arm/boot/dts/exynos4412-trats2.dts | 39 +++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 29231b4..7a52cca 100644
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
@@ -838,6 +857,26 @@
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
+		assigned-clocks = <&pmu_system_controller 0>;
+		assigned-clock-parents =  <&clock CLK_XUSBXTI>;
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
-- 
2.0.0.390.gcb682f8

