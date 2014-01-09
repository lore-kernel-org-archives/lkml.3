Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbaAIOUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 09:20:31 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:52607 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789AbaAIOUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 09:20:03 -0500
From: Jeff Layton <jlayton@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: nfs-ganesha-devel@lists.sourceforge.net, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 02/14] locks: clean up comment typo
Date: Thu,  9 Jan 2014 09:19:35 -0500
Message-Id: <1389277187-18211-3-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389277187-18211-1-git-send-email-jlayton@redhat.com>
References: <1389277187-18211-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/locks.c b/fs/locks.c
index 2cfeea6..5e28612 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -581,7 +581,7 @@ static void locks_delete_block(struct file_lock *waiter)
  * it seems like the reasonable thing to do.
  *
  * Must be called with both the i_lock and blocked_lock_lock held. The fl_block
- * list itself is protected by the file_lock_list, but by ensuring that the
+ * list itself is protected by the blocked_lock_lock, but by ensuring that the
  * i_lock is also held on insertions we can avoid taking the blocked_lock_lock
  * in some cases when we see that the fl_block list is empty.
  */
-- 
1.8.4.2

