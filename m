Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaD1Diz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 23:38:55 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:64586 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbaD1Diy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 23:38:54 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] block: Fix format string mismatch in cfq-iosched.c
Date: Mon, 28 Apr 2014 12:38:34 +0900
Message-Id: <1398656314-19068-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.0.0.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix format string mismatch in cfq_var_show()

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 block/cfq-iosched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 5063a0b..22dffeb 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -4460,7 +4460,7 @@ out_free:
 static ssize_t
 cfq_var_show(unsigned int var, char *page)
 {
-	return sprintf(page, "%d\n", var);
+	return sprintf(page, "%u\n", var);
 }
 
 static ssize_t
-- 
2.0.0.rc1

