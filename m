Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbbAAIzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 03:55:05 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:54092 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbbAAIzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 03:55:03 -0500
Message-ID: <54A50B62.70101@gmail.com>
Date: Thu, 01 Jan 2015 17:54:58 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] fix misspelling (rbree -> rbtree)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akira Hayakawa <ruby.wktk@gmail.com>
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
1.8.5.5

