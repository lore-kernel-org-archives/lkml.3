Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbaHVJrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 05:47:43 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33793 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbaHVJqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:46:50 -0400
X-AuditID: cbfee68d-b7f2f6d0000062f0-a3-53f71185383f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: a.zummo@towertech.it
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        akpm@linux-foundation.org, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [RESEND PATCHv2 2/5] rtc: s3c: Remove warning message when checking
 coding style with checkpatch script
Date: Fri, 22 Aug 2014 18:46:39 +0900
Message-id: <1408700802-15673-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1408700802-15673-1-git-send-email-cw00.choi@samsung.com>
References: <1408700802-15673-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWyRsSkQLdV8HuwwfolohZLLl5lt5izfg2b
	xfUvz1ktehdcZbM42/SG3eLyrjlsFjPO72Oy2N/ZwejA4bFn4kk2jxMzfrN49G1Zxegxfd5P
	Jo/Pm+QCWKO4bFJSczLLUov07RK4MnYvX8pecF2tYmnbZ8YGxifyXYycHBICJhJLr55jhbDF
	JC7cW8/WxcjFISSwlFHiyJ0GVpii6d+2sEMkpjNKLFsN0gHiNDFJnDmylRmkik1AS2L/ixts
	ILaIgITEkjl3GEGKmAVuMEosXPwFbJSwQJFEy4ELjCA2i4CqRNu1pywgNq+Aq8Sd77vZINbJ
	SXzY84gdxOYUcJPob+ln6mLkANrmKnHxQwnITAmBVewSv752MEPMEZD4NvkQC0iNhICsxKYD
	zBBjJCUOrrjBMoFReAEjwypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MwJA//e9Z7w7G2wes
	DzEmA42byCwlmpwPjJm8knhDYzMjC1MTU2Mjc0sz0oSVxHmTHiYFCQmkJ5akZqemFqQWxReV
	5qQWH2Jk4uCUamDkaW82PFz29OJZr3mT3PjYtu5RzXHIYVv/u+KbksoPiUMKseVPM+++YfN0
	e8rOGrpb9RO3IWugprN7wAL/WLZJz59tL67R4gxpnDRPiNWZM25L3WT7ExZfjA6/6sq1XhTU
	/NrntfxBb98FTlbqWWI9QqWhScmX7uxb/2Za/8PA17KrIy2adJRYijMSDbWYi4oTAa0b5b6P	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t9jQd1Wwe/BBldf8FgsuXiV3WLO+jVs
	Fte/PGe16F1wlc3ibNMbdovLu+awWcw4v4/JYn9nB6MDh8eeiSfZPE7M+M3i0bdlFaPH9Hk/
	mTw+b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQ
	dcvMATpGSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5ixe/lS9oLrahVL
	2z4zNjA+ke9i5OSQEDCRmP5tCzuELSZx4d56ti5GLg4hgemMEstWn2OFcJqYJM4c2coMUsUm
	oCWx/8UNNhBbREBCYsmcO4wgRcwCNxglFi7+wgqSEBYokmg5cIERxGYRUJVou/aUBcTmFXCV
	uPN9NxvEOjmJD3sega3mFHCT6G/pZ+pi5ADa5ipx8UPJBEbeBYwMqxhFUwuSC4qT0nON9IoT
	c4tL89L1kvNzNzGCI+qZ9A7GVQ0WhxgFOBiVeHgjvnwNFmJNLCuuzD3EKMHBrCTC+4Pve7AQ
	b0piZVVqUX58UWlOavEhRlOgoyYyS4km5wOjPa8k3tDYxMzI0sjc0MLI2FxJnPdgq3WgkEB6
	YklqdmpqQWoRTB8TB6dUA6PJipy5Dke0thdUrj+g3DGDL//9s82romxYn8rGCdbt/lzz4oSZ
	rFX+FKmHrxp9tqak6U0SFjap3J3p5VHxVCUwt+jn59b36eEuBewTnPxvTToknG6z54muQWT4
	nBMNnx8FhQncuOvN8ZWr/t3OAnZ3kSfx/vY/qzhX3jbR2Vl05MWj0+b/fyuxFGckGmoxFxUn
	AgA6YzX1vgIAAA==
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
index 1d9e158..d8f25bd 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -400,28 +400,28 @@ static const struct rtc_class_ops s3c_rtcops = {
 
 static void s3c_rtc_enable(struct s3c_rtc *info, int en)
 {
-	unsigned int tmp;
+	unsigned int con, tmp;
 
 	if (!info->base)
 		return;
 
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
@@ -429,7 +429,7 @@ static void s3c_rtc_enable(struct s3c_rtc *info, int en)
 				info->base + S3C2410_RTCCON);
 		}
 
-		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_CNTSEL)) {
+		if (con & S3C2410_RTCCON_CNTSEL) {
 			dev_info(info->dev, "removing RTCCON_CNTSEL\n");
 
 			tmp = readw(info->base + S3C2410_RTCCON);
@@ -437,7 +437,7 @@ static void s3c_rtc_enable(struct s3c_rtc *info, int en)
 				info->base + S3C2410_RTCCON);
 		}
 
-		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_CLKRST)) {
+		if (con & S3C2410_RTCCON_CLKRST) {
 			dev_info(info->dev, "removing RTCCON_CLKRST\n");
 
 			tmp = readw(info->base + S3C2410_RTCCON);
@@ -466,8 +466,10 @@ static inline int s3c_rtc_get_driver_data(struct platform_device *pdev)
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

