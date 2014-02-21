Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbaBUSOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 13:14:11 -0500
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:51148 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755136AbaBUSOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 13:14:07 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnQkAIuWB1NXQysu/2dsb2JhbABaKIJeO1GCN6VUmDQCAoEOF3SCZhwjGIECQIgAAQMFy2WOF00dhCIEiUaObQGSJ4M6L4Et
Date: Fri, 21 Feb 2014 18:15:31 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: rdunlap <rdunlap@infradead.org>
Subject: [RFC 1/1] fs: Quota: Refresh Kconfig
Message-Id: <20140221181531.cc488ebae498cd20124a4c32@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update Kconfig with a complete list of supported filesystems.

(Other local filesystems concerned by quota and/or journaled quotas ?)

---
 fs/quota/Kconfig | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/quota/Kconfig b/fs/quota/Kconfig
index 880fd98..7339003 100644
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
+	  Both ext3 and ext4 also support journaled quotas for which you don't
+	  need to run quotacheck(8) after an unclean shutdown.
 	  For further details, read the Quota mini-HOWTO, available from
 	  <http://www.tldp.org/docs.html#howto>, or the documentation provided
 	  with the quota tools. Probably the quota support is only useful for
-- 
1.8.1.4

