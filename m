Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab3ENS1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 14:27:54 -0400
Received: from relay1.sgi.com ([192.48.179.29]:60146 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab3ENS1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 14:27:53 -0400
From: Nathan Zimmer <nzimmer@sgi.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Nathan Zimmer <nzimmer@sgi.com>
Subject: [PATCH] rbtree: remove unneeded include
Date: Tue, 14 May 2013 13:27:49 -0500
Message-Id: <1368556069-194880-1-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove an unnecessary include to kernel.h

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
---
 include/linux/rbtree.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 0022c1b..d2fdc6d 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -29,7 +29,6 @@
 #ifndef	_LINUX_RBTREE_H
 #define	_LINUX_RBTREE_H
 
-#include <linux/kernel.h>
 #include <linux/stddef.h>
 
 struct rb_node {
-- 
1.8.2.1

