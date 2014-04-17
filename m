Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaDQPxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 11:53:24 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:24733 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753823AbaDQPw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 11:52:59 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEUAGD4T1Nbsma4/2dsb2JhbABZgwaCTKhMmVYCAoEkF3SCZhwjGIECJBOIAAHLMY1+ZIQ/AQOOaIoFAYpqh2ODMzuBLA
Date: Thu, 17 Apr 2014 17:51:06 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/f2fs/checkpoint.c: add static to get_max_meta_blks
Message-Id: <20140417175106.4a4513c8df1304bdb8519a63@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

inline get_max_meta_blks is only used in checkpoint.c
Use standard static inline format.

Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/f2fs/checkpoint.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 4aa521a..45c087c 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -73,7 +73,7 @@ out:
 	return page;
 }
 
-inline int get_max_meta_blks(struct f2fs_sb_info *sbi, int type)
+static inline int get_max_meta_blks(struct f2fs_sb_info *sbi, int type)
 {
 	switch (type) {
 	case META_NAT:
-- 
1.8.4.5

