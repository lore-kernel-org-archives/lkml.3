Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaBGICH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 03:02:07 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:14889 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaBGICF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 03:02:05 -0500
X-AuditID: cbfee68e-b7f566d000002344-48-52f492fb708f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Hans-Christian Egtvedt'" <egtvedt@samfundet.no>
References: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com>
In-reply-to: <000901cf23da$a04cbca0$e0e635e0$%han@samsung.com>
Subject: [PATCH 01/10] rtc: rtc-at32ap700x: Remove unnecessary OOM messages
Date: Fri, 07 Feb 2014 17:02:02 +0900
Message-id: <000a01cf23da$e2b2e010$a818a030$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8j2qAzLOfgRWJTRVWYElXe2alJBAAAAwPw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zA93fk74EGfxYzmOx5OJVdos569ew
	WXSve8RucXnhJVaLy7vmsFns7+xgdGDz2DPxJJvHiRm/WTwWnfrM7tG3ZRWjx/R5P5k8Pm+S
	C2CL4rJJSc3JLEst0rdL4MrY3nCOqWApW8Xd9z+YGhinsXYxcnJICJhI3F5wEMoWk7hwbz1b
	FyMXh5DAMkaJPZ332WCKHu74zgqRWMQo8fntHSjnF6NE4499TCBVbAJqEl++HGbvYuTgEBHQ
	l2hr0QCpYRY4wCixZvY3sBohAVuJX5+XgK3jFLCTWHTiLJgtLOAtMePKLTCbRUBV4kLvA7B6
	XqD6K01HGSFsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDLJXQkBd4tFfXZCwiICRxKxt3ewQ
	JSIS+168YwS5R0LgI7vEgunTWSB2CUh8m3yIBaJXVmLTAWaIhyUlDq64wTKBUWIWks2zkGye
	hWTzLCQrFjCyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQIid++HYw3D1gfYkwGWj+RWUo0
	OR8Y/3kl8YbGZkYWpiamxkbmlmakCSuJ8y56mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1Oq
	gXH27R/XT17/sCeyh3VFgfLaW2e3NE2W71Do+8n55eqWla+ipyfG1wi90NiqOGntrs9t/L7m
	a35/+rac+bDd1FN/N1R0O554UpiS6hYZUyL3qOH62XveYW43FopOqkr31Jsj5u4cd/vTs/vn
	apieHt92Mf0Xf9GiAqWvin8uJkdXJNyb03aQ93uCEktxRqKhFnNRcSIAf+vU1vUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jAd3fk74EGXzazWGx5OJVdos569ew
	WXSve8RucXnhJVaLy7vmsFns7+xgdGDz2DPxJJvHiRm/WTwWnfrM7tG3ZRWjx/R5P5k8Pm+S
	C2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6
	Q0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsb3hHFPBUraKu+9/MDUw
	TmPtYuTkkBAwkXi44zuULSZx4d56ti5GLg4hgUWMEp/f3mGFcH4xSjT+2McEUsUmoCbx5cth
	9i5GDg4RAX2JthYNkBpmgQOMEmtmfwOrERKwlfj1eQnYVE4BO4lFJ86C2cIC3hIzrtwCs1kE
	VCUu9D4Aq+cFqr/SdJQRwhaU+DH5HguIzSygJbF+53EmCFteYvOat8wgeyUE1CUe/dUFCYsI
	GEnM2tbNDlEiIrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQv
	XS85P3cTIzg5PJPewbiqweIQowAHoxIP74mln4OEWBPLiitzDzFKcDArifD+bPgSJMSbklhZ
	lVqUH19UmpNafIgxGejRicxSosn5wMSVVxJvaGxiZmRpZGZhZGJuTpqwkjjvwVbrQCGB9MSS
	1OzU1ILUIpgtTBycUg2MM0N6BXT/f5SU95U5fSh4+Q2jaS4vL/T1Pd7rKu1QPD+ztG+q7YSA
	N03P9kcIr7Db93ui9NmP9w5MfGjyge3+Sr8FvDntfyf947L+Yn9727Nmx2gXwWTT3nX7pvtN
	kWyPcQ5Z92J//R6jzcfT2zefvVzLb+9pfVTq9Yw3B+9fvdH5L63TsmqxjBJLcUaioRZzUXEi
	AGkNSUpSAwAA
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
 drivers/rtc/rtc-at32ap700x.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-at32ap700x.c b/drivers/rtc/rtc-at32ap700x.c
index 3161ab5..aee3387 100644
--- a/drivers/rtc/rtc-at32ap700x.c
+++ b/drivers/rtc/rtc-at32ap700x.c
@@ -204,10 +204,8 @@ static int __init at32_rtc_probe(struct platform_device *pdev)
 
 	rtc = devm_kzalloc(&pdev->dev, sizeof(struct rtc_at32ap700x),
 			   GFP_KERNEL);
-	if (!rtc) {
-		dev_dbg(&pdev->dev, "out of memory\n");
+	if (!rtc)
 		return -ENOMEM;
-	}
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!regs) {
-- 
1.7.10.4


