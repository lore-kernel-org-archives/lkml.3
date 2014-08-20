Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaHTIVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:21:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47000 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaHTIVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:21:14 -0400
Date: Wed, 20 Aug 2014 01:19:46 -0700
From: tip-bot for Pranith Kumar <tipbot@zytor.com>
Message-ID: <tip-8b06c55bdb8b402cb4814e83dc4b1cb245fcc9f5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        bobby.prani@gmail.com, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bobby.prani@gmail.com, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1407950893-32731-1-git-send-email-bobby.prani@gmail.com>
References: <1407950893-32731-1-git-send-email-bobby.prani@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Match declaration with definition
Git-Commit-ID: 8b06c55bdb8b402cb4814e83dc4b1cb245fcc9f5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b06c55bdb8b402cb4814e83dc4b1cb245fcc9f5
Gitweb:     http://git.kernel.org/tip/8b06c55bdb8b402cb4814e83dc4b1cb245fcc9f5
Author:     Pranith Kumar <bobby.prani@gmail.com>
AuthorDate: Wed, 13 Aug 2014 13:28:12 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 20 Aug 2014 09:47:19 +0200

sched: Match declaration with definition

Match the declaration of runqueues with the definition.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1407950893-32731-1-git-send-email-bobby.prani@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 579712f..4c2b87f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -647,7 +647,7 @@ static inline int cpu_of(struct rq *rq)
 #endif
 }
 
-DECLARE_PER_CPU(struct rq, runqueues);
+DECLARE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 
 #define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
 #define this_rq()		(&__get_cpu_var(runqueues))
