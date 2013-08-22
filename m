Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab3HVCQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 22:16:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:49745 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3HVCQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 22:16:52 -0400
X-AuditID: cbfee68e-b7f276d000002279-72-521574911860
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002501ce9edd$95cbb740$c16325c0$%han@samsung.com>
In-reply-to: <002501ce9edd$95cbb740$c16325c0$%han@samsung.com>
Subject: [PATCH 2/3] pcmcia: pxa2xx: remove unnecessary platform_set_drvdata()
Date: Thu, 22 Aug 2013 11:16:49 +0900
Message-id: <002601ce9edd$a8a304e0$f9e90ea0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6e3ZW0yWqkn3rITp+VdERxCde4wAAAAV3w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zA92JJaJBBh/2aVrMWb+GzeLywkus
	Fpd3zWGzmNz3i8WBxePEjN8sHpuX1Hv0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxpH3P1gL
	Wtkqeie8Y29g/M/SxcjJISFgIrHxwVl2CFtM4sK99WxdjFwcQgLLGCW27NnEBlN0adpWFojE
	dEaJI5P2sUI4vxglHq74zwpSxSagJvHly2GgURwcIgL6Em0tGiAms0CGxJurqSAVQgK2Ev+v
	HACbySlgJ3Hx4kUwW1jAT2LP2nZmEJtFQFXi3e0TYMfxAtVvP/GJDcIWlPgx+R5YnFlAS2L9
	zuNMELa8xOY1b5lBVkkIqEs8+qsLEhYRMJJYvvAyM0SJiMS+F+8YQS6WEDjHLvFp7XY2iF0C
	Et8mH2KB6JWV2HSAGeJdSYmDK26wTGCUmIVk8ywkm2ch2TwLyYoFjCyrGEVTC5ILipPSi4z0
	ihNzi0vz0vWS83M3MUIism8H480D1ocYk4HWT2SWEk3OB0Z0Xkm8obGZkYWpiamxkbmlGWnC
	SuK8ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYC3+pTd7x0fAI10KPW3sjbmx+9fpT
	Z+LUaQ7troXHr2xb+6trUfGDJV9e/Yx8rHQ0JzGBv+KIgfzTWn3Fy6uVr7gI1qZ/WnYrT/ur
	EO9G/sW7rV7ZxmYVrmL69uuNNjNz3M3p5yQ/LHqp6H5s26XJmj0fj3SFT7v+16lqxUL/O12i
	PY6ZoTa/C5RYijMSDbWYi4oTAcsogOXeAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jQd2JJaJBBqd3qFrMWb+GzeLywkus
	Fpd3zWGzmNz3i8WBxePEjN8sHpuX1Hv0bVnF6PF5k1wAS1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8aR9z9YC1rZKnonvGNvYPzP0sXIySEhYCJxadpWKFtM4sK99Wxd
	jFwcQgLTGSWOTNrHCuH8YpR4uOI/K0gVm4CaxJcvh9m7GDk4RAT0JdpaNEBMZoEMiTdXU0Eq
	hARsJf5fOcAGYnMK2ElcvHgRzBYW8JPYs7adGcRmEVCVeHf7BNheXqD67Sc+sUHYghI/Jt8D
	izMLaEms33mcCcKWl9i85i0zyCoJAXWJR391QcIiAkYSyxdeZoYoEZHY9+Id4wRGoVlIJs1C
	MmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREc78+kdjCubLA4xCjAwajE
	w3thp0iQEGtiWXFl7iFGCQ5mJRFeaS3RICHelMTKqtSi/Pii0pzU4kOMyUCPTmSWEk3OB6ai
	vJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpg1M5iup/E5ZL1
	hK3uRZ0lF+OnOq7e5kfTl0bM3RFfzBl+3mrTArXv1oyJfIvD381vfCGyc+bZ9zrC+xZH8Sh3
	Re64kqGUE3FAKeUVW9OzAjYr9qkMOY5TmDu3bzvWPzHY8+ypxieTJngJ2/lsPpe273zuKUZN
	Kzaz87cvRfQ1i3677Ncdm7NSiaU4I9FQi7moOBEAuJX/iTsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pcmcia/pxa2xx_base.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/pcmcia/pxa2xx_base.c b/drivers/pcmcia/pxa2xx_base.c
index cfec9dd..480c61a 100644
--- a/drivers/pcmcia/pxa2xx_base.c
+++ b/drivers/pcmcia/pxa2xx_base.c
@@ -343,8 +343,6 @@ static int pxa2xx_drv_pcmcia_remove(struct platform_device *dev)
 	struct skt_dev_info *sinfo = platform_get_drvdata(dev);
 	int i;
 
-	platform_set_drvdata(dev, NULL);
-
 	for (i = 0; i < sinfo->nskt; i++)
 		soc_pcmcia_remove_one(&sinfo->skt[i]);
 
-- 
1.7.10.4


