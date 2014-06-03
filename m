Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaFCLDD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:03:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbaFCLDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:03:01 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 5/6] GFS2: fs/gfs2/file.c: kernel-doc warning fixes
Date: Tue,  3 Jun 2014 12:02:32 +0100
Message-Id: <1401793353-1469-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1401793353-1469-1-git-send-email-swhiteho@redhat.com>
References: <1401793353-1469-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

Related function is not gfs2_set_flags but do_gfs2_set_flags

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 6065252..6ab0cfb 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -203,9 +203,9 @@ void gfs2_set_inode_flags(struct inode *inode)
 			     GFS2_DIF_INHERIT_JDATA)
 
 /**
- * gfs2_set_flags - set flags on an inode
- * @inode: The inode
- * @flags: The flags to set
+ * do_gfs2_set_flags - set flags on an inode
+ * @filp: file pointer
+ * @reqflags: The flags to set
  * @mask: Indicates which flags are valid
  *
  */
@@ -318,7 +318,7 @@ static long gfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 /**
  * gfs2_size_hint - Give a hint to the size of a write request
- * @file: The struct file
+ * @filep: The struct file
  * @offset: The file offset of the write
  * @size: The length of the write
  *
@@ -371,7 +371,7 @@ static int gfs2_allocate_page_backing(struct page *page)
 /**
  * gfs2_page_mkwrite - Make a shared, mmap()ed, page writable
  * @vma: The virtual memory area
- * @page: The page which is about to become writable
+ * @vmf: The virtual memory fault containing the page to become writable
  *
  * When the page becomes writable, we need to ensure that we have
  * blocks allocated on disk to back that page.
-- 
1.8.3.1

