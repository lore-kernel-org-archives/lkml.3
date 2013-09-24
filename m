Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab3IXJOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:14:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28690 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab3IXJOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:14:22 -0400
X-AuditID: cbfee68e-b7f756d000004512-47-524157ed6fca
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
In-reply-to: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
Subject: [PATCH 11/22] backlight: ep93xx: use devm_backlight_device_register()
Date: Tue, 24 Sep 2013 18:14:21 +0900
Message-id: <005101ceb906$74484a00$5cd8de00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65BQPO2UlhwYgjRvaJnkuV9ccl+gAAVpsg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zfd234Y5BBn97pS3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsErowrXSfY
	C5p5Kpbvm8DWwNjO1cXIySEhYCKxef19ZghbTOLCvfVsXYxcHEICyxglbm26xgRT9ObSMlaI
	xHRGiU3zljBDOL8YJU7dm84OUsUmoCbx5cthIJuDQ0RAX6KtRQMkzCyQI3H/ySywEiEBW4l1
	H2aD2ZwCdhKnlp5hA7GFBfwkem73g8VZBFQlrv59xgpi8wLVXz56kwXCFpT4MfkeC8RMLYnN
	25pYIWx5ic1r3jKDrJUQUJd49FcXJCwiYCTx/tMbNogSEYl9L94xgpwsIXCOXeLKkwYWiF0C
	Et8mH2KB6JWV2HQAGhCSEgdX3GCZwCgxC8nmWUg2z0KyeRaSFQsYWVYxiqYWJBcUJ6UXGekV
	J+YWl+al6yXn525ihERl3w7GmwesDzEmA62fyCwlmpwPjOq8knhDYzMjC1MTU2Mjc0sz0oSV
	xHnVWqwDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDardncs/LY3Hsfz19paJ4UKPHJMDv/
	+cKFk4uuG3ap2HGWGyc9qb5dnaZ+/1UCT/PMWSbpNuXven+yvl0hwJZz1lnq7S9frpsT/mTe
	N+34Vlwl/0Alm01z9/sblTz75pdPtwtSay+6bLZ+Yt+RaXnblyXJr8k9pLfmbZ+sUNnqqoiL
	SppVH+4osRRnJBpqMRcVJwIA56JGV+ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQd234Y5BBvuniVvMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZV7pOsBc081Qs3zeBrYGxnauLkZNDQsBE4s2lZawQtpjEhXvr
	2boYuTiEBKYzSmyat4QZwvnFKHHq3nR2kCo2ATWJL18OA9kcHCIC+hJtLRogYWaBHIn7T2aB
	lQgJ2Eqs+zAbzOYUsJM4tfQMG4gtLOAn0XO7HyzOIqAqcfXvM7DFvED1l4/eZIGwBSV+TL7H
	AjFTS2LztiZWCFteYvOat8wgayUE1CUe/dUFCYsIGEm8//SGDaJERGLfi3eMExiFZiGZNAvJ
	pFlIJs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnDMP5PewbiqweIQowAHoxIP
	74UEhyAh1sSy4srcQ4wSHMxKIrw3bB2DhHhTEiurUovy44tKc1KLDzEmAz06kVlKNDkfmI7y
	SuINjU3MjCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoGx8LHZAuuzbaVi
	x5LuyfydYTjDaIWt5VmvGDdmsffzbcxOL3MP7Hy+i8XFal1393Opnw6CXVvei6ws2T9p2ae1
	zzsmf3lcxRU9gXGxmp8e91xBT+M09r6mS8seSwm3X3/NcEI2aLP2HPdMt/X/X+zc+ODxlEP3
	i1tb3bJ/H31VuSk04kOKbG2rEktxRqKhFnNRcSIAhhrtoD0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ep93xx_bl.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/video/backlight/ep93xx_bl.c b/drivers/video/backlight/ep93xx_bl.c
index 018368b..0d1f633 100644
--- a/drivers/video/backlight/ep93xx_bl.c
+++ b/drivers/video/backlight/ep93xx_bl.c
@@ -92,8 +92,8 @@ static int ep93xxbl_probe(struct platform_device *dev)
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = EP93XX_MAX_BRIGHT;
-	bl = backlight_device_register(dev->name, &dev->dev, ep93xxbl,
-				       &ep93xxbl_ops, &props);
+	bl = devm_backlight_device_register(&dev->dev, dev->name, &dev->dev,
+					ep93xxbl, &ep93xxbl_ops, &props);
 	if (IS_ERR(bl))
 		return PTR_ERR(bl);
 
@@ -106,14 +106,6 @@ static int ep93xxbl_probe(struct platform_device *dev)
 	return 0;
 }
 
-static int ep93xxbl_remove(struct platform_device *dev)
-{
-	struct backlight_device *bl = platform_get_drvdata(dev);
-
-	backlight_device_unregister(bl);
-	return 0;
-}
-
 #ifdef CONFIG_PM_SLEEP
 static int ep93xxbl_suspend(struct device *dev)
 {
@@ -140,7 +132,6 @@ static struct platform_driver ep93xxbl_driver = {
 		.pm	= &ep93xxbl_pm_ops,
 	},
 	.probe		= ep93xxbl_probe,
-	.remove		= ep93xxbl_remove,
 };
 
 module_platform_driver(ep93xxbl_driver);
-- 
1.7.10.4


