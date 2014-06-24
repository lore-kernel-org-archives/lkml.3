Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaFXInL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 04:43:11 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:54391 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751855AbaFXInI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 04:43:08 -0400
Message-ID: <1403599386.1960.3.camel@x220>
Subject: [PATCH] [TRIVIAL] fs: Fix comment typo 'CONFIG_LBADF'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 24 Jun 2014 10:43:06 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2014 08:43:06.0324 (UTC) FILETIME=[51883940:01CF8F88]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 fs/stack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/stack.c b/fs/stack.c
index 5b5388250e29..a54e33ed10f1 100644
--- a/fs/stack.c
+++ b/fs/stack.c
@@ -44,7 +44,7 @@ void fsstack_copy_inode_size(struct inode *dst, struct inode *src)
 	 * include/linux/fs.h).  We don't necessarily hold i_mutex when this
 	 * is called, so take i_lock for that case.
 	 *
-	 * And if CONFIG_LBADF (on 32-bit), continue our effort to keep the
+	 * And if CONFIG_LBDAF (on 32-bit), continue our effort to keep the
 	 * two halves of i_blocks in sync despite SMP or PREEMPT: use i_lock
 	 * for that case too, and do both at once by combining the tests.
 	 *
-- 
1.9.3

