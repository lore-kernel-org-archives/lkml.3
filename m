Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbaGAOpi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 10:45:38 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:54710 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916AbaGAOpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 10:45:36 -0400
From: Seunghun Lee <waydi1@gmail.com>
To: dedekind1@gmail.com, adrian.hunter@intel.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Seunghun Lee <waydi1@gmail.com>
Subject: [PATCH] UBIFS: fix some comments
Date: Tue,  1 Jul 2014 23:45:25 +0900
Message-Id: <1404225925-3347-1-git-send-email-waydi1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some comments about return type.

Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 fs/ubifs/recovery.c |    4 ++--
 fs/ubifs/scan.c     |    5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ubifs/recovery.c b/fs/ubifs/recovery.c
index c14adb2..933dda5 100644
--- a/fs/ubifs/recovery.c
+++ b/fs/ubifs/recovery.c
@@ -629,8 +629,8 @@ static void drop_last_node(struct ubifs_scan_leb *sleb, int *offs)
  *
  * This function does a scan of a LEB, but caters for errors that might have
  * been caused by the unclean unmount from which we are attempting to recover.
- * Returns %0 in case of success, %-EUCLEAN if an unrecoverable corruption is
- * found, and a negative error code in case of failure.
+ * Returns the scaned information on success and a negative error code on
+ * failure.
  */
 struct ubifs_scan_leb *ubifs_recover_leb(struct ubifs_info *c, int lnum,
 					 int offs, void *sbuf, int jhead)
diff --git a/fs/ubifs/scan.c b/fs/ubifs/scan.c
index 58aa05d..327d84a 100644
--- a/fs/ubifs/scan.c
+++ b/fs/ubifs/scan.c
@@ -131,7 +131,8 @@ int ubifs_scan_a_node(const struct ubifs_info *c, void *buf, int len, int lnum,
  * @offs: offset to start at (usually zero)
  * @sbuf: scan buffer (must be c->leb_size)
  *
- * This function returns %0 on success and a negative error code on failure.
+ * This function returns the scaned information on success and a negative error
+ * code on failure.
  */
 struct ubifs_scan_leb *ubifs_start_scan(const struct ubifs_info *c, int lnum,
 					int offs, void *sbuf)
@@ -169,8 +170,6 @@ struct ubifs_scan_leb *ubifs_start_scan(const struct ubifs_info *c, int lnum,
  * @sleb: scanning information
  * @lnum: logical eraseblock number
  * @offs: offset to start at (usually zero)
- *
- * This function returns %0 on success and a negative error code on failure.
  */
 void ubifs_end_scan(const struct ubifs_info *c, struct ubifs_scan_leb *sleb,
 		    int lnum, int offs)
-- 
1.7.9.5

