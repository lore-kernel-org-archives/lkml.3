Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab3CKSR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:17:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44253 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3CKSRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:17:54 -0400
Date: Mon, 11 Mar 2013 11:16:39 -0700
From: tip-bot for Andrei Epure <tipbot@zytor.com>
Message-ID: <tip-660cc00f8c6f7a2e16c25918590b470e86de19ec@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        epure.andrei@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        epure.andrei@gmail.com, tglx@linutronix.de
In-Reply-To: <1362996200-2674-1-git-send-email-epure.andrei@gmail.com>
References: <1362996200-2674-1-git-send-email-epure.andrei@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Spelling fix
Git-Commit-ID: 660cc00f8c6f7a2e16c25918590b470e86de19ec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Mar 2013 11:16:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  660cc00f8c6f7a2e16c25918590b470e86de19ec
Gitweb:     http://git.kernel.org/tip/660cc00f8c6f7a2e16c25918590b470e86de19ec
Author:     Andrei Epure <epure.andrei@gmail.com>
AuthorDate: Mon, 11 Mar 2013 12:03:20 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Mar 2013 15:12:11 +0100

sched: Spelling fix

Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
Cc: trivial@kernel.org
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/1362996200-2674-1-git-send-email-epure.andrei@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9f23112..22bd9e6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -652,7 +652,7 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 /*
- * We calculate the vruntime slice of a to be inserted task
+ * We calculate the vruntime slice of a to-be-inserted task.
  *
  * vs = s/w
  */
