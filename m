Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbaDZKqZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 06:46:25 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:58926 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751807AbaDZKqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 06:46:24 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjEQAMuNW1NbsljQ/2dsb2JhbABZgwaCQKk+AQEBAQEEAZI9hzUCAoELF3SCLQI3HCMYcREkE4hFAcsMhVqIG2SEQAEDjnyHNoJZAYpzh2uDMzuBLA
Date: Sat, 26 Apr 2014 12:48:24 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
        Phillip Lougher <phillip@squashfs.org.uk>
Subject: [PATCH 1/1] fs/squashfs/squashfs.h: replace pr_warning by pr_warn
Message-Id: <20140426124824.c5da392127327c54e1cb9b5a@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the last pr_warning callsite in fs branch

Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: squashfs-devel@lists.sourceforge.net
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/squashfs/squashfs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
index 9e1bb79..887d6d2 100644
--- a/fs/squashfs/squashfs.h
+++ b/fs/squashfs/squashfs.h
@@ -25,7 +25,7 @@
 
 #define ERROR(s, args...)	pr_err("SQUASHFS error: "s, ## args)
 
-#define WARNING(s, args...)	pr_warning("SQUASHFS: "s, ## args)
+#define WARNING(s, args...)	pr_warn("SQUASHFS: "s, ## args)
 
 /* block.c */
 extern int squashfs_read_data(struct super_block *, u64, int, u64 *,
-- 
1.8.4.5

