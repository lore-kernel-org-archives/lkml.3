Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaHRLAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 07:00:19 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45707 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbaHRLAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 07:00:15 -0400
X-AuditID: cbfee690-b7f526d000003627-7b-53f1dcb9c080
Date: Mon, 18 Aug 2014 20:00:09 +0900
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org
Cc: alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, lee.jones@linaro.org,
        ckeepax@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        sameo@linux.intel.com, devicetree@vger.kernel.org,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        cw00.choi@samsung.com
Subject: [alsa-devel] [PATCH v3 2/2] mfd: arizona: Update DT binding to support
 INn_MODE init_data
Message-id: <20140818200009.12a52dfa@songinha-Samsung-DeskTop-System>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsWyRsSkRHfnnY/BBif6zS2uXDzEZDH14RM2
	i39TbrBbXP/ynNVi/pFzrBb9bxayWpx7tZLR4v7Xo4wW3650MFlc3jWHzWLp9YtMFsvf/mez
	mDB9LYtF694j7Banu1kd+D02fG5i81gzbw2jx+W+XiaPnbPusnusXP6FzWPTqk42jzvX9rB5
	zDsZ6PFy4m82j74tqxg9Pm+SC+CO4rJJSc3JLEst0rdL4Mq4MJG/YBF3xYVJLewNjLM4uxg5
	OSQETCR2H5jODGGLSVy4t56ti5GLQ0hgKaPE9AevmWGKdrw7yASRWMQoMevSA0YIp59J4tjZ
	HUAtHBwsAqoSRy+agTSwCWhIfP+8GaxZBGjq7TmdzCD1zAI/mSSaVzwBSwgLpEg0rHjHBGLz
	CrhK3OxZzwixzUZi9c51zBBxQYkfk++xgNjMAloSm7c1sULY8hKb17yFum4mh8T7uYUgNouA
	gMS3yYdYQO6REJCV2HQAqkRS4uCKGywTGEVmIZk6C8nUWUimLmBkXsUomlqQXFCclF5kolec
	mFtcmpeul5yfu4kRGM2n/z2bsIPx3gHrQ4zJQCsnMkuJJucDk0FeSbyhsZmRhamJqbGRuaUZ
	acJK4rxqj5KChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDO5X9mLufNau7rnvB3CsMZjmtv
	0+fNcOOW9RKQYkhy4dwzP11LxOXaTCeJeXzP7pVMecXyMSX1aeac+n1R58MyK54uS+wtthTd
	8/rVY6cVSbvCnOWuOfRKftW/sVbJe2dB0h4F9xWRj1kV5kQZ7S2oWz/90vn62y7xx3kjjjtN
	cz2zl+lvjKwSS3FGoqEWc1FxIgCcRMiy/AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jAd2ddz4GGzw9r2dx5eIhJoupD5+w
	WfybcoPd4vqX56wW84+cY7Xof7OQ1eLcq5WMFve/HmW0+Halg8ni8q45bBZLr19kslj+9j+b
	xYTpa1ksWvceYbc43c3qwO+x4XMTm8eaeWsYPS739TJ57Jx1l91j5fIvbB6bVnWyedy5tofN
	Y97JQI+XE3+zefRtWcXo8XmTXAB3VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGl
	hbmSQl5ibqqtkotPgK5bZg7QL0oKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBA
	whrGjAsT+QsWcVdcmNTC3sA4i7OLkZNDQsBEYse7g0wQtpjEhXvr2boYuTiEBBYxSsy69IAR
	wulnkjh2dgdQhoODRUBV4uhFM5AGNgENie+fNzOD2CJAzbfndDKD1DML/GSSaF7xBCwhLJAi
	0bDiHdgGXgFXiZs96xkhttlIrN65jhkiLijxY/I9FhCbWUBLYvO2JlYIW15i85q3zBMY+WYh
	KZuFpGwWkrIFjMyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYKTxTPpHYyrGiwOMQpwMCrx
	8Hq8/hAsxJpYVlyZe4hRgoNZSYQ3+/zHYCHelMTKqtSi/Pii0pzU4kOMpkBfT2SWEk3OByay
	vJJ4Q2MTMyNLI3NDCyNjcyVx3oOt1oFCAumJJanZqakFqUUwfUwcnFINjNZbTbnlJv1+J8sd
	uMqu4vaNY9/Z+o6kf3Vs/NUt8zNUV5hfcsuRwL/6sRKf14W7rpl1z6beZE+FgEvecbWCBOav
	/pc85gZufdqib34p8+W6zRV7J6qfePnXYJGz/PK8mDudMc9SNnFXfdIXYF9wtnfP3BvNFzff
	6nBeNHG+8MrU31t9097uzFViKc5INNRiLipOBAC83xbrLAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch update DT binding to support INn_MODE init_data. Each
input signal path can be configurated either as a Analogue or
Digital using the INn_MODE registers.

Signed-off-by: Inha Song <ideal.song@samsung.com>
---
 Documentation/devicetree/bindings/mfd/arizona.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
index 5c7e723..0064b21 100644
--- a/Documentation/devicetree/bindings/mfd/arizona.txt
+++ b/Documentation/devicetree/bindings/mfd/arizona.txt
@@ -42,6 +42,14 @@ Optional properties:
     the chip default will be used.  If present exactly five values must
     be specified.
 
+  - wlf,inmode : A list of INn_MODE register values, where n is the number
+    of input signals. Each input signal path can be configurated either as a
+    Analogue or Digital using the INn_MODE registers. If absent, INn_MODE
+    registers set to 0 by default. If present, values must be specified less
+    than or equal to the number of input singals. If values less than the
+    number of input signals, elements that has not been specifed are set to 0
+    by default.
+
   - DCVDD-supply, MICVDD-supply : Power supplies, only need to be specified if
     they are being externally supplied. As covered in
     Documentation/devicetree/bindings/regulator/regulator.txt
-- 
2.0.0.390.gcb682f8

