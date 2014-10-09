Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbaJIJDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 05:03:54 -0400
Received: from mail-bl2on0146.outbound.protection.outlook.com ([65.55.169.146]:10001
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755387AbaJIJDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 05:03:33 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <dp@opensource.wolfsonmicro.com>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH 1/6] regmap: cache: Sort include headers alphabetically
Date: Thu, 9 Oct 2014 17:02:52 +0800
Message-ID: <1412845377-17134-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
In-Reply-To: <1412845377-17134-1-git-send-email-Li.Xiubo@freescale.com>
References: <1412845377-17134-1-git-send-email-Li.Xiubo@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(81156004)(105606002)(85306004)(68736004)(69596002)(50986999)(76176999)(95666004)(99396003)(106466001)(62966002)(48376002)(50466002)(107046002)(2351001)(120916001)(229853001)(36756003)(84676001)(110136001)(77156001)(104166001)(76482002)(102836001)(26826002)(46102003)(80022003)(31966008)(92726001)(93916002)(20776003)(47776003)(44976005)(19580405001)(19580395003)(50226001)(4396001)(97736003)(6806004)(85852003)(89996001)(88136002)(87286001)(104016003)(87936001)(92566001)(21056001)(86362001)(64706001)(2004002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0614;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0614;
X-Forefront-PRVS: 0359162B6D
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the inlcude headers aren't sorted alphabetically, then the
logical choice is to append new ones, however that creates a
lot of potential for conflicts or duplicates because every change
will then add new includes in the same location.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/base/regmap/regcache-flat.c   | 2 +-
 drivers/base/regmap/regcache-lzo.c    | 2 +-
 drivers/base/regmap/regcache-rbtree.c | 4 ++--
 drivers/base/regmap/regcache.c        | 8 ++++----
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/base/regmap/regcache-flat.c b/drivers/base/regmap/regcache-flat.c
index d9762e4..0246f44 100644
--- a/drivers/base/regmap/regcache-flat.c
+++ b/drivers/base/regmap/regcache-flat.c
@@ -10,9 +10,9 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/slab.h>
 #include <linux/device.h>
 #include <linux/seq_file.h>
+#include <linux/slab.h>
 
 #include "internal.h"
 
diff --git a/drivers/base/regmap/regcache-lzo.c b/drivers/base/regmap/regcache-lzo.c
index e210a6d..2d53f6f 100644
--- a/drivers/base/regmap/regcache-lzo.c
+++ b/drivers/base/regmap/regcache-lzo.c
@@ -10,9 +10,9 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/slab.h>
 #include <linux/device.h>
 #include <linux/lzo.h>
+#include <linux/slab.h>
 
 #include "internal.h"
 
diff --git a/drivers/base/regmap/regcache-rbtree.c b/drivers/base/regmap/regcache-rbtree.c
index f3e8fe0..d453a2c 100644
--- a/drivers/base/regmap/regcache-rbtree.c
+++ b/drivers/base/regmap/regcache-rbtree.c
@@ -10,11 +10,11 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/slab.h>
-#include <linux/device.h>
 #include <linux/debugfs.h>
+#include <linux/device.h>
 #include <linux/rbtree.h>
 #include <linux/seq_file.h>
+#include <linux/slab.h>
 
 #include "internal.h"
 
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index f1280dc..4896804 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -10,12 +10,12 @@
  * published by the Free Software Foundation.
  */
 
-#include <linux/slab.h>
-#include <linux/export.h>
-#include <linux/device.h>
-#include <trace/events/regmap.h>
 #include <linux/bsearch.h>
+#include <linux/device.h>
+#include <linux/export.h>
+#include <linux/slab.h>
 #include <linux/sort.h>
+#include <trace/events/regmap.h>
 
 #include "internal.h"
 
-- 
2.1.0.27.g96db324

