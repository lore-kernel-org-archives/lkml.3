Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbbASJt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:49:27 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:26637 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbbASJtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:49:22 -0500
X-AuditID: cbfee68e-f79b46d000002b74-01-54bcd2f3e857
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
Subject: [alsa-devel] [PATCH v2 2/3] ASoC: samsung: Document Trats2 audio
 subsystem bindings
Date: Mon, 19 Jan 2015 18:48:21 +0900
Message-id: <1421660902-29679-3-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-reply-to: <1421660902-29679-1-git-send-email-ideal.song@samsung.com>
References: <1421660902-29679-1-git-send-email-ideal.song@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsWyRsSkRPfzpT0hBpO+y1hcuXiIyWLqwyds
	FvOPnGO16H+zkNXiwJ8djBa7/t5ntDj3aiWjRf/j18wW3650MFlsenyN1eLyrjlsFjPO72Oy
	uH2Z12Lp9YtMFhOmr2Wx6NzVz2rRuvcIu8XhN+2sFhdXfGGyeLn5DZODiMeGz01sHmvmrWH0
	aGnuYfO43NfL5LFz1l12j5XLv7B5bFrVyeZx59oeNo/NS+o99r1dxubRt2UVo8fm09UenzfJ
	BfBGcdmkpOZklqUW6dslcGVcXnGQsWArd8Wy9YUNjGc4uxg5OCQETCT29/l2MXICmWISF+6t
	Z+ti5OIQEljKKHGl+S4zRMJE4s+jRYwQiemMEm2zbrJDOHOYJM59egFWxSagIfH982ZmkKki
	AvISh97ngdQwC1xhlvi4YhZYjbBAnMSpfRtYQWwWAVWJ7okLGUFsXgE3iStzf7FAbNOW2Ncw
	kw3E5hRwl2i6cRKsRgio5tzEBWDnSQis5ZDof7iNBWKQgMS3yYdYIN6Rldh0AOpqSYmDK26w
	TGAUXsDIsIpRNLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjMGJP/3vWt4Px5gHrQ4wCHIxKPLwb
	fPeECLEmlhVX5h5iNAXaMJFZSjQ5H5gW8kriDY3NjCxMTUyNjcwtzZTEeROkfgYLCaQnlqRm
	p6YWpBbFF5XmpBYfYmTi4JRqYPReuqlf7NzvqlPHDraYT5B44vZbd/v8xc8fdO3NsA3MEY+V
	frHOxGBDpkbrA+n2Jbm+Stb3VV9v/VaZuO7PsdzZaVszjx1T71sm8rtHrWv6WvVkDo5Tj26s
	K2WQE/Q9btQ7dcKlu1fsHVrDOf057uvIT/5+OzsqsvS5Iof3feZekXtmX20/5CqxFGckGmox
	FxUnAgAmQpsY0wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoO7nS3tCDHo7RCyuXDzEZDH14RM2
	i/lHzrFa9L9ZyGpx4M8ORotdf+8zWpx7tZLRov/xa2aLb1c6mCw2Pb7GanF51xw2ixnn9zFZ
	3L7Ma7H0+kUmiwnT17JYdO7qZ7Vo3XuE3eLwm3ZWi4srvjBZvNz8hslBxGPD5yY2jzXz1jB6
	tDT3sHlc7utl8tg56y67x8rlX9g8Nq3qZPO4c20Pm8fmJfUe+94uY/Po27KK0WPz6WqPz5vk
	AnijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4C+
	VVIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmXF5xkLFgK3fFsvWFDYxn
	OLsYOTkkBEwk/jxaxAhhi0lcuLeerYuRi0NIYDqjRNusm+wQzhwmiXOfXjCDVLEJaEh8/7wZ
	yObgEBGQlzj0Pg+khlngCrPExxWzwGqEBeIkTu3bwApiswioSnRPXAi2gVfATeLK3F8sENu0
	JfY1zGQDsTkF3CWabpwEqxECqjk3cQHbBEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNz
	NzGCE8IzqR2MKxssDjEKcDAq8fByBOwJEWJNLCuuzD3EKMHBrCTCy3gBKMSbklhZlVqUH19U
	mpNafIjRFOiqicxSosn5wGSVVxJvaGxiZmRpZG5oYWRsriTOq2TfFiIkkJ5YkpqdmlqQWgTT
	x8TBKdXAmH5zQ1rvcRP3Zja+4oStxpmRdnH2hXuPzkt69Z5l9TxPM03nOrHYpzLT8l/NZ9b9
	GccbH6Igr/AlbMWfxRPKTqXEFzaXs124eyLw4N3vS6V2/Xmy8/yRQmkWxcKP368k/A32Ydr9
	r/u+SsSWTaVnDtdtkrnTIzXjwc8/LAvMTE+2MN+9/W3NNyWW4oxEQy3mouJEAECK6jAeAwAA
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

