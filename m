Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756643Ab3LTMLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:11:47 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:30114 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab3LTMLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:11:44 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-76-52b433ea670f
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-pm@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, rui.zhang@intel.com, eduardo.valentin@ti.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        amit.daniel@samsung.com, kgene.kim@samsung.com,
        devicetree@vger.kernel.org, b.zolnierkie@samsung.com, cpgs@samsung.com,
        t.figa@samsung.com
Subject: [PATCH] thermal:samsung: fix compilation warning
Date: Fri, 20 Dec 2013 17:42:07 +0530
Message-id: <1387541527-4762-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWyRsSkWveV8ZYgg3ePZSwaroZYbJyxntXi
	5SFNi/lHzrFarNn/k8mid8FVNovLu+awWXzuPcJoMeP8PiaLRdv+M1s8edjHZrF+xmsWBx6P
	nbPusnss3vOSyaNvyypGj+M3tjN5fN4kF8AaxWWTkpqTWZZapG+XwJWxafNkxoJfHBW/d15k
	bGC8y97FyMkhIWAicf/bMShbTOLCvfVsXYxcHEICSxkllrY2s8IU7T/3mwUisYhRYtG3Z1BO
	D5PEt87dbCBVbAJmEgcXrQYbJSIgIzH1yn5WkCJmgflMEof+rAVLCAtYSsxYf40ZxGYRUJV4
	ehtkEicHr4CLRO+zvUwQ6xQlup9NALtDQmAZu8TNKU9ZIRoEJL5NPgTUwAGUkJXYdIAZol5S
	4uCKGywTGAUXMDKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAgM9NP/nvXuYLx9wPoQYzLQ
	uInMUqLJ+cBIySuJNzQ2M7IwNTE1NjK3NCNNWEmcN+lhUpCQQHpiSWp2ampBalF8UWlOavEh
	RiYOTqkGxk1M0/PfHOdgeb/OZs70b05aHVufeG2Wdss59mJmUpxpzO5lV40tfv+aHrpIvFTS
	YYebs+XKLV7PKu4sfd7I/P6BKtOyJqeZR/jvPX34bvtNjUev52TI24U4rpktfld03VqVt+Hb
	BaZxT5HaNPVJ8owtT1k+VzPmc3xJ/5Yx886Tp9E/nh6f86FPiaU4I9FQi7moOBEAScc5HIoC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jAd1XxluCDHquC1k0XA2x2DhjPavF
	y0OaFvOPnGO1WLP/J5NF74KrbBaXd81hs/jce4TRYsb5fUwWi7b9Z7Z48rCPzWL9jNcsDjwe
	O2fdZfdYvOclk0ffllWMHsdvbGfy+LxJLoA1qoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7U
	zMBQ19DSwlxJIS8xN9VWycUnQNctMwfoPCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFB
	cD1GBmggYQ1jxqbNkxkLfnFU/N55kbGB8S57FyMnh4SAicT+c79ZIGwxiQv31rN1MXJxCAks
	YpRY9O0ZC4TTwyTxrXM3G0gVm4CZxMFFq8G6RQRkJKZe2c8KUsQsMJ9J4tCftWAJYQFLiRnr
	rzGD2CwCqhJPbz8DW8Er4CLR+2wvE8Q6RYnuZxPYJjByL2BkWMUomlqQXFCclJ5rqFecmFtc
	mpeul5yfu4kRHEfPpHYwrmywOMQowMGoxMPbYLs5SIg1say4MvcQowQHs5IIb7/2liAh3pTE
	yqrUovz4otKc1OJDjMlA2ycyS4km5wNjPK8k3tDYxNzU2NTSxMLEzJI0YSVx3gOt1oFCAumJ
	JanZqakFqUUwW5g4OKUaGA9NKHPWCOBN3Rkuf0nevV9gzd7ltl3zJy6ZuEpV2ZDhd52PxyJd
	n1nXtjxSVjP+/nHNygmmj6WtE6/NUw5rmGw2644na/BdywhPXcGC0GidsB2XtxZZ/ja8cuaT
	o0HxZclA+/pjPzT5vOtfS6YvypoY9MB8fsj3f/7n77jYLplTUnvhRf+a9UosxRmJhlrMRcWJ
	AICXaLznAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a compilation warning.

warning: passing argument 5 of 'thermal_zone_device_register' discards 'const'
qualifier from pointer target type [enabled by default]
include/linux/thermal.h:270:29: note: expected 'struct thermal_zone_device_ops *'
but argument is of type 'const struct thermal_zone_device_ops *'

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 drivers/thermal/samsung/exynos_thermal_common.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/samsung/exynos_thermal_common.c b/drivers/thermal/samsung/exynos_thermal_common.c
index c2301da..3f5ad25 100644
--- a/drivers/thermal/samsung/exynos_thermal_common.c
+++ b/drivers/thermal/samsung/exynos_thermal_common.c
@@ -280,7 +280,7 @@ static int exynos_get_trend(struct thermal_zone_device *thermal,
 	return 0;
 }
 /* Operation callback functions for thermal zone */
-static struct thermal_zone_device_ops const exynos_dev_ops = {
+static struct thermal_zone_device_ops exynos_dev_ops = {
 	.bind = exynos_bind,
 	.unbind = exynos_unbind,
 	.get_temp = exynos_get_temp,
-- 
1.7.10.4

