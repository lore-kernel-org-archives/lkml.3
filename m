Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbaLHJVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:21:18 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:21518 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbaLHJVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:21:15 -0500
X-AuditID: cbfee691-f79b86d000004a5a-5a-54856d89d244
From: Inha Song <ideal.song@samsung.com>
To: lee.jones@linaro.org, broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, ckeepax@opensource.wolonmicro.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Inha Song <ideal.song@samsung.com>
Subject: [alsa-devel][PATCH 2/2] mfd: arizona: Update DT binding to support
 OUTn_MONO init_data
Date: Mon, 08 Dec 2014 18:20:22 +0900
Message-id: <1418030422-27061-3-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-reply-to: <1418030422-27061-1-git-send-email-ideal.song@samsung.com>
References: <1418030422-27061-1-git-send-email-ideal.song@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjkeLIzCtJLcpLzFFi42JZI2JSqNuZ2xpisP6KmsXUh0/YLP7sO85o
	Mf/IOVaL/jcLWS12/b3PaHHu1UpGi/tfjzJaXN41h81i6fWLTBbL3/5ns5gwfS2LReveI+wW
	p7tZHXg91sxbw+hxua+XyWPl8i9sHptWdbJ53Lm2h81j3slAj5cTfwOF9vxm9ujbsorR4/Mm
	uQCuKC6blNSczLLUIn27BK6M3mfTWQsOcldsvbWEqYFxF2cXIyeHhICJxOF9r9kgbDGJC/fW
	g9lCAksZJT6s9ICp2TprJStEfBGjxLIDFl2MXED2HCaJpd33wBJsAhoS3z9vZu5i5OAQEdCR
	uH4jHaSGWWAXk8Tm93eYQWqEBRIlDtx/zwJSwyKgKtH/JBYkzCvgJjFz9nEmiF3aEvsaZoLd
	wCngLnFkyVMWiL1uEueuNbGAzJQQeMsusWbJPbAGFgEBiW+TD4HNlBCQldh0gBlijqTEwRU3
	WCYwCi9gZFjFKJpakFxQnJReZKpXnJhbXJqXrpecn7uJERhNp/89m7iD8f4B60OMAhyMSjy8
	Cx60hAixJpYVV+YeYjQF2jCRWUo0OR8Ys3kl8YbGZkYWpiamxkbmlmZK4rw60j+DhQTSE0tS
	s1NTC1KL4otKc1KLDzEycXBKNTBeNhRtn7Nl24d9H+7fDV7sZu8f3/OYQ91p6XJuF690hoBt
	3lKz0wUsWmYG+2e+alh16tKcpgsdGy9/XPTK5+TRun+75nztWteczV71eNrDN3dbWf/GCmX/
	EYqKOaQjGnCCs0579r7nkm3bs1nqy+6e/OcRlT3PUWKWh1WQRFhjz8UtKgXbp39QYinOSDTU
	Yi4qTgQAypO3F6ECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t9jAd3O3NYQg5vv5CymPnzCZvFn33FG
	i/lHzrFa9L9ZyGqx6+99Rotzr1YyWtz/epTR4vKuOWwWS69fZLJY/vY/m8WE6WtZLFr3HmG3
	ON3N6sDrsWbeGkaPy329TB4rl39h89i0qpPN4861PWwe804Geryc+BsotOc3s0ffllWMHp83
	yQVwRTUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA
	Ha+kUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzOh9Np214CB3xdZbS5ga
	GHdxdjFyckgImEhsnbWSFcIWk7hwbz0biC0ksIhRYtkBiy5GLiB7DpPE0u57YEVsAhoS3z9v
	Zu5i5OAQEdCRuH4jHaSGWWAXk8Tm93eYQWqEBRIlDtx/zwJSwyKgKtH/JBYkzCvgJjFz9nEm
	iF3aEvsaZoLt4hRwlziy5CkLxF43iXPXmlgmMPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66X
	nJ+7iREcrc+kdzCuarA4xCjAwajEw7vwQUuIEGtiWXFl7iFGCQ5mJRHexLjWECHelMTKqtSi
	/Pii0pzU4kOMpkBHTWSWEk3OByaSvJJ4Q2MTMyNLI3NDCyNjcyVx3hs3c0OEBNITS1KzU1ML
	Uotg+pg4OKUaGPPLrzxpn56zJ/3l7UYFIVaNJxcrMpfK1+94NJN1o6X8KdczU96euLhpU9zL
	urWvYz3f/MzZLrKOdQqf6s5Pr86tP5Ytt22WrHqQd1zclECb9+5zZVKFXlYFO17bVbqvInXL
	8vvG2Yx8pTPnXK7kFD2d3vlYInppo4K71qOjgeJnWm0vtUmnMCmxFGckGmoxFxUnAgCc2Lh0
	7AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch update DT binding to support OUTn_MONO init_data. Each
output signal can be configurated as a mono differential output.
The mono differential configuration is selected using the OUTn_MONO
registers.

Signed-off-by: Inha Song <ideal.song@samsung.com>
---
 Documentation/devicetree/bindings/mfd/arizona.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
index 7bd1273..cf11d42 100644
--- a/Documentation/devicetree/bindings/mfd/arizona.txt
+++ b/Documentation/devicetree/bindings/mfd/arizona.txt
@@ -49,6 +49,13 @@ Optional properties:
     input singals. If values less than the number of input signals, elements
     that has not been specifed are set to 0 by default.
 
+  - wlf,out-mono : A list of OUTn_MONO register values, where n is the number
+    of output signals. Valid values are 0 (Disabled) and 1 (Enabled). If absent,
+    OUTn_MONO registers set to 0 by default. If present, values must be specified
+    less than or equal to the number of output signals. If values less than the
+    number of input signals, elements that has not been specified are set to 0
+    by default.
+
   - DCVDD-supply, MICVDD-supply : Power supplies, only need to be specified if
     they are being externally supplied. As covered in
     Documentation/devicetree/bindings/regulator/regulator.txt
-- 
2.0.0.390.gcb682f8

