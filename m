Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbaGBUDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 16:03:23 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:38026 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754473AbaGBUDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 16:03:03 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am4IAJFktFNXQBPR/2dsb2JhbABagw2sZgUBAQEBAQEFAW4BmWeBBxd1hGAjgRo3iEYBx3WFcIkyhEoFkAWKaJQKg0U7Lw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jan Harkes <jaharkes@cs.cmu.edu>,
        Andrew Morton <akpm@linux-foundation.org>, coda@cs.cmu.edu,
        codalist@TELEMANN.coda.cs.cmu.edu
Subject: [PATCH 1/1] FS/CODA: use linux/uaccess.h
Date: Wed,  2 Jul 2014 22:01:40 +0200
Message-Id: <1404331300-3789-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning
WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: coda@cs.cmu.edu
Cc: codalist@coda.cs.cmu.edu
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/coda/cache.c      | 2 +-
 fs/coda/coda_linux.c | 2 +-
 fs/coda/dir.c        | 3 +--
 fs/coda/file.c       | 2 +-
 fs/coda/inode.c      | 4 +---
 fs/coda/pioctl.c     | 2 +-
 fs/coda/psdev.c      | 2 +-
 fs/coda/upcall.c     | 2 +-
 8 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/coda/cache.c b/fs/coda/cache.c
index 1da168c..278f8fd 100644
--- a/fs/coda/cache.c
+++ b/fs/coda/cache.c
@@ -13,7 +13,7 @@
 #include <linux/fs.h>
 #include <linux/stat.h>
 #include <linux/errno.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/string.h>
 #include <linux/list.h>
 #include <linux/sched.h>
diff --git a/fs/coda/coda_linux.c b/fs/coda/coda_linux.c
index 2849f41..1326d38 100644
--- a/fs/coda/coda_linux.c
+++ b/fs/coda/coda_linux.c
@@ -13,7 +13,7 @@
 #include <linux/fs.h>
 #include <linux/stat.h>
 #include <linux/errno.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/string.h>
 
 #include <linux/coda.h>
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index cd8a632..9c3dedc 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -19,8 +19,7 @@
 #include <linux/string.h>
 #include <linux/spinlock.h>
 #include <linux/namei.h>
-
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <linux/coda.h>
 #include <linux/coda_psdev.h>
diff --git a/fs/coda/file.c b/fs/coda/file.c
index 9e83b77..d244d74 100644
--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -18,7 +18,7 @@
 #include <linux/spinlock.h>
 #include <linux/string.h>
 #include <linux/slab.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <linux/coda.h>
 #include <linux/coda_psdev.h>
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index fe3afb2..b945410 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -21,9 +21,7 @@
 #include <linux/vfs.h>
 #include <linux/slab.h>
 #include <linux/pid_namespace.h>
-
-#include <asm/uaccess.h>
-
+#include <linux/uaccess.h>
 #include <linux/fs.h>
 #include <linux/vmalloc.h>
 
diff --git a/fs/coda/pioctl.c b/fs/coda/pioctl.c
index 3f5de96..4326d17 100644
--- a/fs/coda/pioctl.c
+++ b/fs/coda/pioctl.c
@@ -16,7 +16,7 @@
 #include <linux/string.h>
 #include <linux/namei.h>
 #include <linux/module.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <linux/coda.h>
 #include <linux/coda_psdev.h>
diff --git a/fs/coda/psdev.c b/fs/coda/psdev.c
index 5c1e424..8226291 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -40,7 +40,7 @@
 #include <linux/pid_namespace.h>
 #include <asm/io.h>
 #include <asm/poll.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <linux/coda.h>
 #include <linux/coda_psdev.h>
diff --git a/fs/coda/upcall.c b/fs/coda/upcall.c
index 21fcf8d..5bb6e27 100644
--- a/fs/coda/upcall.c
+++ b/fs/coda/upcall.c
@@ -27,7 +27,7 @@
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/vmalloc.h>
 #include <linux/vfs.h>
 
-- 
1.8.4.5

