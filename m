Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759740Ab3CGSvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 13:51:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759688Ab3CGSvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 13:51:16 -0500
From: Takashi Iwai <tiwai@suse.de>
To: =?UTF-8?q?J=C3=B6rn=20Engel?= <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 1/3] Export sched_setscheduler_nocheck()
Date: Thu,  7 Mar 2013 19:51:05 +0100
Message-Id: <1362682267-10188-2-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362682267-10188-1-git-send-email-tiwai@suse.de>
References: <s5hk3pjm4it.wl%tiwai@suse.de>
 <1362682267-10188-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... to be usable by modules.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 kernel/sched/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7f12624..370d97d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3993,6 +3993,7 @@ int sched_setscheduler_nocheck(struct task_struct *p, int policy,
 {
 	return __sched_setscheduler(p, policy, param, false);
 }
+EXPORT_SYMBOL_GPL(sched_setscheduler_nocheck);
 
 static int
 do_sched_setscheduler(pid_t pid, int policy, struct sched_param __user *param)
-- 
1.8.1.4

