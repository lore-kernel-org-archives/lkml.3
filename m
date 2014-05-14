Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbaENQcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:32:35 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:43244 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754219AbaENQce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:32:34 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuUNAF6Zc1NXQ68k/2dsb2JhbABZgwasaQQBAQEBAQEFAZodgSMXdIJmHCMYgQIkE4hFAdE7hVSIeoRHAQOPKoomAZMUgzg7
Date: Wed, 14 May 2014 18:32:31 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/gfs2/bmap.c: kernel-doc warning fixes
Message-Id: <20140514183231.eef720aac99fae1a930ba10c@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix 2 typos and move one definition which was between function
comments and function definition (yet another kernel-doc warning)

Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/gfs2/bmap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index c62d4b9..e6ee5b6 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -707,7 +707,7 @@ int gfs2_extent_map(struct inode *inode, u64 lblock, int *new, u64 *dblock, unsi
  * @top: The first pointer in the buffer
  * @bottom: One more than the last pointer
  * @height: the height this buffer is at
- * @data: a pointer to a struct strip_mine
+ * @sm: a pointer to a struct strip_mine
  *
  * Returns: errno
  */
@@ -992,6 +992,8 @@ unlock:
 	return err;
 }
 
+#define GFS2_JTRUNC_REVOKES 8192
+
 /**
  * gfs2_journaled_truncate - Wrapper for truncate_pagecache for jdata files
  * @inode: The inode being truncated
@@ -1003,8 +1005,6 @@ unlock:
  * if the number of pages being truncated gets too large.
  */
 
-#define GFS2_JTRUNC_REVOKES 8192
-
 static int gfs2_journaled_truncate(struct inode *inode, u64 oldsize, u64 newsize)
 {
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
@@ -1348,7 +1348,7 @@ void gfs2_free_journal_extents(struct gfs2_jdesc *jd)
  * gfs2_add_jextent - Add or merge a new extent to extent cache
  * @jd: The journal descriptor
  * @lblock: The logical block at start of new extent
- * @pblock: The physical block at start of new extent
+ * @dblock: The physical block at start of new extent
  * @blocks: Size of extent in fs blocks
  *
  * Returns: 0 on success or -ENOMEM
-- 
1.9.1

