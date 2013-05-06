Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab3EFDyv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 23:54:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:27941 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab3EFDyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 23:54:50 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-01-5187298889f0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vinod Koul'" <vinod.koul@intel.com>
Cc: "'Dan Williams'" <djbw@fb.com>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 2/2] dma: timb_dma: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 12:54:48 +0900
Message-id: <002801ce4a0d$744ff330$5cefd990$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KDVULz6onkEBwTQ2mYtvuFG3rqQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zI90OzfZAgy2PTSxe/5vOYrG5/wGb
	xeWFl1gtLu+aw2bxsm8/iwOrx8Tmd+wei/e8ZPL4+PQWi0ffllWMHp83yQWwRnHZpKTmZJal
	FunbJXBl/Fi8h63gFFvFxcNrWBoY97F2MXJySAiYSDy58gvKFpO4cG89WxcjF4eQwDJGic77
	cxhhippuzmQGsYUEFjFKfF4QClH0i1FizfTZTCAJNgE1iS9fDrN3MXJwiAioSyy9LgNSwyzQ
	wyjx/dEzsBphAV+JX4+fgtksAqoSDVvaWEBsXgFLidWn1zFB2IISPybfA4szC2hJrN95nAnC
	lpfYvOYtM8RBChI7zr4GO05EQE/i9NxGqHoRiX0v3jGCLJYQOMQu8XLnUTaIZQIS3yYfYgE5
	TkJAVmLTAag5khIHV9xgmcAoNgvJ6llIVs9CsnoWkhULGFlWMYqmFiQXFCelFxnpFSfmFpfm
	pesl5+duYoTEXt8OxpsHrA8xJgOtn8gsJZqcD4zdvJJ4Q2MzIwtTE1NjI3NLM9KElcR51Vqs
	A4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw6v46uZNN5PtqhVWfPKYkSk9S+vtoecvhKcv7
	fO0SLrzRn7/Qkl8u6+YzByv72eJSs2Zv7E1kj8hxy5l0Sak+bNfZlHyOo7qebE13vh84yBuh
	67JlU3c3i0JtkOq982mhK9kMGPQ7PEqXf6jJ1UpgFi7VjPea+YHrLGdMnc3Zq38OHeb+NGG2
	EktxRqKhFnNRcSIAPND+XtMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd0OzfZAg92thhav/01nsdjc/4DN
	4vLCS6wWl3fNYbN42befxYHVY2LzO3aPxXteMnl8fHqLxaNvyypGj8+b5AJYoxoYbTJSE1NS
	ixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOAtisplCXmlAKFAhKL
	i5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM34s3sNWcIqt4uLhNSwNjPtYuxg5OSQETCSa
	bs5khrDFJC7cW88GYgsJLGKU+LwgtIuRC8j+xSixZvpsJpAEm4CaxJcvh9m7GDk4RATUJZZe
	lwGpYRboYZT4/ugZWI2wgK/Er8dPwWwWAVWJhi1tLCA2r4ClxOrT65ggbEGJH5PvgcWZBbQk
	1u88zgRhy0tsXvMW6iAFiR1nXzOC2CICehKn5zZC1YtI7HvxjnECo8AsJKNmIRk1C8moWUha
	FjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjuxn0jsYVzVYHGIU4GBU4uEteNIWKMSa
	WFZcmXuIUYKDWUmE12cvUIg3JbGyKrUoP76oNCe1+BBjMtCnE5mlRJPzgUknryTe0NjEzMjS
	yMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYS1fuk/r/icFx54SDq0ovSTIs
	mXrg25Rz99r+Vt2fFDLB/2OQrUUdux7ntvbZEzhzFny/yzznrXr1Nt89zgnukTp67Q37632n
	pvafn674aZvKXuEYDUtH4w+cp/Ic9R22O/2f80fxhX4JD/+05rSyQ/3Gk9tro5bEi73gyzhl
	dW/l/09N81g2KbEUZyQaajEXFScCAK0gD14wAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound).
Thus, it is not needed to manually clear the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/dma/timb_dma.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 26107ba..0ef43c1 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -811,8 +811,6 @@ static int td_remove(struct platform_device *pdev)
 	kfree(td);
 	release_mem_region(iomem->start, resource_size(iomem));
 
-	platform_set_drvdata(pdev, NULL);
-
 	dev_dbg(&pdev->dev, "Removed...\n");
 	return 0;
 }
-- 
1.7.2.5


