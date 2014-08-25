Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbaHYJ3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 05:29:36 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45073 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbaHYJ3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 05:29:14 -0400
X-AuditID: cbfee691-f79546d0000011a1-d1-53fb01e59968
From: Inha Song <ideal.song@samsung.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org,
        ckeepax@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, cw00.choi@samsung.com,
        Inha Song <ideal.song@samsung.com>
Subject: [alsa-devel] [RESEND PATCH v4 2/2] mfd: arizona: Update DT binding to
 support INn_MODE init_data
Date: Mon, 25 Aug 2014 18:25:40 +0900
Message-id: <1408958740-1037-3-git-send-email-ideal.song@samsung.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
In-reply-to: <1408958740-1037-1-git-send-email-ideal.song@samsung.com>
References: <1408958740-1037-1-git-send-email-ideal.song@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsWyRsSkUPcZ4+9gg3e3mCyuXDzEZDH14RM2
	i39TbrBbXP/ynNVi/pFzrBb9bxayWuz6e5/R4tyrlYwW978eZbS4vGsOm8XS6xeZLJa//c9m
	MWH6WhaL1r1H2C1Od7M68Hts+NzE5rFm3hpGj8t9vUweK5d/YfPYtKqTzePOtT1sHvNOBnq8
	nPibzaNvyypGj8+b5AK4orhsUlJzMstSi/TtErgyluxpZiw4yl2x+84WpgbGw5xdjJwcEgIm
	EsefbWODsMUkLtxbD2RzcQgJLGWUmDp/IRNM0esJC9ghEtMZJT5NPckC4cxhkrj4Ywc7SBWb
	gIbE98+bmUFsEaBRt+d0MoMUMQt0MEtM2baLESQhLJAtsXpbH1gRi4CqxK5vEHFeAVeJzcvf
	M0Os05bY1zAT7CZOATeJPeuPgS0QAqrZsHga1K1f2SU+PTaHmCMg8W3yIaCLOIDishKbDkCN
	kZQ4uOIGywRG4QWMDKsYRVMLkguKk9KLTPWKE3OLS/PS9ZLzczcxAuPs9L9nE3cw3j9gfYhR
	gINRiYd3BeevYCHWxLLiytxDjKZAGyYyS4km5wOjOa8k3tDYzMjC1MTU2Mjc0kxJnFdH+mew
	kEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsaTwT9vZOzxVZKZaz09LLrw/EfPrLN32K63LrK2
	uR247IaWpE6A3JPWnAqrQwsqL1XdYvS5s1ZQ2/J/n5nOs18eMZ1l9iJ1xp17qvYWbhV8tHHH
	xNSOBavXuE499iiFhaMh9YS2WVtcnsRVjqA7/JfvKtz+OY39a5PDjAvTwxVvH1l/S+rm0SVK
	LMUZiYZazEXFiQB/338krgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t9jQd2njL+DDSY3W1hcuXiIyWLqwyds
	Fv+m3GC3uP7lOavF/CPnWC363yxktdj19z6jxblXKxkt7n89ymhxedccNoul1y8yWSx/+5/N
	YsL0tSwWrXuPsFuc7mZ14PfY8LmJzWPNvDWMHpf7epk8Vi7/wuaxaVUnm8eda3vYPOadDPR4
	OfE3m0ffllWMHp83yQVwRTUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl
	5qbaKrn4BOi6ZeYAvaGkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzFiy
	p5mx4Ch3xe47W5gaGA9zdjFyckgImEi8nrCAHcIWk7hwbz1bFyMXh5DAdEaJT1NPskA4c5gk
	Lv7YAVbFJqAh8f3zZmYQWwSo4/acTmaQImaBDmaJKdt2MYIkhAWyJVZv6wMrYhFQldj1DSLO
	K+AqsXn5e2aIddoS+xpmsoHYnAJuEnvWHwNbIARUs2HxNLYJjLwLGBlWMYqmFiQXFCel5xrq
	FSfmFpfmpesl5+duYgTH8TOpHYwrGywOMQpwMCrx8K7k/BUsxJpYVlyZe4hRgoNZSYRX4w9Q
	iDclsbIqtSg/vqg0J7X4EKMp0FUTmaVEk/OBKSavJN7Q2MTMyNLI3NDCyNhcSZz3QKt1oJBA
	emJJanZqakFqEUwfEwenVAPjph8hjIsd6rZ9KbpQd730atnd7OAvcu7OedZW73PKgz2i7Ozi
	ZfU4PaNf//z8g/eN2L1Ysdu8Vbs5ah5ffbbx7fRGR6NfWxuUkrcW7E1XKXHb8eRIvv6/Cer1
	SdwTuusuJe/h1H319NZ+mSl/VplnsC/NF5yVG9V2+6nvhdRdff/fvHUyzvigxFKckWioxVxU
	nAgA3TuHtPkCAAA=
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
Reviewed-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 Documentation/devicetree/bindings/mfd/arizona.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
index 5c7e723..7bd1273 100644
--- a/Documentation/devicetree/bindings/mfd/arizona.txt
+++ b/Documentation/devicetree/bindings/mfd/arizona.txt
@@ -42,6 +42,13 @@ Optional properties:
     the chip default will be used.  If present exactly five values must
     be specified.
 
+  - wlf,inmode : A list of INn_MODE register values, where n is the number
+    of input signals. Valid values are 0 (Differential), 1 (Single-ended) and
+    2 (Digital Microphone). If absent, INn_MODE registers set to 0 by default.
+    If present, values must be specified less than or equal to the number of
+    input singals. If values less than the number of input signals, elements
+    that has not been specifed are set to 0 by default.
+
   - DCVDD-supply, MICVDD-supply : Power supplies, only need to be specified if
     they are being externally supplied. As covered in
     Documentation/devicetree/bindings/regulator/regulator.txt
-- 
2.0.0.390.gcb682f8

