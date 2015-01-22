Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750814AbbAVLS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 06:18:58 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:15666 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbbAVLS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:18:27 -0500
X-AuditID: cbfee68f-f791c6d000004834-5d-54c0dc7d9e62
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
Subject: [alsa-devel] [PATCH v3 4/4] ARM: dts: Add sound nodes for
 exynos4412-trats2
Date: Thu, 22 Jan 2015 20:18:02 +0900
Message-id: <1421925482-15861-5-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-reply-to: <1421925482-15861-1-git-send-email-ideal.song@samsung.com>
References: <1421925482-15861-1-git-send-email-ideal.song@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsWyRsSkULf2zoEQgxt/ZC2uXDzEZDH14RM2
	i/lHzrFa9L9ZyGpx4M8ORotdf+8zWpx7tZLRov/xa2aLb1c6mCw2Pb7GanF51xw2ixnn9zFZ
	3L7Ma7H0+kUmiwnT17JYdO7qZ7Vo3XuE3eLwm3ZWi4srvjBZvNz8hslBxGPD5yY2jzXz1jB6
	tDT3sHlc7utl8tg56y67x8rlX9g8Nq3qZPO4c20Pm8fmJfUe+94uY/Po27KK0WPz6WqPz5vk
	AnijuGxSUnMyy1KL9O0SuDL2zvnIUvCep6J93xL2BsYFXF2MnBwSAiYSX47sZYOwxSQu3FsP
	ZHNxCAksZZSYc2Q+YxcjB1hRx8ZciPgiRolJbd+YIZw5TBKbZj5lBulmE9CQ+P55MzNIg4iA
	vMSh93kgNcwCV5glPq6YBVYjLBAmsaRpHROIzSKgKvHo1EFGEJtXwE1icUcHI8QV2hL7GmaC
	XcQp4C5x8+5WMFsIqGZt3ySomrUcEmvvBkHMEZD4NvkQC8ShshKbDjBDlEhKHFxxg2UCo/AC
	RoZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGIERe/rfs/4djHcPWB9iFOBgVOLhzSg+ECLE
	mlhWXJl7iNEUaMNEZinR5HxgWsgriTc0NjOyMDUxNTYytzRTEuddKPUzWEggPbEkNTs1tSC1
	KL6oNCe1+BAjEwenVAOj0f+H3xwmB+YeXXc1+k3Cr0S9Yoa4Nculnfy6lYwsr1vfmjP3su4F
	45USlyNPlJ77/KXPYU/vrTM55mtX7Yr141p2+cvv19dFtvH9vFAXdLvrsJOx1RIlC/lfZ1t4
	VVh8OngTjO5tX9L3ToB7++bz3pOrzuW8WR3ZuHLhkke8l++stdmgZJc5UYmlOCPRUIu5qDgR
	AEd0zWvTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgG7tnQMhBq19ohZXLh5ispj68Amb
	xfwj51gt+t8sZLU48GcHo8Wuv/cZLc69Wslo0f/4NbPFtysdTBabHl9jtbi8aw6bxYzz+5gs
	bl/mtVh6/SKTxYTpa1ksOnf1s1q07j3CbnH4TTurxcUVX5gsXm5+w+Qg4rHhcxObx5p5axg9
	Wpp72Dwu9/UyeeycdZfdY+XyL2wem1Z1snncubaHzWPzknqPfW+XsXn0bVnF6LH5dLXH501y
	AbxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDf
	KimUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgz9s75yFLwnqeifd8S9gbG
	BVxdjBwcEgImEh0bc7sYOYFMMYkL99azdTFycQgJLGKUmNT2jRnCmcMksWnmU2aQKjYBDYnv
	nzczgzSLCMhLHHqfB1LDLHCFWeLjillgNcICYRJLmtYxgdgsAqoSj04dZASxeQXcJBZ3dDBC
	bNOW2Ncwkw3E5hRwl7h5dyuYLQRUs7ZvEuMERt4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS
	83M3MYITwjPpHYyrGiwOMQpwMCrx8GYUHwgRYk0sK67MPcQowcGsJMJregIoxJuSWFmVWpQf
	X1Sak1p8iNEU6KqJzFKiyfnAZJVXEm9obGJmZGlkbmhhZGyuJM6rZN8WIiSQnliSmp2aWpBa
	BNPHxMEp1cDY/ulY0Pn/l3QXTjQQSPFX8g9PfOPdY5EfHjVPnzl9vf+fgmMl2qnencHWE5oc
	MrR/TLo92VW/wy/fYEUd/6Lioo7SIh2GT7VN9u6O5yRtC1kaj1VyrQxuStwi8/rMLJvOuqK4
	fxefRXbWdfBGhvdd6/nfxmdxhemMQdhy/dipgrt8DbZ+U2Ipzkg01GIuKk4EAC2Ye1QeAwAA
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
 arch/arm/boot/dts/exynos4412-trats2.dts | 37 +++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 29231b4..ec1acaf 100644
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
-- 
2.0.0.390.gcb682f8

