Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181AbaLPEWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 23:22:42 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:55465 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaLPEWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 23:22:41 -0500
Date: Mon, 15 Dec 2014 23:22:38 -0500
From: John de la Garza <john@jjdev.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH] rbtree: fix typo in comment
Message-ID: <20141216042236.GA18242@vega.jjdev.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: John de la Garza <john@jjdev.com>
---
 include/linux/rbtree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 57e75ae..fb31765 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -51,7 +51,7 @@ struct rb_root {
 
 #define RB_EMPTY_ROOT(root)  ((root)->rb_node == NULL)
 
-/* 'empty' nodes are nodes that are known not to be inserted in an rbree */
+/* 'empty' nodes are nodes that are known not to be inserted in an rbtree */
 #define RB_EMPTY_NODE(node)  \
 	((node)->__rb_parent_color == (unsigned long)(node))
 #define RB_CLEAR_NODE(node)  \
-- 
2.1.1

