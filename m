Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab3HVBxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 21:53:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:54950 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab3HVBxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 21:53:05 -0400
X-AuditID: cbfee68f-b7f436d000000f81-c8-52156eff1a58
From: Jingoo Han <jg1.han@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'David Brown'" <davidb@codeaurora.org>,
        "'Stephen Boyd'" <sboyd@codeaurora.org>,
        "'Joerg Roedel'" <joro@8bytes.org>, "'Suman Anna'" <s-anna@ti.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] iommu: remove unnecessary platform_set_drvdata()
Date: Thu, 22 Aug 2013 10:53:01 +0900
Message-id: <001501ce9eda$5660b2c0$03221840$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6e2lWm5ii7kqZjTha1/0gaD8+7ow==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zfd3/eaJBBh0fuC3mrF/DZvF4+T82
	i8sLL7FadM7ewG5xedccNou9v/axWvw4083iwO7x5OA8Jo/Lfb1MHidm/Gbx6NuyitHj+I3t
	TB6fN8kFsEVx2aSk5mSWpRbp2yVwZaybUVYwi7ti2Zu5jA2Mizm7GDk5JARMJF4vW8kIYYtJ
	XLi3nq2LkYtDSGAZo0THz5PMMEWb3k1lhUgsYpQ4fKQZquoXo8SHz9/BqtgE1CS+fDnMDmKL
	COhKrHq+ixmkiFngGqPE37aVLCAJYQFHiacb1jCB2CwCqhJNp84BxTk4eAVsJX7ucQYJ8woI
	SvyYfA+snFlAS2L9zuNMELa8xOY1b5lByiUE1CUe/dWFWKUnMf/EfWaIEhGJfS/eMYKslRC4
	xy5xYs5NRohVAhLfJh9igeiVldh0AOoxSYmDK26wTGAUm4Vk8ywkm2ch2TwLyYoFjCyrGEVT
	C5ILipPSi4z1ihNzi0vz0vWS83M3MULisn8H490D1ocYk4HWT2SWEk3OB8Z1Xkm8obGZkYWp
	iamxkbmlGWnCSuK8ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYpTYlr1rLdNOuZtWe
	BX33otWnMdd8VGt5KlIbuWzPxHPd7NdEpq1u8bmXt+pZtU+pYLxjCr/m5Ntb+Ft3OO47Xhf6
	WF/h75TeVKVHbZKNEmtdzwlenvJLKdo04j3LU/5PvzctFdn10WHrr5rwI3+60uIigzhyDvzk
	L3jgo3h8sfwR7YykBrvnSizFGYmGWsxFxYkAYWER5OECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jAd3/eaJBBn1n2S3mrF/DZvF4+T82
	i8sLL7FadM7ewG5xedccNou9v/axWvw4083iwO7x5OA8Jo/Lfb1MHidm/Gbx6NuyitHj+I3t
	TB6fN8kFsEU1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+ATo
	umXmAB2jpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsY8xYN6OsYBZ3xbI3
	cxkbGBdzdjFyckgImEhsejeVFcIWk7hwbz1bFyMXh5DAIkaJw0eaoZxfjBIfPn9nBqliE1CT
	+PLlMDuILSKgK7Hq+S5mkCJmgWuMEn/bVrKAJIQFHCWebljDBGKzCKhKNJ06BxTn4OAVsJX4
	uccZJMwrICjxY/I9sHJmAS2J9TuPM0HY8hKb17xlBimXEFCXePRXF2KVnsT8E/eZIUpEJPa9
	eMc4gVFgFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBEf9M+kd
	jKsaLA4xCnAwKvHwXtgpEiTEmlhWXJl7iFGCg1lJhFdaSzRIiDclsbIqtSg/vqg0J7X4EGMy
	0J8TmaVEk/OBCSmvJN7Q2MTMyNLIzMLIxNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODil
	Ghj9J15yKN99uXyq8abKcpfPfwLLJ2/ZuN149ewV76aqnH7n8nz1597wx9cvWWq+qvpUYlvl
	UH2963dsqmSiY39y4A8pJ3O2lju771R5607LqdoWG1EdH54XEj/3QhaX3ocfWvw6C09Fpp05
	VN+w4vBDWxYp4bexTLtM96X6aPGHL/L5IG2mv06JpTgj0VCLuag4EQCNbu4ZPgMAAA==
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
 drivers/iommu/msm_iommu_dev.c |    2 --
 drivers/iommu/omap-iommu.c    |    2 --
 2 files changed, 4 deletions(-)

diff --git a/drivers/iommu/msm_iommu_dev.c b/drivers/iommu/msm_iommu_dev.c
index 0a1c962..08ba497 100644
--- a/drivers/iommu/msm_iommu_dev.c
+++ b/drivers/iommu/msm_iommu_dev.c
@@ -282,7 +282,6 @@ static int msm_iommu_remove(struct platform_device *pdev)
 		clk_put(drv->pclk);
 		memset(drv, 0, sizeof(*drv));
 		kfree(drv);
-		platform_set_drvdata(pdev, NULL);
 	}
 	return 0;
 }
@@ -366,7 +365,6 @@ static int msm_iommu_ctx_remove(struct platform_device *pdev)
 	if (drv) {
 		memset(drv, 0, sizeof(struct msm_iommu_ctx_drvdata));
 		kfree(drv);
-		platform_set_drvdata(pdev, NULL);
 	}
 	return 0;
 }
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 0ba3766..bcd78a7 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1008,8 +1008,6 @@ static int omap_iommu_remove(struct platform_device *pdev)
 	struct resource *res;
 	struct omap_iommu *obj = platform_get_drvdata(pdev);
 
-	platform_set_drvdata(pdev, NULL);
-
 	iopgtable_clear_entry_all(obj);
 
 	irq = platform_get_irq(pdev, 0);
-- 
1.7.10.4


