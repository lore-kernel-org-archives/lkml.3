Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965571AbaH1JFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 05:05:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:11784 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936337AbaH1JCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 05:02:46 -0400
X-AuditID: cbfee68f-f797f6d000001173-5b-53fef0320af5
From: Chanwoo Choi <cw00.choi@samsung.com>
To: a.zummo@towertech.it
Cc: kgene.kim@samsung.com, akpm@linux-foundation.org,
        kyungmin.park@samsung.com, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCHv3 2/5] rtc: s3c: Remove warning message when checking coding
 style with checkpatch script
Date: Thu, 28 Aug 2014 18:02:36 +0900
Message-id: <1409216559-22402-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1409216559-22402-1-git-send-email-cw00.choi@samsung.com>
References: <1409216559-22402-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWyRsSkQNf4w79gg0MGFksuXmW3mLN+DZvF
	9S/PWS16F1xlszjb9Ibd4vKuOWwWM87vY7LY39nB6MDhsWfiSTaPEzN+s3j0bVnF6DF93k8m
	j8+b5AJYo7hsUlJzMstSi/TtErgy9qzfz1TwWK3ixqd5rA2MP+S7GDk5JARMJH6snM8MYYtJ
	XLi3nq2LkYtDSGApo8SK9t3MMEV/zzSyQiSmM0o0Nz9mhnCamCTWHJrIClLFJqAlsf/FDTYQ
	W0RAQmLJnDuMIDazwA1GiRfbYkBsYYFsiUkX/7KD2CwCqhJnXlwCs3kFXCV+PHjDBrFNTuLD
	nkdAcQ4OTgE3iYdrq0DCQkAl33+eYgTZKyGwiF3i5kaIs1kEBCS+TT7EAlIvISArsekA1NGS
	EgdX3GCZwCi8gJFhFaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZguJ/+96x/B+PdA9aHGAU4
	GJV4eB3i/gULsSaWFVfmHmI0BdowkVlKNDkfGFV5JfGGxmZGFqYmpsZG5pZmSuK8C6V+BgsJ
	pCeWpGanphakFsUXleakFh9iZOLglGpgZOYzCfwQs/zCx015R3Psm1XWi/TWZNxbWbA+8Mek
	9O1pvKXphesf3vmxJlcue/q1/Yefr5hl+UbsTdnfNF1R1ebtOb8v31858/K+H8wnWwyf9zOr
	fN1z+aL7vGW2G1nZ7XPbtfkXLd8zf1PEXk2ZpTM23JppcDAwreTtssu7ZNcKT5x0Vayod7cS
	S3FGoqEWc1FxIgDH72KUcgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t9jQV2jD/+CDfZdMLVYcvEqu8Wc9WvY
	LK5/ec5q0bvgKpvF2aY37BaXd81hs5hxfh+Txf7ODkYHDo89E0+yeZyY8ZvFo2/LKkaP6fN+
	Mnl83iQXwBrVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg
	65aZA3SMkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwhjFjz/r9TAWP1Spu
	fJrH2sD4Q76LkZNDQsBE4u+ZRlYIW0ziwr31bF2MXBxCAtMZJZqbHzNDOE1MEmsOTQSrYhPQ
	ktj/4gYbiC0iICGxZM4dRhCbWeAGo8SLbTEgtrBAtsSki3/ZQWwWAVWJMy8ugdm8Aq4SPx68
	YYPYJifxYc8joDgHB6eAm8TDtVUgYSGgku8/TzFOYORdwMiwilE0tSC5oDgpPddIrzgxt7g0
	L10vOT93EyM4np5J72Bc1WBxiFGAg1GJh9ch7l+wEGtiWXFl7iFGCQ5mJRHeo8eBQrwpiZVV
	qUX58UWlOanFhxhNgY6ayCwlmpwPjPW8knhDYxMzI0sjc0MLI2NzJXHeg63WgUIC6Yklqdmp
	qQWpRTB9TBycUg2MLC9N3q6OnFJtvvSj4f2j/Sv+m6wu71T8pvtrt9d3C7u3HpyhSz0L2Pxm
	LAi8UN3x6vZSPiE/G/VZIa+u196tvPu37vfUPYVT/Ra0qpkvWnsoIMn2d47hk+klco1h6Y0b
	q+JWTzkitjl9xi7ZctGaafX/Wnz/lV0/s+3Z9bbgnV+fqmWntK/MU2Ipzkg01GIuKk4EAI68
	mNu9AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch remove warning message when checking codeing style with checkpatch
