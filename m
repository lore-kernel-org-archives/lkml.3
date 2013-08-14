Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab3HNM0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 08:26:45 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:40168 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759806Ab3HNMZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 08:25:56 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 1/3] locks: clean up comment typo
Date: Wed, 14 Aug 2013 08:25:47 -0400
Message-Id: <1376483149-7633-2-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376483149-7633-1-git-send-email-jlayton@redhat.com>
References: <1376483149-7633-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/locks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/locks.c b/fs/locks.c
index a99adec..9f28359 100644
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
1.8.3.1

