Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab3BRIdO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 03:33:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58637 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab3BRIdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 03:33:13 -0500
Date: Mon, 18 Feb 2013 00:31:39 -0800
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-e341c59c6da2aa90719955809d9efc3cd41e6b49@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        williams@redhat.com, peterz@infradead.org, rostedt@goodmis.org,
        tglx@linutronix.de, fengguang.wu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, williams@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, fengguang.wu@intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt: Add <linux/sched/rt.h> header to <
 linux/init_task.h>
Git-Commit-ID: e341c59c6da2aa90719955809d9efc3cd41e6b49
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 18 Feb 2013 00:31:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e341c59c6da2aa90719955809d9efc3cd41e6b49
Gitweb:     http://git.kernel.org/tip/e341c59c6da2aa90719955809d9efc3cd41e6b49
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Sat, 16 Feb 2013 09:46:48 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 18 Feb 2013 09:02:28 +0100

sched/rt: Add <linux/sched/rt.h> header to <linux/init_task.h>

IA64 relied on it through sched.h inclusion:

  arch/ia64/kernel/init_task.c:38:11: error: 'MAX_PRIO' undeclared here (not in a function)
  arch/ia64/kernel/init_task.c:38:11: error: 'RR_TIMESLICE' undeclared here (not in a function)

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-xaan1twswggedMR0airtpjui@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/init_task.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index cc898b8..5cd0f09 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -12,6 +12,7 @@
 #include <linux/securebits.h>
 #include <linux/seqlock.h>
 #include <net/net_namespace.h>
+#include <linux/sched/rt.h>
 
 #ifdef CONFIG_SMP
 # define INIT_PUSHABLE_TASKS(tsk)					\
