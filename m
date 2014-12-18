Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaLRKxq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 05:53:46 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:26782 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaLRKxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 05:53:38 -0500
X-AuditID: cbfee691-f79b86d000004a5a-d0-5492b22e9d60
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org, lee.jones@linaro.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, ckeepax@opensource.wolfsonmicro.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Inha Song <ideal.song@samsung.com>
Subject: [alsa-devel] [PATCH v2 2/2] mfd: arizona: Update DT binding to support
 OUTn_MONO init_data
Date: Thu, 18 Dec 2014 19:53:16 +0900
Message-id: <1418899996-19744-3-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-reply-to: <1418899996-19744-1-git-send-email-ideal.song@samsung.com>
References: <1418899996-19744-1-git-send-email-ideal.song@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplkeLIzCtJLcpLzFFi42JZI2JSrKu3aVKIwcGNHBZTHz5hs/g35Qa7
	xfwj51gt+t8sZLXY9fc+o8W5VysZLe5/PcpocXnXHDaLpdcvMlksf/ufzWLC9LUsFq17j7Bb
	nO5mdeD1WDNvDaPH5b5eJo+Vy7+weWxa1cnmcefaHjaPeScDPV5O/M3m0bdlFaPH501yAZxR
	XDYpqTmZZalF+nYJXBm9z6azFhzkrth6awlTA+Muzi5GTg4JAROJQ83/WCFsMYkL99azdTFy
	cQgJLGWU2Ny1lg2m6PjXnYwQiUWMEtvX3WKCcOYwSXz40QDWziagIfH982ZmEFtEQEfi88dj
	zCBFzAJ7mCQmLVjNDpIQFkiV+P/rNAuIzSKgKnG3pRnM5hVwk7jftgFqnbbEvoaZYDangLvE
	1K3vwGwhoJprz7axgAyVELjHLrHw3FFWiEECEt8mHwJKcAAlZCU2HWCGmCMpcXDFDZYJjMIL
	GBlWMYqmFiQXFCelF5nqFSfmFpfmpesl5+duYgTG0ul/zybuYLx/wPoQowAHoxIPr4TepBAh
	1sSy4srcQ4ymQBsmMkuJJucDIzavJN7Q2MzIwtTE1NjI3NJMSZxXR/pnsJBAemJJanZqakFq
	UXxRaU5q8SFGJg5OqQbG3gzlMwe5Ji3/xVk6LVy39HtiU9pVEQuDliMK6k1pq+uz+A/f3147
	u1ec0e/G1N85u7cvUlNNWqx1eH3B5vb2Jvv6Pf8LOur3OnNuW6fVp92j9GiaG8uX84wmXvf2
	bYvu5pQ8d/3j86OvArUUb5z98fvwcp9ZZss7qkT+8IpziTw8Osf4VssCJZbijERDLeai4kQA
	YtczBKACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t9jAV29TZNCDNZxW0x9+ITN4t+UG+wW
	84+cY7Xof7OQ1WLX3/uMFuderWS0uP/1KKPF5V1z2CyWXr/IZLH87X82iwnT17JYtO49wm5x
	upvVgddjzbw1jB6X+3qZPFYu/8LmsWlVJ5vHnWt72DzmnQz0eDnxN5tH35ZVjB6fN8kFcEY1
	MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2tpFCW
	mFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYczofTadteAgd8XWW0uYGhh3cXYx
	cnJICJhIHP+6kxHCFpO4cG89WxcjF4eQwCJGie3rbjFBOHOYJD78aGAFqWIT0JD4/nkzM4gt
	IqAj8fnjMWaQImaBPUwSkxasZgdJCAukSvz/dZoFxGYRUJW429IMZvMKuEncb9vABrFOW2Jf
	w0wwm1PAXWLq1ndgthBQzbVn21gmMPIuYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc
	p8+kdjCubLA4xCjAwajEwyuhNylEiDWxrLgy9xCjBAezkghvdA5QiDclsbIqtSg/vqg0J7X4
	EKMp0FUTmaVEk/OBKSSvJN7Q2MTMyNLI3NDCyNhcSZxXyb4tREggPbEkNTs1tSC1CKaPiYNT
	qoHxpKVJcUd7OetxntaFbyyWaCrrMN5N2HQgOf99lv2NcwwvN/EJ1y8/Y8i7VaA1wVUihz9A
	WUD/x9UvDBsXn2O4MjH+2q61f1ekZe0MOFfmHWH+yOCU9+xlG3fP3dGULfFrVZeriVJB1C+/
	N7kv1n2b39j4fo5cU3rhpHY96wNK38zMq+evPrZEiaU4I9FQi7moOBEAkJxWjOkCAAA=
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

