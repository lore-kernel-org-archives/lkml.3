Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbaBFI0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 03:26:38 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:8524 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932130AbaBFI0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 03:26:36 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-7a-52f347336030
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Marek Vasut'" <marex@denx.de>
References: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
In-reply-to: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
Subject: [PATCH 10/12] backlight: lms283gf05: Remove unnecessary OOM messages
Date: Thu, 06 Feb 2014 17:26:26 +0900
Message-id: <000b01cf2315$20cc9ec0$6265dc40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8jE27bRmoXkttyRH6rTI4zkLyyhgAAZMag
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zfV1j989BBp/XslrMWb+GzeLywkus
	Fpd3zWGzeNPWyOjA4jFv1gkWjxMzfrN49G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8aKza1s
	BS/ZKu40L2dqYLzC2sXIySEhYCLxae0bdghbTOLCvfVsXYxcHEICyxglJh9fzAZTdHxBHyNE
	YhGjxIQpR1kgnF+MErNbm1hAqtgE1CS+fDkMNIqDQ0RAX6KtRQMkzCyQKrH76VcmEFtIwFZi
	9+mTYJs5Bewktn1qBYsLC/hKLDx8ghnEZhFQlWia9BJsJC9Q/f3Np6BsQYkfk++xQMzUkli/
	8zgThC0vsXnNW2aQtRIC6hKP/uqChEUEjCSm3nnDClEiIrHvxTuw+yUELrFLbJ3zgw1il4DE
	t8mHWCB6ZSU2HWCG+FdS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiQ73i
	xNzi0rx0veT83E2MkKjs3cF4+4D1IcZkoPUTmaVEk/OBUZ1XEm9obGZkYWpiamxkbmlGmrCS
	OG/Sw6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxL+I5PN3xjvCd58yr9W6et1dfxJrpv
	+hy7eNLn/0wfK1sTuw0LTTddmcLlz3GEV1KbvZPB4BrT+98nMmPrMtbemmXUzrswYofvG63q
	9DKvsO2Vrd97tbR6Q+6mzta8JRDMOONzxBTTifNfiB17/s2jN0S97o7PB4ONbU1cBZ833L4l
	4eK1lUGJpTgj0VCLuag4EQD5dNhf4AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jAV1j989BBr9uMlrMWb+GzeLywkus
	Fpd3zWGzeNPWyOjA4jFv1gkWjxMzfrN49G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWPGis2tbAUv2SruNC9namC8wtrFyMkhIWAicXxBHyOELSZx4d56
	ti5GLg4hgUWMEhOmHGWBcH4xSsxubWIBqWITUJP48uUwexcjB4eIgL5EW4sGSJhZIFVi99Ov
	TCC2kICtxO7TJ8EWcArYSWz71AoWFxbwlVh4+AQziM0ioCrRNOkl2EheoPr7m09B2YISPybf
	Y4GYqSWxfudxJghbXmLzmrfMIGslBNQlHv3VBQmLCBhJTL3zhhWiRERi34t3jBMYhWYhmTQL
	yaRZSCbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwzD+T2sG4ssHiEKMAB6MS
	D++G9Z+ChFgTy4orcw8xSnAwK4nwbjX/HCTEm5JYWZValB9fVJqTWnyIMRno0YnMUqLJ+cB0
	lFcSb2hsYmZkaWRmYWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjBviDdO2C28+
	eOI388O71jtEp32f5hYhYPXc9r2iwDzOpHKtI1UuH2v/PgibUjnR5sds1nWdL4yzdBefMv9d
	GrQsvPfvofTeMAOGfzsqg0OuVC380yqZdSrf+MGei5Mt8pziWxorT1zpkTY/le7y92/met+v
	4kJZn3pf3lkjuXXj+oNlUxkZJimxFGckGmoxFxUnAgAK7PUbPQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The site-specific OOM messages are unnecessary, because they
duplicate the MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lms283gf05.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/video/backlight/lms283gf05.c b/drivers/video/backlight/lms283gf05.c
index de88325..14590c5 100644
--- a/drivers/video/backlight/lms283gf05.c
+++ b/drivers/video/backlight/lms283gf05.c
@@ -168,10 +168,8 @@ static int lms283gf05_probe(struct spi_device *spi)
 
 	st = devm_kzalloc(&spi->dev, sizeof(struct lms283gf05_state),
 				GFP_KERNEL);
-	if (st == NULL) {
-		dev_err(&spi->dev, "No memory for device state\n");
+	if (st == NULL)
 		return -ENOMEM;
-	}
 
 	ld = devm_lcd_device_register(&spi->dev, "lms283gf05", &spi->dev, st,
 					&lms_ops);
-- 
1.7.10.4


