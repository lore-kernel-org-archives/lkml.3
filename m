Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab3IHPXT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 11:23:19 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:59361 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab3IHPXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 11:23:18 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shaohua Li <shli@kernel.org>,
        Wang YanQing <udknight@gmail.com>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        liguang <lig.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v1 3/3] SMP, trivial: remove unused code from smp_boot.h
Date: Sun,  8 Sep 2013 23:22:25 +0800
Message-Id: <1378653745-8343-3-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378653745-8343-1-git-send-email-liuj97@gmail.com>
References: <1378653745-8343-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Function smpboot_thread_schedule() is never defined or used,
so remove it from smp_boot.h.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Wang YanQing <udknight@gmail.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: liguang <lig.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
---
 include/linux/smpboot.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/smpboot.h b/include/linux/smpboot.h
index 13e9296..d600afb 100644
--- a/include/linux/smpboot.h
+++ b/include/linux/smpboot.h
@@ -47,6 +47,5 @@ struct smp_hotplug_thread {
 
 int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread);
 void smpboot_unregister_percpu_thread(struct smp_hotplug_thread *plug_thread);
-int smpboot_thread_schedule(void);
 
 #endif
-- 
1.8.1.2

