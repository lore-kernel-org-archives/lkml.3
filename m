Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465Ab3GaI60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:58:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28406 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759282Ab3GaI6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:58:20 -0400
X-AuditID: cbfee691-b7fef6d000002d62-18-51f8d1aa1f48
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 3/3] backlight: lp8788: Staticize 'default_bl_config'
Date: Wed, 31 Jul 2013 17:58:18 +0900
Message-id: <002f01ce8dcc$1988e5d0$4c9ab170$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6NzBUqund+adrpRn6MICICBY5QEQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zI91VF38EGixoFreYs34Nm8XlhZdY
	LS7vmsNmsXvXU1YHFo8TM36zeOyZ/4PVo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDIOHnjM
	VnCEreLgqf3sDYyHWbsYOTkkBEwktm/8wA5hi0lcuLeerYuRi0NIYBmjRNeaTmaYokc7l7FD
	JKYzSuy4tY4VwvnFKPHu60ewUWwCahJfvhwGquLgEBHQl2hr0QAJMwsUS8w++4QRxBYWcJXY
	dXAqC4jNIqAqsW/6a0aQcl4BS4mXi6RAwrwCghI/Jt9jgWjVkli/8zgThC0vsXnNW6h7FCR2
	nH0NNlJEQE/ixLSLjBA1IhL7XrxjBDlNQmAbu8Tp5XtZIXYJSHybfIgFZJeEgKzEpgNQcyQl
	Dq64wTKBUWwWktWzkKyehWT1LCQrFjCyrGIUTS1ILihOSi8y1StOzC0uzUvXS87P3cQIibKJ
	OxjvH7A+xJgMtH4is5Rocj4wSvNK4g2NzYwsTE1MjY3MLc1IE1YS51VvsQ4UEkhPLEnNTk0t
	SC2KLyrNSS0+xMjEwSnVwCh67Xm0xVvxfbG9594vd49aOyfJd77EfN4Fx94Vh4tuEQjcZxLz
	sEZx3v3CdZcrtl0/KLTW9M2eiAKDCP93K6Je8H6YL/NvzbFLQht22BTcy7PW0Ii/v/Ofa9X7
	y671Cwyk2F8v1lzMLy85Z+/lf3OO3tjPE1K5pbfs6PTSdMXr68z/zJtf1SOrxFKckWioxVxU
	nAgAr4YYIsgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jQd1VF38EGvxdKWwxZ/0aNovLCy+x
	WlzeNYfNYveup6wOLB4nZvxm8dgz/werR9+WVYwenzfJBbBENTDaZKQmpqQWKaTmJeenZOal
	2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gDtVFIoS8wpBQoFJBYXK+nbYZoQGuKm
	awHTGKHrGxIE12NkgAYS1jFmHDzwmK3gCFvFwVP72RsYD7N2MXJySAiYSDzauYwdwhaTuHBv
	PVsXIxeHkMB0Rokdt9axQji/GCXeff0I1sEmoCbx5cthoA4ODhEBfYm2Fg2QMLNAscTss08Y
	QWxhAVeJXQensoDYLAKqEvumv2YEKecVsJR4uUgKJMwrICjxY/I9FohWLYn1O48zQdjyEpvX
	vGWGuEdBYsfZ12AjRQT0JE5Mu8gIUSMise/FO8YJjAKzkIyahWTULCSjZiFpWcDIsopRNLUg
	uaA4KT3XUK84Mbe4NC9dLzk/dxMjOIafSe1gXNlgcYhRgINRiYfX4cL3QCHWxLLiytxDjBIc
	zEoivPJBPwKFeFMSK6tSi/Lji0pzUosPMSYDPTqRWUo0OR+YXvJK4g2NTcyMLI3MLIxMzM1J
	E1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgVHlmuupKTubd8vYyF3geLRLrzvrYbzi10Wb
	guY+U501w04l0+2ieW3giv+aepMl1CWFhfdfTWUIze2Y3e9XHl/PXqDsxR6Vlt0QUPBwe3/N
	8Qd5qcXbZQRv+J9Zp/+D8cm0JYleBt3nHwdcVTJ8cef27wcJPrF5H3YayikGtNdOvsqQd6I6
	RImlOCPRUIu5qDgRAA5MpRclAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warnings:

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


