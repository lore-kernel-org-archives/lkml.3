Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbaJKK6D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 06:58:03 -0400
Received: from mail-bn1bn0103.outbound.protection.outlook.com ([157.56.110.103]:58336
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751750AbaJKK6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 06:58:00 -0400
From: Yuan Yao <yao.yuan@freescale.com>
To: <wsa@the-dreams.de>, <marex@denx.de>
CC: <LW@KARO-electronics.de>, <mark.rutland@arm.com>,
        <fugang.duan@freescale.com>, <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-i2c@vger.kernel.org>
Subject: [PATCH v9 1/3] i2c: imx: Sort include headers alphabetically
Date: Sat, 11 Oct 2014 18:57:10 +0800
Message-ID: <1413025032-14958-2-git-send-email-yao.yuan@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1413025032-14958-1-git-send-email-yao.yuan@freescale.com>
References: <1413025032-14958-1-git-send-email-yao.yuan@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(105606002)(85306004)(99396003)(107046002)(76176999)(50986999)(81156004)(48376002)(95666004)(62966002)(106466001)(50466002)(229853001)(120916001)(69596002)(64706001)(84676001)(92566001)(44976005)(77156001)(104166001)(102836001)(46102003)(80022003)(26826002)(31966008)(76482002)(47776003)(20776003)(50226001)(4396001)(97736003)(19580395003)(92726001)(36756003)(6806004)(19580405001)(93916002)(68736004)(33646002)(89996001)(87286001)(88136002)(87936001)(104016003)(86362001)(21056001)(85852003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB382;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB382;
X-Forefront-PRVS: 0361212EA8
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yao.yuan@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the inlcude headers aren't sorted alphabetically, then the
logical choice is to append new ones, however that creates a
lot of potential for conflicts or duplicates because every change
will then add new includes in the same location.

Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
---
 drivers/i2c/busses/i2c-imx.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index c48e46a..2452b57 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -37,22 +37,22 @@
 /** Includes *******************************************************************
 *******************************************************************************/
 
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/errno.h>
-#include <linux/err.h>
-#include <linux/interrupt.h>
+#include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/errno.h>
 #include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/io.h>
-#include <linux/sched.h>
-#include <linux/platform_device.h>
-#include <linux/clk.h>
-#include <linux/slab.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_data/i2c-imx.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
 
 /** Defines ********************************************************************
 *******************************************************************************/
-- 
2.1.0.27.g96db324

