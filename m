Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaKRKdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:33:13 -0500
Received: from mail-bn1bon0132.outbound.protection.outlook.com ([157.56.111.132]:9366
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753485AbaKRKch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:32:37 -0500
From: Yuan Yao <yao.yuan@freescale.com>
To: <wsa@the-dreams.de>, <marex@denx.de>
CC: <LW@KARO-electronics.de>, <mark.rutland@arm.com>,
        <fugang.duan@freescale.com>, <shawn.guo@linaro.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-i2c@vger.kernel.org>
Subject: [PATCH v11 1/3] i2c: imx: Sort include headers alphabetically
Date: Tue, 18 Nov 2014 18:31:05 +0800
Message-ID: <1416306667-15673-2-git-send-email-yao.yuan@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1416306667-15673-1-git-send-email-yao.yuan@freescale.com>
References: <1416306667-15673-1-git-send-email-yao.yuan@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(46102003)(6806004)(4396001)(87936001)(50226001)(89996001)(88136002)(31966008)(97736003)(87286001)(86362001)(19580405001)(48376002)(104166001)(47776003)(102836001)(20776003)(93916002)(44976005)(68736004)(76176999)(50986999)(50466002)(19580395003)(64706001)(84676001)(92726001)(92566001)(104016003)(106466001)(99396003)(120916001)(95666004)(33646002)(229853001)(105606002)(36756003)(77156002)(62966003)(107046002)(21056001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB380;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB380;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB380;
X-Forefront-PRVS: 039975700A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yao.yuan@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB380;
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

