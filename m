Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaBGIMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 03:12:13 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17534 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaBGIML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 03:12:11 -0500
X-AuditID: cbfee690-b7f266d00000287c-2d-52f4955a2287
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Barry Song'" <baohua@kernel.org>,
        "'Xianglong Du'" <Xianglong.Du@csr.com>
References: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com>
In-reply-to: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com>
Subject: [PATCH 09/10] rtc: rtc-sirfsoc: Remove unnecessary OOM messages
Date: Fri, 07 Feb 2014 17:12:10 +0900
Message-id: <001201cf23dc$4c8cd8f0$e5a68ad0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8j2qAzLOfgRWJTRVWYElXe2alJBAAAYigw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t8zA92oqV+CDC6fFbRYcvEqu8Wc9WvY
	LJ4c6mW2uLzwEqvF5V1z2Cz2d3YwWqxee43Jgd1j1845rB57Jp5k89i0qpPN48SM3ywefVtW
	MXpMn/eTyePzJrkA9igum5TUnMyy1CJ9uwSujGMrt7IUXGGr2Hl+GmsD407WLkZODgkBE4kt
	v2cyQthiEhfurWfrYuTiEBJYxijx+McFJpiiJ6fOskIkFjFKzP++Ecr5xSixav4adpAqNgE1
	iS9fDgPZHBwiAvoSbS0aIDXMAjcYJebc3wG2TkjAVuLX5yVgNqeAncSiE2fBbGEBD4nNTdOY
	QWwWAVWJY33r2EBsXqD6N13LmCFsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDLJXQkBd4tFf
	XZCwiICRxI4TZ5ghSkQk9r14xwhyj4TAX3aJWRt+s0DsEpD4NvkQC0SvrMSmA8wQD0tKHFxx
	g2UCo8QsJJtnIdk8C8nmWUhWLGBkWcUomlqQXFCclF5kolecmFtcmpeul5yfu4kREtMTdjDe
	O2B9iDEZaP1EZinR5HxgSsgriTc0NjOyMDUxNTYytzQjTVhJnFftUVKQkEB6YklqdmpqQWpR
	fFFpTmrxIUYmDk6pBsa0LKET296+fnO9cHOL0oRqK9650z5v076ZxsG+wFaqR/bAjt2TfipO
	jlx1b0KritmLI6cZtOa9nPWJu2b95gNLJ+VLh70Sn3S0XWRa61bbtK/s871Cc6cv2ZkpsEjo
	6HfD6NsLWwxXy76YcONfjqLRpJYghxWl1ttj/ZalOrlo7F/vwCU+m8VTiaU4I9FQi7moOBEA
	/GB46P8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsVy+t9jAd2oqV+CDHZs4bVYcvEqu8Wc9WvY
	LJ4c6mW2uLzwEqvF5V1z2Cz2d3YwWqxee43Jgd1j1845rB57Jp5k89i0qpPN48SM3ywefVtW
	MXpMn/eTyePzJrkA9qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxU
	WyUXnwBdt8wcoIuUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBnHVm5l
	KbjCVrHz/DTWBsadrF2MnBwSAiYST06dhbLFJC7cW8/WxcjFISSwiFFi/veNrBDOL0aJVfPX
	sINUsQmoSXz5chjI5uAQEdCXaGvRAKlhFrjBKDHn/g6wSUICthK/Pi8BszkF7CQWnYDYICzg
	IbG5aRoziM0ioCpxrG8dG4jNC1T/pmsZM4QtKPFj8j0WEJtZQEti/c7jTBC2vMTmNW+ZQfZK
	CKhLPPqrCxIWETCS2HHiDDNEiYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk
	9FxDveLE3OLSvHS95PzcTYzghPFMagfjygaLQ4wCHIxKPLwnln4OEmJNLCuuzD3EKMHBrCTC
	+7PhS5AQb0piZVVqUX58UWlOavEhxmSgRycyS4km5wOTWV5JvKGxiZmRpZGZhZGJuTlpwkri
	vAdarQOFBNITS1KzU1MLUotgtjBxcEo1MK41To4K2nfXsi7ywonPbv6Ni4VnaSrvXN21N/md
	t82Jv/5ll+PDHu3wnFOZeY+hS9NtY3KlWaabu3n9pm0LjqQ9e5b+ZJXghMVh82KU7jEs/h+f
	4ffH1PexnJ6kw6QTeokfDSZLfe7zOrdsz1XFkvI9rxpFDPUWpywQlgvSMw02ZNNlCMi0V2Ip
	zkg01GIuKk4EAJCHSV5cAwAA
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
 drivers/rtc/rtc-sirfsoc.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-sirfsoc.c b/drivers/rtc/rtc-sirfsoc.c
index 3eb3642..9e3cbce 100644
--- a/drivers/rtc/rtc-sirfsoc.c
+++ b/drivers/rtc/rtc-sirfsoc.c
@@ -264,12 +264,8 @@ static int sirfsoc_rtc_probe(struct platform_device *pdev)
 
 	rtcdrv = devm_kzalloc(&pdev->dev,
 		sizeof(struct sirfsoc_rtc_drv), GFP_KERNEL);
-	if (rtcdrv == NULL) {
-		dev_err(&pdev->dev,
-			"%s: can't alloc mem for drv struct\n",
-			pdev->name);
+	if (rtcdrv == NULL)
 		return -ENOMEM;
-	}
 
 	err = of_property_read_u32(np, "reg", &rtcdrv->rtc_base);
 	if (err) {
-- 
1.7.10.4


