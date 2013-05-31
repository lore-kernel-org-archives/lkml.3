Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab3EaAtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 20:49:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30402 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab3EaAs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 20:48:57 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-7f-51a7f3782d18
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable]   ASoC: wm8994: Fix reporting of accessory removal
 on
Date: Fri, 31 May 2013 09:48:56 +0900
Message-id: <001001ce5d98$a1557eb0$e4007c10$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAMqg8eAAkzGCMAAA5gYwAMf3LxAAABz0QA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zY92Kz8sDDV7cULb4N/sUm8WSZm6L
	y7vmsFks2PiI0YHF4+XE32wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlfFot1LBds6KnTuv
	sTUwPmHvYuTkkBAwkbh0bQWULSZx4d56ti5GLg4hgWWMEmeXLWCBKfp++jM7RGIRo8TDtZNY
	IZy/jBL/vqxlBaliE9CVOLZ+C5gtIuAtcWrKL2YQm1nAT+JT02+gbg6gBm6J1c1BIGFOAR6J
	dX86wUqEBYIlXjUfZwKxWQRUJX6eeQQW5xWwk+g838cIYQtK/Jh8jwVipJbE+p0Q9cwC8hKb
	17xlBhkvIaAu8eivLshpIgJTGCU2XljFCFEjIrHvxTtGkISEwDF2iZlzl0ItE5D4NvkQC0Sz
	rMSmA8wQD0tKHFxxg2UCo8QsJKtnIVk9C8nqWUhWLGBkWcUomlqQXFCclF5kolecmFtcmpeu
	l5yfu4kREokTdjDeO2B9iDEZaP1EZinR5HxgJOeVxBsamxlZmJqYGhuZW5qRJqwkzqveYh0o
	JJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgVGvpuS63E6rnmTl8ypV9wyzFyzfp+yhwGj0OSEs
	Qlbg1ZyPmU1LOsQ4G+Yxn7p+/GjxvKZugVA96cDjR2eGflp1K2LW/9SrC4IY0yKLPthrtujP
	WbdCweLAE/aNAcbca9WOCyo19TOIPvK1tZ2W/aEjR+xi+Id7ltuXHLn05vGFfr/uYIaHfEos
	xRmJhlrMRcWJAKX85N/aAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t9jAd2Kz8sDDX5+l7f4N/sUm8WSZm6L
	y7vmsFks2PiI0YHF4+XE32wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jxaLdSwXbOip07r7E1MD5h72Lk5JAQMJH4fvozlC0mceHeerYuRi4OIYFF
	jBIP105ihXD+Mkr8+7KWFaSKTUBX4tj6LWC2iIC3xKkpv5hBbGYBP4lPTb+BJnEANXBLrG4O
	AglzCvBIrPvTCVYiLBAs8ar5OBOIzSKgKvHzzCOwOK+AnUTn+T5GCFtQ4sfkeywQI7Uk1u+E
	qGcWkJfYvOYtM8h4CQF1iUd/dUFOExGYwiix8cIqRogaEYl9L94xTmAUmoVk1Cwko2YhGTUL
	ScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFx/kx6B+OqBotDjAIcjEo8vAdTlgcK
	sSaWFVfmHmKU4GBWEuHtPAcU4k1JrKxKLcqPLyrNSS0+xJgM9OlEZinR5HxgCsoriTc0NjEz
	sjQyszAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBsZJn9sehO/eHH9mUs/pD1Xv
	Zc0a9tUs3C+T6lkg0M31n2eL6o/nr784m6x0+ivadlbZN+H5lpl9D5a1z+/7evY54ylFfdU5
	NnmSuVz7ntYEp53inma6RuGn25vFNma8640b+KPjEp8qL7hZOOd1ufEpjX5Xvqg/3qt/bPr2
	w+2TUMf1Qv0He44rsRRnJBpqMRcVJwIAawk23jcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Mark Brown <broonie@opensource.wolfsonmicro.com>"

commit 9767a58b8b2a0b153c246fb6306c7d48d51bb379 upstream

During recent refactoring the code to report removal when MICDET reports
an absent microphone was removed, causing problems for systems which rely
solely on the MICDET for this functionality. Restore it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 sound/soc/codecs/wm8994.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/codecs/wm8994.c b/sound/soc/codecs/wm8994.c
index 8b769ba..f9dc7c0 100644
--- a/sound/soc/codecs/wm8994.c
+++ b/sound/soc/codecs/wm8994.c
@@ -3791,6 +3791,11 @@ static irqreturn_t wm8958_mic_irq(int irq, void
*data)
 			dev_dbg(codec->dev, "Ignoring removed jack\n");
 			return IRQ_HANDLED;
 		}
+	} else if (!(reg & WM8958_MICD_STS)) {
+		snd_soc_jack_report(wm8994->micdet[0].jack, 0,
+				    SND_JACK_MECHANICAL | SND_JACK_HEADSET |
+				    wm8994->btn_mask);
+		goto out;
 	}
 
 	if (wm8994->mic_detecting)
-- 
1.7.9.5

