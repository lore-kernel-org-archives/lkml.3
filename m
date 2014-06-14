Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbaFNSe0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 14:34:26 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:36872 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaFNSeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 14:34:25 -0400
From: Nick <xerofoify@gmail.com>
To: cody@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org, sjenning@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Fix comments in rbtree.c
Date: Sat, 14 Jun 2014 14:34:20 -0400
Message-Id: <1402770860-4504-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick <xerofoify@gmail.com>
---
 lib/rbtree.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/rbtree.c b/lib/rbtree.c
index 65f4eff..c66370c 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -101,11 +101,10 @@ __rb_insert(struct rb_node *node, struct rb_root *root,
 				 *      / \          / \
 				 *     p   u  -->   P   U
 				 *    /            /
-				 *   n            N
+				 *   n            n
 				 *
 				 * However, since g's parent might be red, and
 				 * 4) does not allow this, we need to recurse
-				 * at g.
 				 */
 				rb_set_parent_color(tmp, gparent, RB_BLACK);
 				rb_set_parent_color(parent, gparent, RB_BLACK);
-- 
1.9.1

