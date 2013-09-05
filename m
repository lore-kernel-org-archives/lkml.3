Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab3IEEUF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 00:20:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49740 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3IEEUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 00:20:02 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-99-5228066cf5bc
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Milo Kim'" <milo.kim@ti.com>,
        "'Daniel Jeong'" <gshark.jeong@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000701cea9ee$609bfff0$21d3ffd0$%han@samsung.com>
In-reply-to: <000701cea9ee$609bfff0$21d3ffd0$%han@samsung.com>
Subject: [PATCH V2 5/6] backlight: lp8788: Staticize 'default_bl_config'
Date: Thu, 05 Sep 2013 13:19:56 +0900
Message-id: <001201cea9ef$2d671010$88353030$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6p7mBpdyq9ywYnR82rhDmFCL2hBAAALaWw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t8zfd0cNo0ggxPfLS3mrF/DZjF5dxer
	xeWFl4DErjlsFst/rWOx2L3rKasDm8fOWXfZPU7M+M3isWf+D1aPvi2rGD2O39jO5PF5k1wA
	WxSXTUpqTmZZapG+XQJXxuTdM5kKDrNV7Ok6wNzAeIi1i5GTQ0LAROL05lPMELaYxIV769m6
	GLk4hASWMUpcfTOVGaboyZ6dUInpjBJfP21kh3B+MUr8mLoarIpNQE3iy5fDQAkODhEBfYm2
	Fg2QGmaBrYwSmz/uZgWJCwnYSjzeyAtSzilgJ7H0+R0mkLCwgIfE9pN1ICaLgKrEgo1JIBW8
	QMUfph9jhLAFJX5MvscCYjMLaEms33mcCcKWl9i85i0zSKuEgLrEo7+6IGERASOJOd9mMUOU
	iEjse/GOEeKTt+wSW1YXgNgsAgIS3yYfYoFolZXYdADqWUmJgytusExglJiFZPEsJItnIVk8
	C8mGBYwsqxhFUwuSC4qT0otM9IoTc4tL89L1kvNzNzFC4nbCDsZ7B6wPMSYDrZ/ILCWanA+M
	+7ySeENjMyMLUxNTYyNzSzPShJXEedVbrAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MKrP
	8tQQWrhZLvrswSp++YwXz9SFg/ad3atxcMLKD8sPmB3VDZrwP7b6gLXk1WTG/3XnHvvc5g3u
	UV/HYsqjcCOGY8IflqgZjZJBU6zjD+9+IntcYskB0Y0qu17WbY7ebrTlrIv8nP2uASL6ub4C
	LSeOuLfZvWLhTzwzNczg/675waunXxPp0ldiKc5INNRiLipOBAAKh9Dn8QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsVy+t9jQd0cNo0gg8efTS3mrF/DZjF5dxer
	xeWFl4DErjlsFst/rWOx2L3rKasDm8fOWXfZPU7M+M3isWf+D1aPvi2rGD2O39jO5PF5k1wA
	W1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0B1K
	CmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xozJu2cyFRxmq9jTdYC5gfEQ
	axcjJ4eEgInEkz072SBsMYkL99YD2VwcQgLTGSW+ftrIDuH8YpT4MXU1M0gVm4CaxJcvh4ES
	HBwiAvoSbS0aIDXMAlsZJTZ/3M0KEhcSsJV4vJEXpJxTwE5i6fM7TCBhYQEPie0n60BMFgFV
	iQUbk0AqeIGKP0w/xghhC0r8mHyPBcRmFtCSWL/zOBOELS+xec1bZpBWCQF1iUd/dUHCIgJG
	EnO+zWKGKBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeu
	l5yfu4kRnBaeSe9gXNVgcYhRgINRiYe3wVg9SIg1say4MvcQowQHs5IIr8VKoBBvSmJlVWpR
	fnxRaU5q8SHGZKA/JzJLiSbnA1NWXkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNT
	UwtSi2C2MHFwSjUwKv/ZIutS/3Z7UvDTHz92cPcVVEzcuWjNhdz8SQ0Xzp6cwFw45XLNrEDv
	eBZvYdX3KztebBSpajp4ryxm7YS5ZdfkZbI+T2eNWM9jWr4vtu3tY60LOQrdCSeynSZ+OGu/
	4WHbczVO9ox7uxdxHVkRY/EsqoK/p+O9sFH+OS3L3Z5RUx2/igXoKLEUZyQaajEXFScCANDQ
	vuhPAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warning:

drivers/video/backlight/lp8788_bl.c:55:25: warning: symbol 'default_bl_config' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/lp8788_bl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/backlight/lp8788_bl.c b/drivers/video/backlight/lp8788_bl.c
index 980855e..e49905d 100644
--- a/drivers/video/backlight/lp8788_bl.c
+++ b/drivers/video/backlight/lp8788_bl.c
@@ -52,7 +52,7 @@ struct lp8788_bl {
 	struct pwm_device *pwm;
 };
 
-struct lp8788_bl_config default_bl_config = {
+static struct lp8788_bl_config default_bl_config = {
 	.bl_mode    = LP8788_BL_REGISTER_ONLY,
 	.dim_mode   = LP8788_DIM_EXPONENTIAL,
 	.full_scale = LP8788_FULLSCALE_1900uA,
-- 
1.7.10.4


