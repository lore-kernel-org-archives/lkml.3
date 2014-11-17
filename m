Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaKQK5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:57:16 -0500
Received: from mail-bn1on0115.outbound.protection.outlook.com ([157.56.110.115]:56352
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751057AbaKQK5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:57:11 -0500
From: Yuan Yao <yao.yuan@freescale.com>
To: <wsa@the-dreams.de>, <marex@denx.de>
CC: <LW@KARO-electronics.de>, <mark.rutland@arm.com>,
        <fugang.duan@freescale.com>, <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-i2c@vger.kernel.org>
Subject: [PATCH v10 1/3] i2c: imx: Sort include headers alphabetically
Date: Mon, 17 Nov 2014 18:40:34 +0800
Message-ID: <1416220836-7666-2-git-send-email-yao.yuan@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1416220836-7666-1-git-send-email-yao.yuan@freescale.com>
References: <1416220836-7666-1-git-send-email-yao.yuan@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yao.yuan@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(88136002)(87286001)(64706001)(20776003)(50986999)(104166001)(47776003)(105606002)(77156002)(95666004)(87936001)(4396001)(102836001)(50226001)(89996001)(76176999)(85426001)(84676001)(33646002)(104016003)(99396003)(50466002)(36756003)(120916001)(48376002)(6806004)(68736004)(19580405001)(19580395003)(44976005)(86362001)(93916002)(21056001)(107046002)(97736003)(229853001)(62966003)(31966008)(92566001)(46102003)(92726001)(106466001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB371;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB371;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB371;
X-Forefront-PRVS: 03982FDC1D
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB371;
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
index a7a2a79..d025c47 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -32,22 +32,22 @@
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

