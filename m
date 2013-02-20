Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934993Ab3BTKwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:52:51 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:11678 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933773Ab3BTKwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:52:50 -0500
X-AuditID: cbfee690-b7f066d00000169f-a6-5124ab007a9c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000101ce0e3d$9a9e42a0$cfdac7e0$%han@samsung.com>
In-reply-to: <000101ce0e3d$9a9e42a0$cfdac7e0$%han@samsung.com>
Subject: [PATCH v2] mfd: twl4030-madc: remove erroneous __exit_p() in
 twl4030_madc_driver
Date: Wed, 20 Feb 2013 19:52:48 +0900
Message-id: <000101ce0f58$6c0f3e00$442dba00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4OPZqJHNio5XJvR8u8Q36MxoUVqwBGfMUw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zY12G1SqBBucu6llc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MxnciBZfZKrZcn8TYwHiUtYuRk0NCwETi6LIFTBC2mMSFe+vZ
	uhi5OIQEljFKvNw6mxGm6NiCbSwQiemMEl1LD0FVzWaSWHPiHdgoNgE1iS9fDrOD2CICWhLd
	x84DFXFwMAu4SBydJgISFhKwlZg06wILiM0pYCfx58Y1MFtYIFpi77UbYGNYBFQlTm9sBrN5
	gepPv9nKDmELSvyYfA+snhlo/Pqdx5kgbHmJzWveMoOskhBQl3j0VxfiAiOJ1dsusUKUiEjs
	e/GOEeRkCYF57BKPJh9lh9glIPFt8iEWiF5ZiU0HmCH+lZQ4uOIGywRGiVlINs9CsnkWks2z
	kKxYwMiyilE0tSC5oDgpvchErzgxt7g0L10vOT93EyMkribsYLx3wPoQYzLQ+onMUqLJ+cC4
	zCuJNzQ2NjEzMTUxtzQ1NyVNWEmcV/6STKCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRl67
	O4Gm99+tmVLUPfeChf0C+WU53zuf/cub6f/xU7lrBs+biuj3N7ImfaourS6sPMmdWZ+7tfLD
	0zJno1pZgegnq68n717w5FDwwct/ilOSlwp9ETPWeBpUoiJS9GFf77qm1mtV937G3polID4t
	xHSp4krD2Ts+y5708Fewqbzp67yPyb7FR4mlOCPRUIu5qDgRAOZCvczBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoC7DapVAgzuztS0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jRuM7kYLLbBVbrk9ibGA8
	ytrFyMkhIWAicWzBNhYIW0ziwr31bF2MXBxCAtMZJbqWHoJyZjNJrDnxDqyDTUBN4suXw+wg
	toiAlkT3sfNARRwczAIuEkeniYCEhQRsJSbNugA2lFPATuLPjWtgtrBAtMTeazfAxrAIqEqc
	3tgMZvMC1Z9+s5UdwhaU+DH5Hlg9M9D49TuPM0HY8hKb17xlBlklIaAu8eivLsQFRhKrt11i
	hSgRkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJ
	ERy1z6R2MK5ssDjEKMDBqMTDqzFfOVCINbGsuDL3EKMEB7OSCO/PDpVAId6UxMqq1KL8+KLS
	nNTiQ4zJQI9OZJYSTc4HJpS8knhDYxMzI0sjMwsjE3Nz0oSVxHkZTz0JEBJITyxJzU5NLUgt
	gtnCxMEp1cCoWvJHaZHQtIiqHuOiFzJd2/YKzQ6JPvxV4ytTxcZtTu5Zj/6kfYyc6lH591qe
	za83s0TOLD7NbKG4OWMF46kLZzl0p5dd3efw3vJk8J+FspWFkl9FE4LWP1Ru/+f56qC2TvW/
	aUzL+v+s3Kjw72XX+1uaFlJxHOunPGCvCDO/kS/+V82jSOeWEktxRqKhFnNRcSIAFIfVTh4D	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This __exit_p() causes an build warning as below. Thus, it should
be removed.

drivers/mfd/twl4030-madc.c:788:12: warning: 'twl4030_madc_remove' defined but not used [-Wunused-function]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/twl4030-madc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
index 88ff9dc..942b666 100644
--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -800,7 +800,7 @@ static int twl4030_madc_remove(struct platform_device *pdev)
 
 static struct platform_driver twl4030_madc_driver = {
 	.probe = twl4030_madc_probe,
-	.remove = __exit_p(twl4030_madc_remove),
+	.remove = twl4030_madc_remove,
 	.driver = {
 		   .name = "twl4030_madc",
 		   .owner = THIS_MODULE,
-- 
1.7.2.5


