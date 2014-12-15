Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214AbaLODEm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 22:04:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbaLODEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 22:04:35 -0500
From: Masatake YAMATO <yamato@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, yamato@redhat.com
Subject: [PATCH] dynamic_debug: Fix a typo in comment
Date: Mon, 15 Dec 2014 12:04:16 +0900
Message-Id: <1418612656-14823-1-git-send-email-yamato@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Masatake YAMATO <yamato@redhat.com>
---
 lib/dynamic_debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 527799d..d8f3d31 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -641,7 +641,7 @@ static __init int ddebug_setup_query(char *str)
 __setup("ddebug_query=", ddebug_setup_query);
 
 /*
- * File_ops->write method for <debugfs>/dynamic_debug/conrol.  Gathers the
+ * File_ops->write method for <debugfs>/dynamic_debug/control.  Gathers the
  * command text from userspace, parses and executes it.
  */
 #define USER_BUF_PAGE 4096
-- 
1.9.3

