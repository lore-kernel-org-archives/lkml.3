Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbaDZIkZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 04:40:25 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:15777 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733AbaDZIkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 04:40:17 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtUQAFlwW1NXQCJ0/2dsb2JhbABZgwaCQKk/AQEDBAGZcQICgQ4XdIJmHCMYgQIkE4hFAcsDhVqIG2SEQAEDjnuKDwGKcodqgzM7gSw
Date: Sat, 26 Apr 2014 10:42:16 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
        "Dave.Kleikamp" <dave.kleikamp@oracle.com>
Subject: [PATCH 1/1] fs/jfs/jfs_logmgr.c: remove NULL assignment on static
Message-Id: <20140426104216.e949225ccf8b6a8896979000@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

static values are automatically initialized to NULL

Cc: Dave Kleikamp <shaggy@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/jfs/jfs_logmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 8d811e0..0acddf6 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -167,7 +167,7 @@ do {						\
  * Global list of active external journals
  */
 static LIST_HEAD(jfs_external_logs);
-static struct jfs_log *dummy_log = NULL;
+static struct jfs_log *dummy_log;
 static DEFINE_MUTEX(jfs_log_mutex);
 
 /*
-- 
1.8.4.5

