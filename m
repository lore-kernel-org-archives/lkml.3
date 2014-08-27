Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567AbaH0BNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 21:13:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8608 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542AbaH0BNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 21:13:51 -0400
X-AuditID: cbfee690-f79ce6d00000115a-9f-53fd30ce0ef5
From: Jingoo Han <jg1.han@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "'Bryan Wu'" <cooloney@gmail.com>, "'Lee Jones'" <lee.jones@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
In-reply-to: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
Subject: [PATCH V2 14/18] backlight: tdo24m: add blank line after declarations
Date: Wed, 27 Aug 2014 10:13:49 +0900
Message-id: <005201cfc194$28c196d0$7a44c470$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/Bk2mhX0elbPeNSwiBLjt5Esz7eAAALSpg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zY91zBn+DDeZt5LU4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDJuf2cp
	uMlW8eHOUvYGxqOsXYycHBICJhKzZz2HssUkLtxbzwZiCwksY5Ro2qIFU9PyZjpUfBGjxOot
	KV2MXED2b0aJ38++gSXYBNQkvnw5zA5iiwgoSGzufQY2lFkgV+L3zJWMEM22EpcXrmUCsTkF
	7CRmf5gOVM/BISzgJ/H+pxNImEVAVWLyp/lgJbxA5YdX7maGsAUlfky+xwIxUkti/c7jTBC2
	vMTmNW+ZQcZICKhLPPqrC3GBkcSEb9ugSkQk9r14xwjxyjF2ib1frSBWCUh8m3yIBaJVVmLT
	AWaIEkmJgytusExglJiFZPEsJItnIVk8C8mGBYwsqxhFUwuSC4qT0otM9IoTc4tL89L1kvNz
	NzFConHCDsZ7B6wPMQpwMCrx8H5Y8CdYiDWxrLgy9xCjKdBFE5mlRJPzgTGfVxJvaGxmZGFq
	YmpsZG5ppiTO+1rqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRuGsBfcXV1w2jPONE3gq
	2hCbkTOLa3v1y9+LpMJdjEP3rth035Pl37RzYrLHr9xot3leb39yuvTMnLNMt06fFJZ5fYUx
	v2b103JbOc1Cm13VEWtV7Bbk6rHf/hWZ9CxQ/InIpNWdS845rJu+4VzRmZ9M+5j2Lfddt2HB
	H/a5Jp83/xHqkvuuUKzEUpyRaKjFXFScCAD2dv20wQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jAd1zBn+DDX5N5rI4unMik8XlhZdY
	Le5/PcpocXnXHDYHFo+ds+6ye9y5tofNo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B2KimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJ6xgzbn9nKbjJVvHhzlL2BsajrF2MnBwSAiYSLW+ms0HYYhIX7q0H
	s4UEFjFKrN6S0sXIBWT/ZpT4/ewbWIJNQE3iy5fD7CC2iICCxObeZ2CDmAVyJX7PXMkI0Wwr
	cXnhWiYQm1PATmL2h+lA9RwcwgJ+Eu9/OoGEWQRUJSZ/mg9WwgtUfnjlbmYIW1Dix+R7LBAj
	tSTW7zzOBGHLS2xe85YZZIyEgLrEo7+6EBcYSUz4tg2qRERi34t3jBMYhWYhmTQLyaRZSCbN
	QtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwvD+T3sG4qsHiEKMAB6MSD++HBX+C
	hVgTy4orcw8xSnAwK4nwJiv8DRbiTUmsrEotyo8vKs1JLT7EaAr06ERmKdHkfGAqyiuJNzQ2
	MTOyNDKzMDIxN1cS5z3Yah0oJJCeWJKanZpakFoE08fEwSnVwBhy6OFN14COrMKVsyd0fFzs
	GD895l9V7o7HuZ+2O7ws42+dfSL6qbDfHRNVu7JTzF5d5o2Hqy5bPNEJ/btyBrd286rF38sn
	nP/naZzEMu/ust/NReG7DC9uPHn488biwvuXvhx82hx1u0zJ+bXO6lkfHD9uD3A7nXzp2M15
	sRvbMhdfzjgk/X21EktxRqKhFnNRcSIArPEBlg0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following checkpatch warning.

  WARNING: Missing a blank line after declarations

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/video/backlight/tdo24m.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/backlight/tdo24m.c b/drivers/video/backlight/tdo24m.c
index 908016fc5829..30afce33ef2a 100644
--- a/drivers/video/backlight/tdo24m.c
+++ b/drivers/video/backlight/tdo24m.c
@@ -300,12 +300,14 @@ static int tdo24m_power(struct tdo24m *lcd, int power)
 static int tdo24m_set_power(struct lcd_device *ld, int power)
 {
 	struct tdo24m *lcd = lcd_get_data(ld);
+
 	return tdo24m_power(lcd, power);
 }
 
 static int tdo24m_get_power(struct lcd_device *ld)
 {
 	struct tdo24m *lcd = lcd_get_data(ld);
+
 	return lcd->power;
 }
 
-- 
2.0.0


