Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaDQPyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:54:16 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:46191 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805AbaDQPyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:54:10 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEUAPv3T1Nbsma4/2dsb2JhbABZgwaCTKhMmVYCAoEkF3SCUxMcIxiBAiQTiAAByzGNfmSEPwEDjmiKBQGKaodjgzM7gSw
Date: Thu, 17 Apr 2014 17:52:11 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/f2fs/node.c: add static to recover_inline_xattr
Message-Id: <20140417175211.95fb87711f8ebb673860e97e@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

recover_inline_xattr is only used in node.c

Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/f2fs/node.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index a161e95..3ce4beb 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1534,7 +1534,7 @@ void recover_node_page(struct f2fs_sb_info *sbi, struct page *page,
 	clear_node_page_dirty(page);
 }
 
-void recover_inline_xattr(struct inode *inode, struct page *page)
+static void recover_inline_xattr(struct inode *inode, struct page *page)
 {
 	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
 	void *src_addr, *dst_addr;
-- 
1.8.4.5

