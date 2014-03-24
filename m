Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbaCXUh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:37:27 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:41686 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbaCXUhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:37:16 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH trivial 2/3] workqueue: Spelling s/instensive/intensive/
Date: Mon, 24 Mar 2014 21:37:02 +0100
Message-Id: <1395693423-5134-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395693423-5134-1-git-send-email-geert@linux-m68k.org>
References: <1395693423-5134-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 704f4f652d0a..7ee010c0640c 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -305,7 +305,7 @@ enum {
 	WQ_FREEZABLE		= 1 << 2, /* freeze during suspend */
 	WQ_MEM_RECLAIM		= 1 << 3, /* may be used for memory reclaim */
 	WQ_HIGHPRI		= 1 << 4, /* high priority */
-	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */
+	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu intensive workqueue */
 	WQ_SYSFS		= 1 << 6, /* visible in sysfs, see wq_sysfs_register() */
 
 	/*
-- 
1.7.9.5

