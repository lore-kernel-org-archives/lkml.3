Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbbAWFEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:04:43 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:11979 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbbAWFDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:03:53 -0500
X-AuditID: cbfee68e-f79b46d000002b74-5d-54c1d63155db
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
Subject: [alsa-devel] [PATCH v4 2/3] ASoC: samsung: Document Trats2 audio
 subsystem bindings
Date: Fri, 23 Jan 2015 14:03:29 +0900
Message-id: <1421989410-12490-3-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-reply-to: <1421989410-12490-1-git-send-email-ideal.song@samsung.com>
References: <1421989410-12490-1-git-send-email-ideal.song@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsWyRsSkQNfw2sEQgzOPJSyuXDzEZDH14RM2
	i/lHzrFa9L9ZyGpx4M8ORotdf+8zWpx7tZLRov/xa2aLb1c6mCw2Pb7GanF51xw2ixnn9zFZ
	3L7Ma7H0+kUmiwnT17JYdO7qZ7Vo3XuE3eLwm3ZWi4srvjBZvNz8hslBxGPD5yY2jzXz1jB6
	tDT3sHlc7utl8tg56y67x8rlX9g8Nq3qZPO4c20Pm8fmJfUe+94uY/Po27KK0WPz6WqPz5vk
	AnijuGxSUnMyy1KL9O0SuDIurzjIWLCVu2LZ+sIGxjOcXYycHBICJhI3/h1ghrDFJC7cW8/W
	xcjFISSwlFHi84pFTF2MHGBFkzqMIOLTGSU23bnBDuHMYZKYOGM1G0g3m4CGxPfPm5lBGkQE
	5CUOvc8DqWEWuMIs8XHFLLANwgJxEmdOzGIHsVkEVCW+r9rFCGLzCrhJ/N9ynAXiCm2JfQ0z
	2UDmcAq4S/w+xAsSFgIqOXjzJjPITAmBHRwSj/sg9rIICEh8m3yIBeJQWYlNMM9IShxccYNl
	AqPwAkaGVYyiqQXJBcVJ6UVGesWJucWleel6yfm5mxiB8Xr637O+HYw3D1gfYhTgYFTi4W3c
	cjBEiDWxrLgy9xCjKdCGicxSosn5wKSQVxJvaGxmZGFqYmpsZG5ppiTOmyD1M1hIID2xJDU7
	NbUgtSi+qDQntfgQIxMHp1QD4zKvwywXZP9+46hYERUvnRvcX3XZfNqi5WrSZ35f6GrbmH/B
	rKvc9zWzaPeLnddiYtbmB4WeXvPDVJ/TO+Ja2P83M8+4X9jjsf/F2sh32Uq7pV8sfTU/aOb9
	NSIWKaev/nNVcire5pm9csZauTeXVl3PEL4+J87SJq7j8R0+Z+3wF3uaLohtO6zEUpyRaKjF
	XFScCACbnePl0gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xoK7htYMhBhNP8VlcuXiIyWLqwyds
	FvOPnGO16H+zkNXiwJ8djBa7/t5ntDj3aiWjRf/j18wW3650MFlsenyN1eLyrjlsFjPO72Oy
	uH2Z12Lp9YtMFhOmr2Wx6NzVz2rRuvcIu8XhN+2sFhdXfGGyeLn5DZODiMeGz01sHmvmrWH0
	aGnuYfO43NfL5LFz1l12j5XLv7B5bFrVyeZx59oeNo/NS+o99r1dxubRt2UVo8fm09UenzfJ
	BfBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gB9
	q6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMuLziIGPBVu6KZesLGxjP
	cHYxcnBICJhITOow6mLkBDLFJC7cW8/WxcjFISQwnVFi050b7BDOHCaJiTNWs4FUsQloSHz/
	vJkZpFlEQF7i0Ps8kBpmgSvMEh9XzGIGqREWiJM4c2IWO4jNIqAq8X3VLkYQm1fATeL/luMs
	ENu0JfY1zGQDmcMp4C7x+xAvSFgIqOTgzZvMExh5FzAyrGIUTS1ILihOSs811CtOzC0uzUvX
	S87P3cQITgbPpHYwrmywOMQowMGoxMPbsOVgiBBrYllxZe4hRgkOZiUR3icHgEK8KYmVValF
	+fFFpTmpxYcYTYGOmsgsJZqcD0xUeSXxhsYmZkaWRuaGFkbG5krivEr2bSFCAumJJanZqakF
	qUUwfUwcnFINjCpPRF9uaNvbevay/f2JKnFfpUWc1Z5ZlkZfuXVncoIVN6OJ7lS1wq9njpxX
	iP/2U9rq+w+pOQ8lY9b90n61Trq7q/GBd2+k3TfGqZJHkubmuyYeTdm75Hhk+P6r9z56v274
	nK93b+WNaGND5jdbz71ddWbp8go9g+Vr/VvytS7VzcmLfb0j/6kSS3FGoqEWc1FxIgCQ6eLf
	HAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add Trats2 audio subsystem bindings document.

Signed-off-by: Inha Song <ideal.song@samsung.com>
---
 .../bindings/sound/samsung,trats2-wm1811.txt       | 25 ++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/sound/samsung,trats2-wm1811.txt

diff --git a/Documentation/devicetree/bindings/sound/samsung,trats2-wm1811.txt b/Documentation/devicetree/bindings/sound/samsung,trats2-wm1811.txt
new file mode 100644
index 0000000..319ff07
--- /dev/null
+++ b/Documentation/devicetree/bindings/sound/samsung,trats2-wm1811.txt
@@ -0,0 +1,25 @@
+Samsung Exynos Trats2 audio with WM1811 codec
+
+Required properties:
+
+ - compatible : Must be "samsung,trats2-audio"
+ - samsung,i2s-controller : The phandle of the I2S controller
+ - samsung,model : The user visible name of this sound
+ - samsung,audio-codec : The phandle of the WM1811 audio codec
+ - samsung,audio-routing : A list of the connections between audio
+   components. each entry is a pair of strings, the first being the
+   connection's sink, the second being the connection's source
+
+Example:
+
+sound {
+	compatible = "samsung,trats2-audio";
+	samsung,i2s-controller = <&i2s0>;
+	samsung,model = "Trats2";
+	samsung,audio-codec = <&wm1811>;
+	samsung,audio-routing =
+			"SPK", "SPKOUTLN",
+			"SPK", "SPKOUTLP",
+			"SPK", "SPKOUTRN",
+			"SPK", "SPKOUTRP";
+};
-- 
2.0.0.390.gcb682f8

