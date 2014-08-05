Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbaHEM2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:28:50 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57427 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaHEM1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:27:55 -0400
X-AuditID: cbfee690-b7f526d000003627-8c-53e0cdc6c7b7
From: Chanwoo Choi <cw00.choi@samsung.com>
To: a.zummo@towertech.it
Cc: kgene.kim@samsung.com, kyungmin.park@samsung.com,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 2/5] rtc: s3c: Remove warning message when checking coding
 style with checkpatch script
Date: Tue, 05 Aug 2014 21:27:43 +0900
Message-id: <1407241666-17835-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1407241666-17835-1-git-send-email-cw00.choi@samsung.com>
References: <1407241666-17835-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWyRsSkWPfY2QfBBsd6jC2WXLzKbnH9y3NW
	i94FV9kszja9Ybe4vGsOm8WM8/uYLPZ3djA6sHvsmXiSzaNvyypGj+nzfjJ5fN4kF8ASxWWT
	kpqTWZZapG+XwJXR8f8wa0GTWkXz78ksDYwz5bsYOTkkBEwkNq2+wAphi0lcuLeerYuRi0NI
	YCmjxKeb55lhiiYtb2KFSExnlHh5bBNUVROTxOl/zxhBqtgEtCT2v7jBBmKLCEhILJlzhxGk
	iFlgN6PE5DUvWUASwgKZEhOnNDGB2CwCqhIvGv+AreAVcJVof3efBWKdnMSHPY/YQWxOATeJ
	SY+ngdlCQDXN2/8wQtRMZpf4d5wPYo6AxLfJh4B6OYDishKbDkBdLSlxcMUNlgmMwgsYGVYx
	iqYWJBcUJ6UXmegVJ+YWl+al6yXn525iBIY30AsTdjDeO2B9iDEZaNxEZinR5HxgfOSVxBsa
	mxlZmJqYGhuZW5qRJqwkzqv2KClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6NO2J4J5rd/
	BjtoHrkWyV4nVdKzIZnrkMoc8S1CKX98y3lyA9m0dygzeGkv4DqfuDh7meFHzhijf3dv3Ls3
	OWeFzYqWxRuXCJ4Tf2D1/Npe+diqP2eKNzHOfXlnm7HLIn/L1a2eO7esjnN2Fl8d3rk+UZUh
	td/tVPQL6W1XDufN08mpE+CavkuJpTgj0VCLuag4EQB1cw5thQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQd1jZx8EG3xv0bZYcvEqu8X1L89Z
	LXoXXGWzONv0ht3i8q45bBYzzu9jstjf2cHowO6xZ+JJNo++LasYPabP+8nk8XmTXABLVAOj
	TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QCUoKZYk5
	pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjI7/h1kLmtQqmn9PZmlgnCnfxcjJ
	ISFgIjFpeRMrhC0mceHeerYuRi4OIYHpjBIvj22CcpqYJE7/e8YIUsUmoCWx/8UNNhBbREBC
	YsmcO4wgRcwCuxklJq95yQKSEBbIlJg4pYkJxGYRUJV40fiHGcTmFXCVaH93nwVinZzEhz2P
	2EFsTgE3iUmPp4HZQkA1zdv/ME5g5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzh+
	nknvYFzVYHGIUYCDUYmHV0DtfrAQa2JZcWXuIUYJDmYlEd6nux4EC/GmJFZWpRblxxeV5qQW
	H2I0BbpqIrOUaHI+MLbzSuINjU3MjCyNzA0tjIzNlcR5D7ZaBwoJpCeWpGanphakFsH0MXFw
	SjUwmm7tvVUk+L16nZ3zqQN5p1QNOkUMjnL8Kj2/cOtZTZHDUrVV2UyfzJiPvYmWb5B4+vlG
	iIb1VDnHtbwOS/jj2RbeTDJyFSjiOfB3TrycTHF4itfOSWE6Wp8m75Gub3JawWa9ZspVe9nt
	SRaa5t65iVcvePw2vlj06USf8o5PU0vuvf+YzzlZiaU4I9FQi7moOBEAi/rH/LUCAAA=
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
index b9062b5..814ee74 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -382,28 +382,28 @@ static const struct rtc_class_ops s3c_rtcops = {
 
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
@@ -411,7 +411,7 @@ static void s3c_rtc_enable(struct s3c_rtc *info, int en)
 				info->base + S3C2410_RTCCON);
 		}
 
-		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_CNTSEL)) {
+		if (con & S3C2410_RTCCON_CNTSEL) {
 			dev_info(info->dev, "removing RTCCON_CNTSEL\n");
 
 			tmp = readw(info->base + S3C2410_RTCCON);
@@ -419,7 +419,7 @@ static void s3c_rtc_enable(struct s3c_rtc *info, int en)
 				info->base + S3C2410_RTCCON);
 		}
 
-		if ((readw(info->base + S3C2410_RTCCON) & S3C2410_RTCCON_CLKRST)) {
+		if (con & S3C2410_RTCCON_CLKRST) {
 			dev_info(info->dev, "removing RTCCON_CLKRST\n");
 
 			tmp = readw(info->base + S3C2410_RTCCON);
@@ -448,8 +448,10 @@ static inline int s3c_rtc_get_driver_data(struct platform_device *pdev)
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

