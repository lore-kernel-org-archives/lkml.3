Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab3IKCXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:23:44 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:27466 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab3IKCXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:23:43 -0400
X-AuditID: cbfee68e-b7f756d000004512-d8-522fd42d2dfd
From: Jingoo Han <jg1.han@samsung.com>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>
Cc: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Anish Kumar'" <anish198519851985@gmail.com>,
        "'Lars-Peter Clausen'" <lars@metafoo.de>
References: <003e01ceae95$9a708ab0$cf51a010$%han@samsung.com>
In-reply-to: <003e01ceae95$9a708ab0$cf51a010$%han@samsung.com>
Subject: [PATCH 1/3] extcon: adc-jack: use dev_get_platdata()
Date: Wed, 11 Sep 2013 11:23:41 +0900
Message-id: <003f01ceae95$ee5151f0$caf3f5d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6ulZa6uUhwZIzATbuZxRtBD2SFVwAAAo0Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zQ13dK/pBBrcOWFpcvtHFbHH9y3NW
	i8sLL7FaLJk8H8jaNYfN4nbjCjYHNo+ds+6yeyx5c4jVo2/LKkaPz5vkAliiuGxSUnMyy1KL
	9O0SuDLWHxYrWM5e8W/aLMYGxulsXYycHBICJhLHD0xlhrDFJC7cWw8U5+IQEljGKHFx5yp2
	mKK3066zQCSmM0o8u70fyvnFKLHz8XMWkCo2ATWJL18Og3WICGhJTOycyQRSxCxwilHiws2V
	jCAJIQFbiZZ9H4D2cXBwCthJNN82AQkLA4X/NS9iArFZBFQl+ratA5vDCxT/2LUFyhaU+DH5
	HtguZqD563ceZ4Kw5SU2r3kLNlJCQF3i0V9diBOMJNben8MOUSIise/FO0aQcyQErrFLzH6z
	CWqXgMS3yYdYIHplJTYdgIaEpMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZVjKKpBckFxUnp
	RUZ6xYm5xaV56XrJ+bmbGCGR2reD8eYB60OMyUDrJzJLiSbnAyM9ryTe0NjMyMLUxNTYyNzS
	jDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M0aYXdl4UsGfh+SIQKmOon8kT
	yRz2ebfsqY1ZTP5Ck2IPKyoleC7z1JM+lyB0s3zTJOfTHq0cC/w5n9623Psl/ier2r+1/9dr
	bdWY/4//upipNX/VvsmrQ3wPFgfm+3zcIHg/YCqzVXD7soYtHwz3srkvneJ6aA9PzQHrgEWn
	r2Vdl57P1JmkxFKckWioxVxUnAgAtNzp/+oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQV3dK/pBBtNfm1pcvtHFbHH9y3NW
	i8sLL7FaLJk8H8jaNYfN4nbjCjYHNo+ds+6yeyx5c4jVo2/LKkaPz5vkAliiGhhtMlITU1KL
	FFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4C2KymUJeaUAoUCEouL
	lfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz1h8WK1jOXvFv2izGBsbpbF2MnBwSAiYSb6dd
	Z4GwxSQu3FsPFOfiEBKYzijx7PZ+FgjnF6PEzsfPwarYBNQkvnw5zA5iiwhoSUzsnMkEUsQs
	cIpR4sLNlYwgCSEBW4mWfR+Yuxg5ODgF7CSab5uAhIWBwv+aFzGB2CwCqhJ929aBzeEFin/s
	2gJlC0r8mHwPbBcz0Pz1O48zQdjyEpvXvAUbKSGgLvHory7ECUYSa+/PYYcoEZHY9+Id4wRG
	oVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGcBp5J72Bc1WBx
	iFGAg1GJh/eGnH6QEGtiWXFl7iFGCQ5mJRHeqU5AId6UxMqq1KL8+KLSnNTiQ4zJQI9OZJYS
	Tc4Hpqi8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamCc+PLW
	nmzX/c/58i4lC3q/N+jMelnQ7STHOKtON1I3IedAdrDSg5fZjdPnOC6p0Lm0ZHPPq37R+7/+
	/Sm8qhHYv+lU8LFJ2/TPiHr98Lt6J7383OULd4M4ln+7JX/U1M7rQtiDknvyVVU1q2s/aHfL
	Pfj9UfKClvzC/ekC11nrS66dENrkys2qxFKckWioxVxUnAgA0ccadUcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/extcon/extcon-adc-jack.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
index 5985807..c0e0e20 100644
--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -95,7 +95,7 @@ static irqreturn_t adc_jack_irq_thread(int irq, void *_data)
 static int adc_jack_probe(struct platform_device *pdev)
 {
 	struct adc_jack_data *data;
-	struct adc_jack_pdata *pdata = pdev->dev.platform_data;
+	struct adc_jack_pdata *pdata = dev_get_platdata(&pdev->dev);
 	int i, err = 0;
 
 	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
-- 
1.7.10.4


