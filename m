Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab3CMAvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 20:51:53 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32048 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755282Ab3CMAvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 20:51:52 -0400
X-AuditID: cbfee68d-b7f786d000005188-ad-513fcda64e67
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003d01ce1ee5$316a57c0$943f0740$%han@samsung.com>
In-reply-to: <003d01ce1ee5$316a57c0$943f0740$%han@samsung.com>
Subject: [PATCH] backlight: da903x_bl: use BL_CORE_SUSPENDRESUME option
Date: Wed, 13 Mar 2013 09:51:50 +0900
Message-id: <00b401ce1f84$f25c6a50$d7153ef0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4e5TFGbi0DDqigSHaFNclqJo2Q/AAnyy7w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zQ91lZ+0DDfbcU7S4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ13t72Ar2CVTMXLCarYHxOW8XIyeHhICJRMuf6UwQtpjEhXvr
	2UBsIYFljBItK/xgarrOTmTtYuQCii9ilNh8ZhsThDObSeLkrxcsIFVsAmoSX74cZu9i5OAQ
	EdCXaGvRAKlhFpjPKHFm/wUmiKm2Ev8nPWUCqeEUsJOYt0gAJCws4C4xZdZNZhCbRUBV4veD
	i4wgNi9Q+fsXe1khbEGJH5Pvga1iFtCSWL/zOBOELS+xec1bZpCREgLqEo/+6oKERQSMJF63
	XYMqF5HY9+IdI8g5EgKr2CWeNM+F2iUg8W3yIRaIXlmJTQeYIf6VlDi44gbLBEaJWUg2z0Ky
	eRaSzbOQrFjAyLKKUTS1ILmgOCm9yFCvODG3uDQvXS85P3cTIySuencw3j5gfYgxGWj9RGYp
	0eR8YFzmlcQbGpsZWZiamBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNT
	qoFxSnt3crW747PCuOKnLU6ruJkDduvd3TinNX1Te8Zeu0vfeG9NcTK8JXxVeTfH++WP4gps
	NE87P7jdsfP5Iaa4xJj557/NXHlC+WVou3eq7eSwOq9fS2bHzrxxe3Hgkxd1fyvSAxxU+Jv1
	xfg3KxsmvZtzeWnX/6mb28zmT6yIdxbb8y5GvctViaU4I9FQi7moOBEAejXIhMECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgO6ys/aBBjt+SFtc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjOu9PWwF+wQqZi5YzdbA
	+Jy3i5GTQ0LARKLr7ERWCFtM4sK99WxdjFwcQgKLGCU2n9nGBOHMZpI4+esFC0gVm4CaxJcv
	h9m7GDk4RAT0JdpaNEBqmAXmM0qc2X+BCaRGSMBW4v+kp0wgNZwCdhLzFgmAhIUF3CWmzLrJ
	DGKzCKhK/H5wkRHE5gUqf/9iLyuELSjxY/I9sFXMAloS63ceZ4Kw5SU2r3nLDDJSQkBd4tFf
	XZCwiICRxOu2a1DlIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNz
	i0vz0vWS83M3MYLj9pn0DsZVDRaHGAU4GJV4eCXS7AOFWBPLiitzDzFKcDArifBqbwAK8aYk
	VlalFuXHF5XmpBYfYkwGenQis5Rocj4wpeSVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9
	sSQ1OzW1ILUIZgsTB6dUA6PSozVXXymr7/ospH32xafqo5/VZfgjZRd8qn4z8Sx36ptAj5uV
	T5VOhC/QlLwffvjY2of/1KbkSC7k8OPd5cqk3rdjqZHjSQb1D4d8vnAGsG9b/MM21Gink9qp
	KRuVIjaVLym+9Zc1paevp/PCtvNhDs/zK07dP33Fx0tNt9BXpfXJ3HmMjq5KLMUZiYZazEXF
	iQAKw/1YHwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use BL_CORE_SUSPENDRESUME option to support suspend/resume.
It reduces code size.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/video/backlight/da903x_bl.c |   30 +++++-------------------------
 1 files changed, 5 insertions(+), 25 deletions(-)

diff --git a/drivers/video/backlight/da903x_bl.c b/drivers/video/backlight/da903x_bl.c
index 8179cef..67cadd3 100644
--- a/drivers/video/backlight/da903x_bl.c
+++ b/drivers/video/backlight/da903x_bl.c
@@ -88,16 +88,21 @@ static int da903x_backlight_update_status(struct backlight_device *bl)
 	if (bl->props.fb_blank != FB_BLANK_UNBLANK)
 		brightness = 0;
 
+	if (bl->props.state & BL_CORE_SUSPENDED)
+		brightness = 0;
+
 	return da903x_backlight_set(bl, brightness);
 }
 
 static int da903x_backlight_get_brightness(struct backlight_device *bl)
 {
 	struct da903x_backlight_data *data = bl_get_data(bl);
+
 	return data->current_brightness;
 }
 
 static const struct backlight_ops da903x_backlight_ops = {
+	.options	= BL_CORE_SUSPENDRESUME,
 	.update_status	= da903x_backlight_update_status,
 	.get_brightness	= da903x_backlight_get_brightness,
 };
@@ -161,35 +166,10 @@ static int da903x_backlight_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int da903x_backlight_suspend(struct device *dev)
-{
-	struct backlight_device *bl = dev_get_drvdata(dev);
-
-	return da903x_backlight_set(bl, 0);
-}
-
-static int da903x_backlight_resume(struct device *dev)
-{
-	struct backlight_device *bl = dev_get_drvdata(dev);
-
-	backlight_update_status(bl);
-	return 0;
-}
-
-static const struct dev_pm_ops da903x_backlight_pm_ops = {
-	.suspend	= da903x_backlight_suspend,
-	.resume		= da903x_backlight_resume,
-};
-#endif
-
 static struct platform_driver da903x_backlight_driver = {
 	.driver		= {
 		.name	= "da903x-backlight",
 		.owner	= THIS_MODULE,
-#ifdef CONFIG_PM
-		.pm	= &da903x_backlight_pm_ops,
-#endif
 	},
 	.probe		= da903x_backlight_probe,
 	.remove		= da903x_backlight_remove,
-- 
1.7.2.5


