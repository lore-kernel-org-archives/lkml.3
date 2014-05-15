Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbaEOQ6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 12:58:12 -0400
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:4239 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754456AbaEOQ5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 12:57:12 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoMRADjxdFNXQwiB/2dsb2JhbABZgwaDPqhZBAEBAQEBAQUBmhkCAoERF3SCZhwjGIECJBOIRQHRKIVUiHqERwEDjyqKJgGTFIM4Ow
Date: Thu, 15 May 2014 18:57:08 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Steven Whitehouse <swhiteho@redhat.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/gfs2/file.c: kernel-doc warning fixes
Message-Id: <20140515185708.c1f20b1f89e4b9aeccb31a0f@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Related function is not gfs2_set_flags but do_gfs2_set_flags

Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/gfs2/file.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index 80d6725..768cbd4 100644
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
1.8.4.5

