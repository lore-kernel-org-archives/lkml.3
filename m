Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab3LCSBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 13:01:12 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:39319 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab3LCSBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 13:01:09 -0500
From: Roman Kuznetsov <kuznetsov24@gmail.com>
To: viro@zeniv.linux.org.uk, eparis@redhat.com
Cc: linux-kernel@vger.kernel.org, Roman Kuznetsov <kuznetsov24@gmail.com>
Subject: [PATCH] kernel/audit_tree.c: fixed comment's coding style
Date: Tue,  3 Dec 2013 22:00:59 +0400
Message-Id: <1386093659-4843-1-git-send-email-kuznetsov24@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Roman Kuznetsov <kuznetsov24@gmail.com>
---
 kernel/audit_tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
index 43c307d..d9c39cf 100644
--- a/kernel/audit_tree.c
+++ b/kernel/audit_tree.c
@@ -296,7 +296,7 @@ static void untag_chunk(struct node *p)
 	goto out;
 
 Fallback:
-	// do the best we can
+	/* do the best we can */
 	spin_lock(&hash_lock);
 	if (owner->root == chunk) {
 		list_del_init(&owner->same_root);
-- 
1.8.1.2

