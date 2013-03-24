Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab3CXTZt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 15:25:49 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:38749 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab3CXTZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 15:25:48 -0400
From: Alice Ferrazzi <alice.ferrazzi@gmail.com>
To: roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Alice Ferrazzi <alice.ferrazzi@gmail.com>
Subject: [PATCH] Infiniband: core: change <asm/uaccess.h> to <linux/uaccess.h>
Date: Mon, 25 Mar 2013 04:24:44 +0900
Message-Id: <1364153084-8911-1-git-send-email-alice.ferrazzi@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces <asm/uaccess.h> with <linux/uaccess.h>
to comply with the checkpatch.pl hint.

Signed-off-by: Alice Ferrazzi <alice.ferrazzi@gmail.com>
---
 drivers/infiniband/core/ucm.c         |    2 +-
 drivers/infiniband/core/user_mad.c    |    2 +-
 drivers/infiniband/core/uverbs_cmd.c  |    2 +-
 drivers/infiniband/core/uverbs_main.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index f2f6393..224a7c9 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -46,7 +46,7 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <rdma/ib_cm.h>
 #include <rdma/ib_user_cm.h>
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index f0d588f..ad414f1 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -48,7 +48,7 @@
 #include <linux/semaphore.h>
 #include <linux/slab.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <rdma/ib_mad.h>
 #include <rdma/ib_user_mad.h>
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index a7d00f6..62ff7f3 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -37,7 +37,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include "uverbs.h"
 
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 2c6f0f2..dfee66f 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -46,7 +46,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/slab.h>
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include "uverbs.h"
 
-- 
1.7.10.4

