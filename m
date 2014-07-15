Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273AbaGOT01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:26:27 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:49986 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932850AbaGOT0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:26:25 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao0RANx/xVNbsm9N/2dsb2JhbABZgw6BKaw8CwUBbpQzh02BEBd1hAsCJC8jgQIHETeILgMVAcMUDYcLF4V7hyOCLR2ELQWQH4gNbIIAi1mCMIYcg0Y7Lw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Artem Bityutskiy <dedekind1@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mtd@lists.infradead.org
Subject: [PATCH 1/1] fs/ubifs/super.c: replace seq_printf by seq_puts
Date: Tue, 15 Jul 2014 21:26:35 +0200
Message-Id: <1405452395-9296-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warnings:
"WARNING: Prefer seq_puts to seq_printf"

Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mtd@lists.infradead.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ubifs/super.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 3904c85..e5bd068 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -424,19 +424,19 @@ static int ubifs_show_options(struct seq_file *s, struct dentry *root)
 	struct ubifs_info *c = root->d_sb->s_fs_info;
 
 	if (c->mount_opts.unmount_mode == 2)
-		seq_printf(s, ",fast_unmount");
+		seq_puts(s, ",fast_unmount");
 	else if (c->mount_opts.unmount_mode == 1)
-		seq_printf(s, ",norm_unmount");
+		seq_puts(s, ",norm_unmount");
 
 	if (c->mount_opts.bulk_read == 2)
-		seq_printf(s, ",bulk_read");
+		seq_puts(s, ",bulk_read");
 	else if (c->mount_opts.bulk_read == 1)
-		seq_printf(s, ",no_bulk_read");
+		seq_puts(s, ",no_bulk_read");
 
 	if (c->mount_opts.chk_data_crc == 2)
-		seq_printf(s, ",chk_data_crc");
+		seq_puts(s, ",chk_data_crc");
 	else if (c->mount_opts.chk_data_crc == 1)
-		seq_printf(s, ",no_chk_data_crc");
+		seq_puts(s, ",no_chk_data_crc");
 
 	if (c->mount_opts.override_compr) {
 		seq_printf(s, ",compr=%s",
-- 
1.8.4.5

