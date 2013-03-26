Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568Ab3CZGvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 02:51:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56544 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868Ab3CZGvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 02:51:36 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-d8-515145774597
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] mg_disk: add CONFIG_PM_SLEEP to suspend/resume functions
Date: Tue, 26 Mar 2013 15:51:35 +0900
Message-id: <000e01ce29ee$5b8c9c20$12a5d460$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4p7ltpKcAnWemdQhKkcqAtTuZu3Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t8zA91y18BAg0WzDS3mrF/DZnF54SVW
	i8u75rA5MHucmPGbxaNvyypGj8+b5AKYo7hsUlJzMstSi/TtErgyWn5PYCz4w1FxauUe5gbG
	fexdjJwcEgImEn0v9zBD2GISF+6tZ+ti5OIQEljGKHHj61amLkYOsKItv1Qg4osYJT5/uMUE
	4fxilOh/s5gNpJtNQE3iy5fD7CANIgL6Em0tGiAms4CLxNFpIiAVwgKeEqcWHwTbyyKgKvGs
	/SALiM0rYCsx9cdHZghbUOLH5HtgcWYBLYn1O48zQdjyEpvXvGWGOEdd4tFfXZCwiICexLc/
	h9ggSkQk9r14xwhymYTAMnaJpv2fmSF2CUh8m3yIBaJXVmLTAah3JSUOrrjBMoFRbBaSzbOQ
	bJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAiJpok7GO8fsD7EmAy0fiKz
	lGhyPjAa80riDY3NjCxMTUyNjcwtzUgTVhLnVW+xDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTB
	KdXAyP8gd57JxXfX8is6wyVfCuiKx/vFTolcfitw5aQfFr8Cb6qaLbu8lWn9ZY+ZzvZ3D02f
	8KTuVlpf+6PTvIH3WsUcA1zdj2qEWPz99mGKWUxYwYSAmIdv3A2NLz8zmjllvb8mZ/k5jab7
	/49X+aY2ivc8quvnqfCb0ujUGdEgOO26+/6Ko+urlFiKMxINtZiLihMBoJ/ztbwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+xgG65a2Cgwa/1uhZz1q9hs7i88BKr
	xeVdc9gcmD1OzPjN4tG3ZRWjx+dNcgHMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaG
	uoaWFuZKCnmJuam2Si4+AbpumTlAm5QUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUY
	GaCBhHWMGS2/JzAW/OGoOLVyD3MD4z72LkYODgkBE4ktv1S6GDmBTDGJC/fWs3UxcnEICSxi
	lPj84RYThPOLUaL/zWI2kCo2ATWJL18OgzWLCOhLtLVogJjMAi4SR6eJgFQIC3hKnFp8kB3E
	ZhFQlXjWfpAFxOYVsJWY+uMjM4QtKPFj8j2wOLOAlsT6nceZIGx5ic1r3jJDnKYu8eivLkhY
	REBP4tufQ2wQJSIS+168Y5zAKDALyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL
	89L1kvNzNzGCY/WZ1A7GlQ0WhxgFOBiVeHg3BAcECrEmlhVX5h5ilOBgVhLh/eMYGCjEm5JY
	WZValB9fVJqTWnyIMRno0YnMUqLJ+cA0klcSb2hsYmZkaWRmYWRibk6asJI474FW60AhgfTE
	ktTs1NSC1CKYLUwcnFLAeOOYPrsu99akUoFD6dHB/jGta155pj7i5zzNflXfaDN3hmnKRvVV
	hnMdeyZp6SmVbKk5OWXBwi+yFw62+21u+XykuP7nj9acufUfU1dmR6WxJzmrbzl0+K0R4/Wn
	8/eVh+7p+ltryb3dM3neuqmzVJ6esfkXOcuUxcxiwvOcsgULpzIXTa3JVGIpzkg01GIuKk4E
	AHBSgvMZAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CONFIG_PM_SLEEP to suspend/resume functions to fix the following
build warning when CONFIG_PM_SLEEP is not selected. This is because
sleep PM callbacks defined by SIMPLE_DEV_PM_OPS are only used when
the CONFIG_PM_SLEEP is enabled.

drivers/block/mg_disk.c:783:12: warning: 'mg_suspend' defined but not used [-Wunused-function]
drivers/block/mg_disk.c:807:12: warning: 'mg_resume' defined but not used [-Wunused-function]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/block/mg_disk.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index 1788f491..532bb89 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -780,6 +780,7 @@ static const struct block_device_operations mg_disk_ops = {
 	.getgeo = mg_getgeo
 };
 
+#ifdef CONFIG_PM_SLEEP
 static int mg_suspend(struct device *dev)
 {
 	struct mg_drv_data *prv_data = dev->platform_data;
@@ -824,6 +825,7 @@ static int mg_resume(struct device *dev)
 
 	return 0;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(mg_pm, mg_suspend, mg_resume);
 
-- 
1.7.2.5


