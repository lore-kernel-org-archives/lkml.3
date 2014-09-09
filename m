Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbaIIBNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 21:13:52 -0400
Received: from mail-yh0-f48.google.com ([209.85.213.48]:43915 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781AbaIIBNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 21:13:50 -0400
From: Greg Donald <gdonald@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>, linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] drivers: staging: lustre: Fix 'code indent should use tabs where possible' errors
Date: Mon,  8 Sep 2014 20:13:13 -0500
Message-Id: <1410225193-30164-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch.pl 'code indent should use tabs where possible' errors

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 drivers/staging/lustre/lustre/llite/file.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 10a1475..bc68fdd 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -1013,10 +1013,10 @@ int ll_merge_lvb(const struct lu_env *env, struct inode *inode)
 	LTIME_S(inode->i_ctime) = lli->lli_lvb.lvb_ctime;
 
 	lvb.lvb_size = i_size_read(inode);
-        lvb.lvb_blocks = inode->i_blocks;
-        lvb.lvb_mtime = LTIME_S(inode->i_mtime);
-        lvb.lvb_atime = LTIME_S(inode->i_atime);
-        lvb.lvb_ctime = LTIME_S(inode->i_ctime);
+	lvb.lvb_blocks = inode->i_blocks;
+	lvb.lvb_mtime = LTIME_S(inode->i_mtime);
+	lvb.lvb_atime = LTIME_S(inode->i_atime);
+	lvb.lvb_ctime = LTIME_S(inode->i_ctime);
 
 	cl_object_attr_lock(obj);
 	rc = cl_object_attr_get(env, obj, attr);
-- 
1.9.1

