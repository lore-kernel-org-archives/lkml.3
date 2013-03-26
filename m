Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab3CZHFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 03:05:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:44181 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab3CZHFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 03:05:14 -0400
X-AuditID: cbfee68e-b7f946d000001e37-fd-515148a23b3f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/3] misc: bh1780gli: add CONFIG_PM_SLEEP to suspend/resume
 functions
Date: Tue, 26 Mar 2013 16:05:06 +0900
Message-id: <001e01ce29f0$3eb62f60$bc228e20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4p8D6brC4ZHCKLQ+WHsWIzuH0C8g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zI91FHoGBBgfmiFv8nXSM3aJ58Xo2
	i8sLL7FaXN41h82BxeP3r0mMHvvnrmH36NuyitHj8ya5AJYoLpuU1JzMstQifbsErowXz38y
	FnTyVNxe9Y61gfEnZxcjJ4eEgInEh5+HGCFsMYkL99azdTFycQgJLGOUON58g7mLkQOsaPFC
	d4j4IkaJhns7mSGcX4wS17c8YQPpZhNQk/jy5TA7iC0iYCqx8f0UsKnMAukSd452MoHYwgLh
	EusfrWcGsVkEVCVubf7MCmLzCthKfJ7yBsoWlPgx+R4LRK+WxPqdx5kgbHmJzWveQh2kLvHo
	ry7EKj2Jtj9/WCFKRCT2vXjHCHKbhMA2dol9+9rZIHYJSHybfIgFoldWYtMBZoiHJSUOrrjB
	MoFRbBaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLSK07MLS7NS9dLzs/dxAiJsr4djDcP
	WB9iTAZaP5FZSjQ5HxileSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUX
	leakFh9iZOLglGpgbJN8e1aNb+cxpRk7nzIu8I/PeW83a4F/ivDvf6pR1u9Vlb1vH3/19BqD
	f9jl6EORW/NWP7KWYp2z8e1y9V2LHzIHrszZtObv3tIM253b/7X5SPOlTlO+M3cm76nDs9bb
	REVLXmB8ltPw/lXp9B7+d2U1Rop2/3K2bsq8ZHXyvkvSG+587sTHnEosxRmJhlrMRcWJAINV
	HVPIAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jAd1FHoGBBtemCVv8nXSM3aJ58Xo2
	i8sLL7FaXN41h82BxeP3r0mMHvvnrmH36NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMF89/MhZ08lTcXvWOtYHxJ2cXIweHhICJxOKF7l2MnECmmMSF
	e+vZuhi5OIQEFjFKNNzbyQzh/GKUuL7lCRtIFZuAmsSXL4fZQWwRAVOJje+nMILYzALpEneO
	djKB2MIC4RLrH61nBrFZBFQlbm3+zApi8wrYSnye8gbKFpT4MfkeC0SvlsT6nceZIGx5ic1r
	3jJDHKcu8eivLsQqPYm2P39YIUpEJPa9eMc4gVFgFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcU
	J6XnGuoVJ+YWl+al6yXn525iBMfwM6kdjCsbLA4xCnAwKvHwbggOCBRiTSwrrsw9xCjBwawk
	wvvHMTBQiDclsbIqtSg/vqg0J7X4EGMy0KMTmaVEk/OB6SWvJN7Q2MTMyNLIzMLIxNycNGEl
	cd4DrdaBQgLpiSWp2ampBalFMFuYODilGhgFv3KpB+t42p03c/pyWupF7wbJRR2VLjUL3u6X
	teyfGhXeMytnd/8Gn6Pz3y2NlzCwfWS20//rA7ZPVkXW+2U/pPMnal1gar2lM7E4bt2O5eLn
	zmw3s+9Rv9R0+9/aV3NX79DfvPGxjM/5Kz/Wq7j9toupdkzymPZ2m3ZK5lTJrNQfkdtc1OqV
	WIozEg21mIuKEwEkuQBSJQMAAA==
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

drivers/misc/bh1780gli.c:200:12: warning: 'bh1780_suspend' defined but not used [-Wunused-function]
drivers/misc/bh1780gli.c:222:12: warning: 'bh1780_resume' defined but not used [-Wunused-function]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/misc/bh1780gli.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/bh1780gli.c b/drivers/misc/bh1780gli.c
index cf03d0a..818f3a0 100644
--- a/drivers/misc/bh1780gli.c
+++ b/drivers/misc/bh1780gli.c
@@ -196,7 +196,7 @@ static int bh1780_remove(struct i2c_client *client)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int bh1780_suspend(struct device *dev)
 {
 	struct bh1780_data *ddata;
@@ -235,11 +235,9 @@ static int bh1780_resume(struct device *dev)
 
 	return 0;
 }
+#endif /* CONFIG_PM_SLEEP */
+
 static SIMPLE_DEV_PM_OPS(bh1780_pm, bh1780_suspend, bh1780_resume);
-#define BH1780_PMOPS (&bh1780_pm)
-#else
-#define BH1780_PMOPS NULL
-#endif /* CONFIG_PM */
 
 static const struct i2c_device_id bh1780_id[] = {
 	{ "bh1780", 0 },
@@ -252,7 +250,7 @@ static struct i2c_driver bh1780_driver = {
 	.id_table	= bh1780_id,
 	.driver = {
 		.name = "bh1780",
-		.pm	= BH1780_PMOPS,
+		.pm	= &bh1780_pm,
 	},
 };
 
-- 
1.7.2.5


