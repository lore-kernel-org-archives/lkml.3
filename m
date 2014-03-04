Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619AbaCDIJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 03:09:47 -0500
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:40189 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756295AbaCDIJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 03:09:38 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsMjAHaJFVNXQz2f/2dsb2JhbABaKIJeO1GCN6VOmGkCAoEcF3SCZhwjGIECJBMJh3QBAwXMNY4MTYQ/BIlJjnIBkiuBP4F7L4Et
Date: Tue, 4 Mar 2014 08:11:07 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: jack <jack@suse.cz>, akpm <akpm@linux-foundation.org>,
        rdunlap <rdunlap@infradead.org>
Subject: [PATCH 1/1] fs/quota/Kconfig: Update filesystems
Message-Id: <20140304081107.da00303af01803f0f894728a@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update Kconfig with a complete list of supported filesystems.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/quota/Kconfig | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/quota/Kconfig b/fs/quota/Kconfig
index 880fd98..c51df1d 100644
--- a/fs/quota/Kconfig
+++ b/fs/quota/Kconfig
@@ -8,9 +8,10 @@ config QUOTA
 	help
 	  If you say Y here, you will be able to set per user limits for disk
 	  usage (also called disk quotas). Currently, it works for the
-	  ext2, ext3, and reiserfs file system. ext3 also supports journalled
-	  quotas for which you don't need to run quotacheck(8) after an unclean
-	  shutdown.
+	  ext2, ext3, ext4, jfs, ocfs2 and reiserfs file systems.
+	  Note that gfs2 and xfs use their own quota system.
+	  Ext3, ext4 and reiserfs also support journaled quotas for which
+	  you don't need to run quotacheck(8) after an unclean shutdown.
 	  For further details, read the Quota mini-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>, or the documentation provided
 	  with the quota tools. Probably the quota support is only useful for
-- 
1.8.1.4

