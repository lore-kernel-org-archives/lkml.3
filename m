Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab3CFFhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:37:14 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26466 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab3CFFhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:37:11 -0500
X-AuditID: cbfee68d-b7f636d0000009be-83-5136d606282e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 30/30] rtc: rtc-wm831x: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:37:10 +0900
Message-id: <006001ce1a2c$a5bb1eb0$f1315c10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAAWEAw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zfV22a2aBBvNXy1lc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Muz9mMBW8Ya/4db+HsYHxMFsXIyeHhICJxOc531kgbDGJC/fW
	A8W5OIQEljFK7H96iAmm6OvsxcwQiUWMEhdPdbBAOLOZJJq7zoJVsQmoSXz5cpi9i5GDQ0RA
	X6KtRQOkhlmgl1HiTO9udpAaIQFbiavdq5hBbE4BO4nlj2eBrRYWcJM4c/IJM0gvi4CqxLRp
	SiAmL1D5vsXOIBW8AoISPybfA6tmFtCSWL/zOBOELS+xec1bsE4JAXWJR391QcIiAkYSrUdf
	skOUiEjse/GOEeQaCYFl7BIfluwBm8MiICDxbfIhFoheWYlNB5gh3pWUOLjiBssERolZSDbP
	QrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3IUK84Mbe4NC9dLzk/dxMjJK56dzDePmB9iDEZaP1E
	ZinR5HxgXOaVxBsaG5uYmZiamFuampuSJqwkzit3SSZQSCA9sSQ1OzW1ILUovqg0J7X4ECMT
	B6dUAyPH8uXpS9tPsYfPuPJuXY7WdrdJu4v8E7br8F4WjL/wt47hbF1uDa/QyrOuuyLuvJRa
	n2XVcu+YbvMLC+ef3otS470bN1xZPe9cnE2euvK9BWcvTGl7HX+w8DrH1MgiPqllCb9eXfp5
	v7XoPHedIxvPLY//7pd3R1e8cPGQ/iehdCX6fp9LroASS3FGoqEWc1FxIgCju2p4wQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgC7bNbNAg9dXpCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxt0fM5gK3rBX/Lrfw9jA
	eJiti5GTQ0LAROLr7MXMELaYxIV764HiXBxCAosYJS6e6mCBcGYzSTR3nWUCqWITUJP48uUw
	excjB4eIgL5EW4sGSA2zQC+jxJne3ewgNUICthJXu1eBTeUUsJNY/ngWC4gtLOAmcebkE2aQ
	XhYBVYlp05RATF6g8n2LnUEqeAUEJX5MvgdWzSygJbF+53EmCFteYvOat2CdEgLqEo/+6oKE
	RQSMJFqPvmSHKBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtc
	mpeul5yfu4kRHLXPpHcwrmqwOMQowMGoxMM7QcUsUIg1say4MvcQowQHs5IIL9cZoBBvSmJl
	VWpRfnxRaU5q8SHGZKA3JzJLiSbnAxNKXkm8obGJmZGlkZmFkYm5OWnCSuK8jKeeBAgJpCeW
	pGanphakFsFsYeLglGpgdOZTSD9k/IN3/8aVFu1Jb0635M7/Kq1394O+dHuGDPukpamd9hOW
	hi2QE5dVOO8raMm/u9S+Wvklu/kly4CpVtJhYe21k88+YBYU5OtZM/nupe1apmrvWvSW7brU
	8eX7z0clW46/X7/0765TahJ3JvIGTmw8Emvdwna11OJtC3vMuglBua98lFiKMxINtZiLihMB
	AZyxaB4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-wm831x.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-wm831x.c b/drivers/rtc/rtc-wm831x.c
index 2f0ac7b..3f863bd 100644
--- a/drivers/rtc/rtc-wm831x.c
+++ b/drivers/rtc/rtc-wm831x.c
@@ -436,7 +436,7 @@ static int wm831x_rtc_probe(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	wm831x_rtc->rtc = rtc_device_register("wm831x", &pdev->dev,
+	wm831x_rtc->rtc = devm_rtc_device_register("wm831x", &pdev->dev,
 					      &wm831x_rtc_ops, THIS_MODULE);
 	if (IS_ERR(wm831x_rtc->rtc)) {
 		ret = PTR_ERR(wm831x_rtc->rtc);
@@ -462,10 +462,6 @@ err:
 
 static int wm831x_rtc_remove(struct platform_device *pdev)
 {
-	struct wm831x_rtc *wm831x_rtc = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(wm831x_rtc->rtc);
-
 	return 0;
 }
 
-- 
1.7.2.5


