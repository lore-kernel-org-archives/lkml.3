Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbaFWQ2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:28:37 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:22485 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755369AbaFWQ2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:28:36 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkHAHdUqFNbskjJ/2dsb2JhbABZgw2rZQUBAQEBAQEFAZk1gQ8XdYRgI4EaN4hGAcZbF4VjiRmESgSPcopak2ODRDs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, reiserfs-devel@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] FS/REISERFS: use linux/uaccess.h
Date: Mon, 23 Jun 2014 18:27:16 +0200
Message-Id: <1403540836-10316-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning
WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

Cc: reiserfs-devel@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/reiserfs/dir.c            | 2 +-
 fs/reiserfs/do_balan.c       | 2 +-
 fs/reiserfs/file.c           | 2 +-
 fs/reiserfs/ibalance.c       | 2 +-
 fs/reiserfs/inode.c          | 2 +-
 fs/reiserfs/ioctl.c          | 2 +-
 fs/reiserfs/lbalance.c       | 2 +-
 fs/reiserfs/procfs.c         | 2 +-
 fs/reiserfs/super.c          | 2 +-
 fs/reiserfs/xattr.c          | 2 +-
 fs/reiserfs/xattr_acl.c      | 2 +-
 fs/reiserfs/xattr_security.c | 2 +-
 fs/reiserfs/xattr_trusted.c  | 2 +-
 fs/reiserfs/xattr_user.c     | 2 +-
 14 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/reiserfs/dir.c b/fs/reiserfs/dir.c
index d9f5a60..0a7dc94 100644
--- a/fs/reiserfs/dir.c
+++ b/fs/reiserfs/dir.c
@@ -9,7 +9,7 @@
 #include <linux/stat.h>
 #include <linux/buffer_head.h>
 #include <linux/slab.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 extern const struct reiserfs_key MIN_KEY;
 
diff --git a/fs/reiserfs/do_balan.c b/fs/reiserfs/do_balan.c
index 54fdf19..5739cb9 100644
--- a/fs/reiserfs/do_balan.c
+++ b/fs/reiserfs/do_balan.c
@@ -10,7 +10,7 @@
  * and using buffers obtained after all above.
  */
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/time.h>
 #include "reiserfs.h"
 #include <linux/buffer_head.h>
diff --git a/fs/reiserfs/file.c b/fs/reiserfs/file.c
index db9e80b..751dd3f 100644
--- a/fs/reiserfs/file.c
+++ b/fs/reiserfs/file.c
@@ -6,7 +6,7 @@
 #include "reiserfs.h"
 #include "acl.h"
 #include "xattr.h"
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
 #include <linux/writeback.h>
diff --git a/fs/reiserfs/ibalance.c b/fs/reiserfs/ibalance.c
index 73231b1..b751eea 100644
--- a/fs/reiserfs/ibalance.c
+++ b/fs/reiserfs/ibalance.c
@@ -2,7 +2,7 @@
  * Copyright 2000 by Hans Reiser, licensing governed by reiserfs/README
  */
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/string.h>
 #include <linux/time.h>
 #include "reiserfs.h"
diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
index 63b2b0e..a7eec98 100644
--- a/fs/reiserfs/inode.c
+++ b/fs/reiserfs/inode.c
@@ -11,7 +11,7 @@
 #include <linux/pagemap.h>
 #include <linux/highmem.h>
 #include <linux/slab.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/unaligned.h>
 #include <linux/buffer_head.h>
 #include <linux/mpage.h>
diff --git a/fs/reiserfs/ioctl.c b/fs/reiserfs/ioctl.c
index 501ed68..6ec8a30 100644
--- a/fs/reiserfs/ioctl.c
+++ b/fs/reiserfs/ioctl.c
@@ -7,7 +7,7 @@
 #include <linux/mount.h>
 #include "reiserfs.h"
 #include <linux/time.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/pagemap.h>
 #include <linux/compat.h>
 
diff --git a/fs/reiserfs/lbalance.c b/fs/reiserfs/lbalance.c
index d6744c8..814dda3 100644
--- a/fs/reiserfs/lbalance.c
+++ b/fs/reiserfs/lbalance.c
@@ -2,7 +2,7 @@
  * Copyright 2000 by Hans Reiser, licensing governed by reiserfs/README
  */
 
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/string.h>
 #include <linux/time.h>
 #include "reiserfs.h"
diff --git a/fs/reiserfs/procfs.c b/fs/reiserfs/procfs.c
index 02b0b7d..621b9f3 100644
--- a/fs/reiserfs/procfs.c
+++ b/fs/reiserfs/procfs.c
@@ -11,7 +11,7 @@
 #include <linux/module.h>
 #include <linux/time.h>
 #include <linux/seq_file.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include "reiserfs.h"
 #include <linux/init.h>
 #include <linux/proc_fs.h>
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index a392cef..e986ae8 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -15,7 +15,7 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/time.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include "reiserfs.h"
 #include "acl.h"
 #include "xattr.h"
diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index ca416d0..40c13dd 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -45,7 +45,7 @@
 #include <linux/xattr.h>
 #include "xattr.h"
 #include "acl.h"
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <net/checksum.h>
 #include <linux/stat.h>
 #include <linux/quotaops.h>
diff --git a/fs/reiserfs/xattr_acl.c b/fs/reiserfs/xattr_acl.c
index 44503e2..4b34b9d 100644
--- a/fs/reiserfs/xattr_acl.c
+++ b/fs/reiserfs/xattr_acl.c
@@ -9,7 +9,7 @@
 #include <linux/posix_acl_xattr.h>
 #include "xattr.h"
 #include "acl.h"
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 static int __reiserfs_set_acl(struct reiserfs_transaction_handle *th,
 			    struct inode *inode, int type,
diff --git a/fs/reiserfs/xattr_security.c b/fs/reiserfs/xattr_security.c
index 800a3ce..e7f8939 100644
--- a/fs/reiserfs/xattr_security.c
+++ b/fs/reiserfs/xattr_security.c
@@ -6,7 +6,7 @@
 #include <linux/slab.h>
 #include "xattr.h"
 #include <linux/security.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 static int
 security_get(struct dentry *dentry, const char *name, void *buffer, size_t size,
diff --git a/fs/reiserfs/xattr_trusted.c b/fs/reiserfs/xattr_trusted.c
index a003571..5eeb0c4 100644
--- a/fs/reiserfs/xattr_trusted.c
+++ b/fs/reiserfs/xattr_trusted.c
@@ -5,7 +5,7 @@
 #include <linux/pagemap.h>
 #include <linux/xattr.h>
 #include "xattr.h"
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 static int
 trusted_get(struct dentry *dentry, const char *name, void *buffer, size_t size,
diff --git a/fs/reiserfs/xattr_user.c b/fs/reiserfs/xattr_user.c
index 8667491..e50eab0 100644
--- a/fs/reiserfs/xattr_user.c
+++ b/fs/reiserfs/xattr_user.c
@@ -4,7 +4,7 @@
 #include <linux/pagemap.h>
 #include <linux/xattr.h>
 #include "xattr.h"
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 static int
 user_get(struct dentry *dentry, const char *name, void *buffer, size_t size,
-- 
1.8.4.5