script and reduce un-necessary i2c read operation on s3c_rtc_enable.

	WARNING: line over 80 characters
	#406: FILE: drivers/rtc/rtc-s3c.c:406:
	+		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_RTCEN) == 0) {

	WARNING: line over 80 characters
	#414: FILE: drivers/rtc/rtc-s3c.c:414:
	+		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_CNTSEL)) {

	WARNING: line over 80 characters
	#422: FILE: drivers/rtc/rtc-s3c.c:422:
	+		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_CLKRST)) {

	WARNING: Missing a blank line after declarations
	#451: FILE: drivers/rtc/rtc-s3c.c:451:
	+	struct s3c_rtc_drv_data *data;
	+	if (pdev->dev.of_node) {

	WARNING: Missing a blank line after declarations
	#453: FILE: drivers/rtc/rtc-s3c.c:453:
	+		const struct of_device_id *match;
	+		match = of_match_node(s3c_rtc_dt_match, pdev->dev.of_node);

	WARNING: DT compatible string "samsung,s3c2416-rtc" appears un-documented -- check ./Documentation/devicetree/bindings/
	#650: FILE: drivers/rtc/rtc-s3c.c:650:
	+		.compatible = "samsung,s3c2416-rtc",

	WARNING: DT compatible string "samsung,s3c2443-rtc" appears un-documented -- check ./Documentation/devicetree/bindings/
	#653: FILE: drivers/rtc/rtc-s3c.c:653:
	+		.compatible = "samsung,s3c2443-rtc",

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 Documentation/devicetree/bindings/rtc/s3c-rtc.txt |  2 ++
 drivers/rtc/rtc-s3c.c                             | 26 ++++++++++++-----------
 2 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/rtc/s3c-rtc.txt b/Documentation/devicetree/bindings/rtc/s3c-rtc.txt
index 7ac7259..06db446 100644
--- a/Documentation/devicetree/bindings/rtc/s3c-rtc.txt
+++ b/Documentation/devicetree/bindings/rtc/s3c-rtc.txt
@@ -3,6 +3,8 @@
 Required properties:
 - compatible: should be one of the following.
     * "samsung,s3c2410-rtc" - for controllers compatible with s3c2410 rtc.
+    * "samsung,s3c2416-rtc" - for controllers compatible with s3c2416 rtc.
+    * "samsung,s3c2443-rtc" - for controllers compatible with s3c2443 rtc.
     * "samsung,s3c6410-rtc" - for controllers compatible with s3c6410 rtc.
 - reg: physical base address of the controller and length of memory mapped
   region.
diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 2f71b13..4e95cca 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -382,25 +382,25 @@ static const struct rtc_class_ops s3c_rtcops = {
 
 static void s3c_rtc_enable(struct s3c_rtc *info, int en)
 {
-	unsigned int tmp;
+	unsigned int con, tmp;
 
 	clk_enable(info->rtc_clk);
+
+	con = readw(info->base + S3C2410_RTCCON);
 	if (!en) {
-		tmp = readw(info->base + S3C2410_RTCCON);
 		if (info->cpu_type == TYPE_S3C64XX)
-			tmp &= ~S3C64XX_RTCCON_TICEN;
-		tmp &= ~S3C2410_RTCCON_RTCEN;
-		writew(tmp, info->base + S3C2410_RTCCON);
+			con &= ~S3C64XX_RTCCON_TICEN;
+		con &= ~S3C2410_RTCCON_RTCEN;
+		writew(con, info->base + S3C2410_RTCCON);
 
 		if (info->cpu_type != TYPE_S3C64XX) {
-			tmp = readb(info->base + S3C2410_TICNT);
-			tmp &= ~S3C2410_TICNT_ENABLE;
-			writeb(tmp, info->base + S3C2410_TICNT);
+			con = readb(info->base + S3C2410_TICNT);
+			con &= ~S3C2410_TICNT_ENABLE;
+			writeb(con, info->base + S3C2410_TICNT);
 		}
 	} else {
 		/* re-enable the device, and check it is ok */
-
-		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_RTCEN) == 0) {
+		if ((con & S3C2410_RTCCON_RTCEN) == 0) {
 			dev_info(info->dev, "rtc disabled, re-enabling\n");
 
 			tmp = readw(info->base + S3C2410_RTCCON);
@@ -408,7 +408,7 @@ static void s3c_rtc_enable(struct s3c_rtc *info, int en)
 				info->base + S3C2410_RTCCON);
 		}
 
-		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_CNTSEL)) {
+		if (con & S3C2410_RTCCON_CNTSEL) {
 			dev_info(info->dev, "removing RTCCON_CNTSEL\n");
 
 			tmp = readw(info->base + S3C2410_RTCCON);
@@ -416,7 +416,7 @@ static void s3c_rtc_enable(struct s3c_rtc *info, int en)
 				info->base + S3C2410_RTCCON);
 		}
 
-		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_CLKRST)) {
+		if (con & S3C2410_RTCCON_CLKRST) {
 			dev_info(info->dev, "removing RTCCON_CLKRST\n");
 
 			tmp = readw(info->base + S3C2410_RTCCON);
@@ -445,8 +445,10 @@ static inline int s3c_rtc_get_driver_data(struct platform_device *pdev)
 {
 #ifdef CONFIG_OF
 	struct s3c_rtc_drv_data *data;
+
 	if (pdev->dev.of_node) {
 		const struct of_device_id *match;
+
 		match = of_match_node(s3c_rtc_dt_match, pdev->dev.of_node);
 		data = (struct s3c_rtc_drv_data *) match->data;
 		return data->cpu_type;
-- 
1.8.0

