Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbaECUWZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 16:22:25 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:25636 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752193AbaECUWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 16:22:24 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjoTAEdPZVNXQD6Q/2dsb2JhbABZgwaDPagrCgUBmgYCAoERF3SCZhwjGIECJBOIRQHKAYVWiHyERgEDjxqKGQGKfod2gzY7
Date: Sat, 3 May 2014 22:22:14 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, reiserfs-devel@kernel.org
Subject: [PATCH 1/1] fs/reiserfs/stree.c: remove obsolete __constant
Message-Id: <20140503222214.fb61bef8df025dea21351cc7@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__constant_cpu_to_le32 converted to cpu_to_le32

Cc: reiserfs-devel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/reiserfs/stree.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index b14706a..615cd9a 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -228,10 +228,10 @@ const struct reiserfs_key MIN_KEY = { 0, 0, {{0, 0},} };
 
 /* Maximal possible key. It is never in the tree. */
 static const struct reiserfs_key MAX_KEY = {
-	__constant_cpu_to_le32(0xffffffff),
-	__constant_cpu_to_le32(0xffffffff),
-	{{__constant_cpu_to_le32(0xffffffff),
-	  __constant_cpu_to_le32(0xffffffff)},}
+	cpu_to_le32(0xffffffff),
+	cpu_to_le32(0xffffffff),
+	{{cpu_to_le32(0xffffffff),
+	  cpu_to_le32(0xffffffff)},}
 };
 
 /* Get delimiting key of the buffer by looking for it in the buffers in the path, starting from the bottom
-- 
1.8.4.5

