Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaL0UTI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 15:19:08 -0500
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:5903 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735AbaL0UTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 15:19:03 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjAVAH8Tn1Rbsnvc/2dsb2JhbABcgwaBKrQcBQEBAQEBAQUBd5cwBAKBCBcBAQEBAX2EaSOBGjeIMAG2A49ChgOJEGQdhBMFlwiBDYUYiysigUUBgik9MYEDgUABAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Joern Engel <joern@logfs.org>,
        Prasad Joshi <prasadjoshi.linux@gmail.com>, logfs@logfs.org
Subject: [PATCH 1/1 linux-next] logfs: kernel-doc warning fix
Date: Sat, 27 Dec 2014 21:18:57 +0100
Message-Id: <1419711537-5707-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

logfs_segment_read() receives a page not a buffer.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/logfs/segment.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/logfs/segment.c b/fs/logfs/segment.c
index 7f9b096..b2dddce 100644
--- a/fs/logfs/segment.c
+++ b/fs/logfs/segment.c
@@ -646,7 +646,7 @@ out_err:
 /**
  * logfs_segment_read - read data block from object store
  * @inode:		inode containing data
- * @buf:		data buffer
+ * @page:		destination page cache page
  * @ofs:		physical data offset
  * @bix:		block index
  * @level:		block level
-- 
2.1.0

