Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbbAEL0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 06:26:32 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:53262 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbbAELZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:25:43 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-c8-54aa74b252a3
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
Subject: [alsa-devel] [PATCH 2/3] ASoC: samsung: Document Trats2 audio
 subsystem bindings
Date: Mon, 05 Jan 2015 20:25:16 +0900
Message-id: <1420457117-11030-3-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-reply-to: <1420457117-11030-1-git-send-email-ideal.song@samsung.com>
References: <1420457117-11030-1-git-send-email-ideal.song@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsWyRsSkRHdTyaoQg3VTZSyuXDzEZDH14RM2
	i/lHzrFa9L9ZyGpx4M8ORotdf+8zWpx7tZLRov/xa2aLb1c6mCw2Pb7GanF51xw2ixnn9zFZ
	3L7Ma7H0+kUmiwnT17JYdO7qZ7Vo3XuE3eLwm3ZWi4srvjBZvNz8hslBxGPD5yY2jzXz1jB6
	tDT3sHlc7utl8tg56y67x8rlX9g8Nq3qZPO4c20Pm8fmJfUe+94uY/Po27KK0WPz6WqPz5vk
	AnijuGxSUnMyy1KL9O0SuDJ27zrEWNDMUzHplV8DYxNXFyMnh4SAicTN2cdZIWwxiQv31rN1
	MXJxCAksZZR48PEVO0zRyxfP2SESixglLn87xgLhzGGSWNt3jQ2kik1AQ+L7583MXYwcHCIC
	8hKH3ueB1DALXGGW+LhiFjNIjbBAtMSFzUtYQGwWAVWJ6x+/sIHU8wq4SexebgWxTFtiX8NM
	sJGcAu4Sh86fYASxhYBKnm2aywwyU0JgC4fErM5/7BBzBCS+TT7EAjJHQkBWYtMBZog5khIH
	V9xgmcAovICRYRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGYMSe/vdswg7GewesDzEKcDAq
	8fB6nFgZIsSaWFZcmXuI0RRow0RmKdHkfGBayCuJNzQ2M7IwNTE1NjK3NFMS530t9TNYSCA9
	sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2P8OSnNiW8rL8sZ5aZVvDrSNrfjd866GauZNPddK561
	aOcdh6oNXp7+Z3bs+cQizugkwnF81jr7x+72S/ZmlE4+EfXnVGyNeVxEjaBayDo3feWMu5tL
	JnivMAhVikrgsvzX4fz0zErF2nvfTzJLXa4z231wD/sHW4MA27C97bG/p9Zq3Pza9VeJpTgj
	0VCLuag4EQDwRgox0wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgO6mklUhBjNuCltcuXiIyWLqwyds
	FvOPnGO16H+zkNXiwJ8djBa7/t5ntDj3aiWjRf/j18wW3650MFlsenyN1eLyrjlsFjPO72Oy
	uH2Z12Lp9YtMFhOmr2Wx6NzVz2rRuvcIu8XhN+2sFhdXfGGyeLn5DZODiMeGz01sHmvmrWH0
	aGnuYfO43NfL5LFz1l12j5XLv7B5bFrVyeZx59oeNo/NS+o99r1dxubRt2UVo8fm09UenzfJ
	BfBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gB9
	q6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHM2L3rEGNBM0/FpFd+DYxN
	XF2MnBwSAiYSL188Z4ewxSQu3FvP1sXIxSEksIhR4vK3YywQzhwmibV919hAqtgENCS+f97M
	3MXIwSEiIC9x6H0eSA2zwBVmiY8rZjGD1AgLREtc2LyEBcRmEVCVuP7xCxtIPa+Am8Tu5VYQ
	y7Ql9jXMBBvJKeAucej8CUYQWwio5NmmucwTGHkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dL
	zs/dxAhOB8+kdzCuarA4xCjAwajEw+txYmWIEGtiWXFl7iFGCQ5mJRHeV+mrQoR4UxIrq1KL
	8uOLSnNSiw8xmgIdNZFZSjQ5H5iq8kriDY1NzIwsjcwNLYyMzZXEeZXs20KEBNITS1KzU1ML
	Uotg+pg4OKUaGAO5mHfPUA9//VHz04/HxbzRLHvvuKupbjzbYbwv/vy6Gd8vbFj7e0fiJLmw
	gveSOzhrr6027Oq70Bb0xEfpVPPV/Uydqo1rF/A81OL2ltoZdXVOb5Jq266/yhaZqcd7ONb+
	y03XqnoXIMrkKrmtM69BbFmIPKt5oargpVMLnndprfpUOWGBrhJLcUaioRZzUXEiAHVkADId	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add Trats2 audio subsystem bindings document.

Signed-off-by: Inha Song <ideal.song@samsung.com>
---
 .../bindings/sound/samsung,trats2-wm1811.txt       | 31 ++++++++++++++++++++++
 1 file changed, 31 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/samsung,trats2-wm1811.txt

diff --git a/Documentation/devicetree/bindings/sound/samsung,trats2-wm1811.txt b/Documentation/devicetree/bindings/sound/samsung,trats2-wm1811.txt
new file mode 100644
index 0000000..9d4d3f1
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/samsung,trats2-wm1811.txt
@@ -0,0 +1,31 @@
+Samsung Exynos Trats2 audio with WM1811 codec
+
+Required properties:
+
+ - compatible : Must be "samsung,trats2-audio"
+
+ - clocks : Reference to the codec master clock
+ - clock-names : The clock should be named "mclk"
+
+ - samsung,i2s-controller : The phandle of the I2S controller
+
+ - samsung,model : The user visible name of this sound
+
+ - samsung,audio-routing : A list of the connections between audio
+   components. each entry is a pair of strings, the first being the
+   connection's sink, the second being the connection's source
+
+Example:
+
+sound {
+	compatible = "samsung,trats2-audio";
+	clocks = <&pmu_system_controller 0>;
+	clock-names = "mclk";
+	samsung,i2s-controller = <&i2s0>;
+	samsung,model = "wm1811";
+	samsung,audio-routing =
+			"SPK", "SPKOUTLN",
+			"SPK", "SPKOUTLP",
+			"SPK", "SPKOUTRN",
+			"SPK", "SPKOUTRP";
+};
-- 
2.0.0.390.gcb682f8

