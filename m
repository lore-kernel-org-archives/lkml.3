Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab3CDCzT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 21:55:19 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:51068 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab3CDCzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 21:55:13 -0500
X-AuditID: cbfee68d-b7f636d0000009be-da-51340d0e5298
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] backlight: atmel-pwm-bl: add __init annotation
Date: Mon, 04 Mar 2013 11:55:09 +0900
Message-id: <012b01ce1883$af1d04a0$0d570de0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Yg67BmnAMc5MaQ0Kw1twIywQfVQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zfV0+XpNAg3V9XBZz1q9hs7i88BKr
	xeVdc9gsdu96yurA4nFixm8Wjz3zf7B69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8adZW+Z
	C/6xVTQcWMPewPiftYuRk0NCwETi1a+PjBC2mMSFe+vZuhi5OIQEljFK/Jk3Fa5o7/MvTBCJ
	6YwSM89+ZYdwfjFKvDu+gA2kik1ATeLLl8NACQ4OEQF9ibYWDZAws0CpxNYH71lAwsIC9hLX
	J4MtYxFQlXg0tQHM5hWwlVh06QArhC0o8WPyPRaIVi2J9TuPM0HY8hKb17xlBhkjIaAu8eiv
	LkhYREBPYu+8h6wQJSIS+168YwS5TEJgG7vEi2m72CF2CUh8m3yIBaJXVmLTAWaItyQlDq64
	wTKBUWwWks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSi8y1CtOzC0uzUvXS87P3cQIibHeHYy3
	D1gfYkwGWj+RWUo0OR8Yo3kl8YbGxiZmJqYm5pam5qakCSuJ88pdkgkUEkhPLEnNTk0tSC2K
	LyrNSS0+xMjEwSnVwHhddAurvNmntVd21bZbrJx1NGjuQWWp3hmpBe92Sc6UWhh01bhi8UTz
	pauEbX4cepgiOSHsy9xDp6TuuS/T7Tq0OCKlIWS9axfLW//mi29PfW+5voDr8+QdJbOe/t6W
	/XN90PXdyxy3FXJXdcXZ94onvlbd5M+nYpCxbvK/oGP7lZpPq3U83RStxFKckWioxVxUnAgA
	LZiUFccCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jQV0+XpNAg6t3WC3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMO8veMhf8Y6toOLCGvYHxP2sXIyeHhICJxN7nX5ggbDGJC/fW
	s3UxcnEICUxnlJh59is7hPOLUeLd8QVsIFVsAmoSX74cBkpwcIgI6Eu0tWiAhJkFSiW2PnjP
	AhIWFrCXuD6ZESTMIqAq8WhqA5jNK2ArsejSAVYIW1Dix+R7LBCtWhLrdx5ngrDlJTavecsM
	MkZCQF3i0V9dkLCIgJ7E3nkPWSFKRCT2vXjHOIFRYBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQX
	FCel5xrqFSfmFpfmpesl5+duYgRH8DOpHYwrGywOMQpwMCrx8Ap8Mg4UYk0sK67MPcQowcGs
	JML7DCTEm5JYWZValB9fVJqTWnyIMRno0YnMUqLJ+cDkklcSb2hsYmZkaWRmYWRibk6asJI4
	L+OpJwFCAumJJanZqakFqUUwW5g4OKUaGCcnyx45pJ58aIe5dv+GU/zf6j/c8bwd9M9ZNFbo
	atkUic27Ok/tVt9iu65i2vzmzzVHr93fIsracd2np/uYnnS7nPW08j9NpqX+kcGLdrFm+R6y
	YfFLu6hRz3p9nXncvusMBmv5lJ4eNpz2WSU793GNyk3rQ7Offtqy/K7ZFMfPV7btnWu24I8S
	S3FGoqEWc1FxIgCTQzmOJAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When platform_driver_probe() is used, bind/unbind via sysfs is
disabled. Thus, __init/__exit annotations can be added to
probe()/remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/atmel-pwm-bl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index de5e5e7..9b43663 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -118,7 +118,7 @@ static const struct backlight_ops atmel_pwm_bl_ops = {
 	.update_status  = atmel_pwm_bl_set_intensity,
 };
 
-static int atmel_pwm_bl_probe(struct platform_device *pdev)
+static int __init atmel_pwm_bl_probe(struct platform_device *pdev)
 {
 	struct backlight_properties props;
 	const struct atmel_pwm_bl_platform_data *pdata;
-- 
1.7.2.5


