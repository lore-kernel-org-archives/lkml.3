Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbaAUV0G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:26:06 -0500
Received: from mail1.windriver.com ([147.11.146.13]:50785 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaAUVZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:35 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        <linux-bluetooth@vger.kernel.org>
Subject: [PATCH 60/73] drivers/bluetooth: delete non-required instances of include <linux/init.h>
Date: Tue, 21 Jan 2014 16:23:03 -0500
Message-ID: <1390339396-3479-61-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files are actually using any __init type directives
and hence don't need to include <linux/init.h>.  Most are just a
left over from __devinit and __cpuinit removal, or simply due to
code getting copied from one driver to the next.

Cc: Marcel Holtmann <marcel@holtmann.org>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: Johan Hedberg <johan.hedberg@gmail.com>
Cc: linux-bluetooth@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/bluetooth/ath3k.c       | 1 -
 drivers/bluetooth/bcm203x.c     | 1 -
 drivers/bluetooth/bfusb.c       | 1 -
 drivers/bluetooth/bluecard_cs.c | 1 -
 drivers/bluetooth/bpa10x.c      | 1 -
 drivers/bluetooth/bt3c_cs.c     | 1 -
 drivers/bluetooth/btuart_cs.c   | 1 -
 drivers/bluetooth/dtl1_cs.c     | 1 -
 8 files changed, 8 deletions(-)

diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
index 41ec6f9..427f280 100644
--- a/drivers/bluetooth/ath3k.c
+++ b/drivers/bluetooth/ath3k.c
@@ -20,7 +20,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/errno.h>
diff --git a/drivers/bluetooth/bcm203x.c b/drivers/bluetooth/bcm203x.c
index 364f82b..40db9a9 100644
--- a/drivers/bluetooth/bcm203x.c
+++ b/drivers/bluetooth/bcm203x.c
@@ -26,7 +26,6 @@
 
 #include <linux/atomic.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/errno.h>
diff --git a/drivers/bluetooth/bfusb.c b/drivers/bluetooth/bfusb.c
index 3138699..48b71f0 100644
--- a/drivers/bluetooth/bfusb.c
+++ b/drivers/bluetooth/bfusb.c
@@ -24,7 +24,6 @@
 #include <linux/module.h>
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/errno.h>
diff --git a/drivers/bluetooth/bluecard_cs.c b/drivers/bluetooth/bluecard_cs.c
index 57427de..0aae563 100644
--- a/drivers/bluetooth/bluecard_cs.c
+++ b/drivers/bluetooth/bluecard_cs.c
@@ -23,7 +23,6 @@
 #include <linux/module.h>
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/sched.h>
diff --git a/drivers/bluetooth/bpa10x.c b/drivers/bluetooth/bpa10x.c
index 8a31991..40281c0 100644
--- a/drivers/bluetooth/bpa10x.c
+++ b/drivers/bluetooth/bpa10x.c
@@ -23,7 +23,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/sched.h>
diff --git a/drivers/bluetooth/bt3c_cs.c b/drivers/bluetooth/bt3c_cs.c
index 73d8799..f3508fe 100644
--- a/drivers/bluetooth/bt3c_cs.c
+++ b/drivers/bluetooth/bt3c_cs.c
@@ -24,7 +24,6 @@
 #include <linux/module.h>
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/delay.h>
diff --git a/drivers/bluetooth/btuart_cs.c b/drivers/bluetooth/btuart_cs.c
index a03ecc2..057104e 100644
--- a/drivers/bluetooth/btuart_cs.c
+++ b/drivers/bluetooth/btuart_cs.c
@@ -23,7 +23,6 @@
 #include <linux/module.h>
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/delay.h>
diff --git a/drivers/bluetooth/dtl1_cs.c b/drivers/bluetooth/dtl1_cs.c
index 52eed1f..5bb80e4 100644
--- a/drivers/bluetooth/dtl1_cs.c
+++ b/drivers/bluetooth/dtl1_cs.c
@@ -23,7 +23,6 @@
 #include <linux/module.h>
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/delay.h>
-- 
1.8.4.1

