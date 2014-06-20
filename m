Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966398AbaFTTyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:54:54 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:58070 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965171AbaFTTyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:54:53 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsHAFyRpFNXQzOZ/2dsb2JhbABZgw2rRgUBAQEBAQEFAZkqgQ4XdYRgI4EaN4hGAcozF4ViiRQdhC0EmkSTWoNEOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jan Kara <jack@suse.cz>
Subject: [PATCH 1/1] FS/UDF: use linux/uaccess.h (2)
Date: Fri, 20 Jun 2014 21:53:10 +0200
Message-Id: <1403293990-3123-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning
WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

on 3 more files.

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/udf/lowlevel.c | 2 +-
 fs/udf/super.c    | 2 +-
 fs/udf/symlink.c  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/udf/lowlevel.c b/fs/udf/lowlevel.c
index 6583fe9..6ad5a45 100644
--- a/fs/udf/lowlevel.c
+++ b/fs/udf/lowlevel.c
@@ -21,7 +21,7 @@
 
 #include <linux/blkdev.h>
 #include <linux/cdrom.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include "udf_sb.h"
 
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 3286db0..813da94 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -63,7 +63,7 @@
 #include "udf_i.h"
 
 #include <linux/init.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #define VDS_POS_PRIMARY_VOL_DESC	0
 #define VDS_POS_UNALLOC_SPACE_DESC	1
diff --git a/fs/udf/symlink.c b/fs/udf/symlink.c
index d7c6dbe..6fb7945 100644
--- a/fs/udf/symlink.c
+++ b/fs/udf/symlink.c
@@ -20,7 +20,7 @@
  */
 
 #include "udfdecl.h"
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/time.h>
-- 
1.8.4.5

