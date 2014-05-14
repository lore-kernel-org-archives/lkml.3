Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbaENQ7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:59:38 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:39258 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754723AbaENQ7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:59:37 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuUNAKOgc1NXQ68k/2dsb2JhbABZgwasaQQBAQEBAQEFAZodgSMXdIJTExwjGIECJBOIRQHRPoVUiHqERwEDjyqKJgGTFIM4Ow
Date: Wed, 14 May 2014 18:59:35 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/1] fs/exportfs/expfs.c: kernel-doc warning fixes
Message-Id: <20140514185935.6529e7f66d36da00644f5895@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing 2 typo in function comments.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/exportfs/expfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index 48a359d..b01fbfb 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -259,7 +259,7 @@ static int filldir_one(void * __buf, const char * name, int len,
 
 /**
  * get_name - default export_operations->get_name function
- * @dentry: the directory in which to find a name
+ * @path:   the directory in which to find a name
  * @name:   a pointer to a %NAME_MAX+1 char buffer to store the name
  * @child:  the dentry for the child directory.
  *
@@ -337,7 +337,7 @@ out:
 /**
  * export_encode_fh - default export_operations->encode_fh function
  * @inode:   the object to encode
- * @fh:      where to store the file handle fragment
+ * @fid:     where to store the file handle fragment
  * @max_len: maximum length to store there
  * @parent:  parent directory inode, if wanted
  *
-- 
1.9.1
