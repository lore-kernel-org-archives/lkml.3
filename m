Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab3IXJJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:09:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23290 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3IXJJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:09:51 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-d2-524156deb3ac
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
In-reply-to: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
Subject: [PATCH 07/22] backlight: atmel-pwm-bl: use
 devm_backlight_device_register()
Date: Tue, 24 Sep 2013 18:09:50 +0900
Message-id: <004d01ceb905$d3041c00$790c5400$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65BQPO2UlhwYgjRvaJnkuV9ccl+gAALVxQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zfd37YY5BBtcPMFrMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBmX9qxm
	KZjGW7Gm9RRbA+NU7i5GTg4JAROJI6s6GCFsMYkL99azdTFycQgJLGOUWDDjCDNM0ZWu6cwQ
	iUWMEle3nWCHcH4xStyb0ALWziagJvHly2GgBAeHiIC+RFuLBkiYWSBH4v6TWewgtpCArcS6
	D7PBbE4BO4lTS8+wgZQLC4RJfLroBBJmEVCVuPF8PthEXqDy87OfMUHYghI/Jt9jgRipJbF5
	WxMrhC0vsXnNW2aQMRIC6hKP/uqChEUEjCSu9zQxQ5SISOx78Q7qx0vsEhcmpUKsEpD4NvkQ
	C0SrrMSmA1DfSkocXHGDZQKjxCwki2chWTwLyeJZSDYsYGRZxSiaWpBcUJyUXmSiV5yYW1ya
	l66XnJ+7iRESkRN2MN47YH2IMRlo/URmKdHkfGBE55XEGxqbGVmYmpgaG5lbmpEmrCTOq95i
	HSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBsSrs8kbnu08mSkTprtGuntbhPU/kDItF0AJZ
	IfWmiEcGLQ8WbtQ5d5Hj8Hzu7MPf1p1v+R0i91EjiEX5If8BLZupDefir/Yu+C0Qwi+eZChu
	pTZxwelQRe8Lxfxfb9teXW+78PETa5F9O8/bXtu7LqL71NcuyRtPZNbteqH6XuM/68TqBIUN
	P5VYijMSDbWYi4oTAY4auLTeAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAd17YY5BBifPWlnMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZl/asZimYxluxpvUUWwPjVO4uRk4OCQETiStd05khbDGJC/fW
	s3UxcnEICSxilLi67QQ7hPOLUeLehBZGkCo2ATWJL18OAyU4OEQE9CXaWjRAwswCORL3n8xi
	B7GFBGwl1n2YDWZzCthJnFp6hg2kXFggTOLTRSeQMIuAqsSN5/PBJvIClZ+f/YwJwhaU+DH5
	HgvESC2JzduaWCFseYnNa94yg4yREFCXePRXFyQsImAkcb2niRmiRERi34t3jBMYhWYhmTQL
	yaRZSCbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwxD+T3sG4qsHiEKMAB6MS
	D++FBIcgIdbEsuLK3EOMEhzMSiK8N2wdg4R4UxIrq1KL8uOLSnNSiw8xJgM9OpFZSjQ5H5iM
	8kriDY1NzIwsjcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBkUH9Rd//N0qP
	Lc/zLu8vydi/+3bX72uswZ8fXNW8Fe3R3JE8bWvB4YlKSbxPpVJ8+hb3eWkx8jS5sF2fupkt
	+YTy9Z+i6z7e9N7heCL36+Ful/NH5hx/c+uk97V4uVXb1ml0pYUr71bjUFl7wOpL2IqwzXy+
	y+yuBEpcmLlSYM6UII95E4/tEFNiKc5INNRiLipOBADnESvSPAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/atmel-pwm-bl.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index 8900da7..8993c24 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -171,8 +171,9 @@ static int __init atmel_pwm_bl_probe(struct platform_device *pdev)
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = pdata->pwm_duty_max - pdata->pwm_duty_min;
-	bldev = backlight_device_register("atmel-pwm-bl", &pdev->dev, pwmbl,
-					  &atmel_pwm_bl_ops, &props);
+	bldev = devm_backlight_device_register(&pdev->dev, "atmel-pwm-bl",
+					&pdev->dev, pwmbl, &atmel_pwm_bl_ops,
+					&props);
 	if (IS_ERR(bldev)) {
 		retval = PTR_ERR(bldev);
 		goto err_free_pwm;
@@ -188,14 +189,12 @@ static int __init atmel_pwm_bl_probe(struct platform_device *pdev)
 
 	retval = atmel_pwm_bl_init_pwm(pwmbl);
 	if (retval)
-		goto err_free_bl_dev;
+		goto err_free_pwm;
 
 	atmel_pwm_bl_set_intensity(bldev);
 
 	return 0;
 
-err_free_bl_dev:
-	backlight_device_unregister(bldev);
 err_free_pwm:
 	pwm_channel_free(&pwmbl->pwmc);
 err_free_mem:
@@ -210,7 +209,6 @@ static int __exit atmel_pwm_bl_remove(struct platform_device *pdev)
 		gpio_set_value(pwmbl->gpio_on, 0);
 	pwm_channel_disable(&pwmbl->pwmc);
 	pwm_channel_free(&pwmbl->pwmc);
-	backlight_device_unregister(pwmbl->bldev);
 
 	return 0;
 }
-- 
1.7.10.4


