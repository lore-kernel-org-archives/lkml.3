Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353Ab3F0JDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:03:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46098 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab3F0JDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:03:36 -0400
Date: Thu, 27 Jun 2013 02:02:59 -0700
From: tip-bot for Alex Shi <tipbot@zytor.com>
Message-ID: <tip-a9cef46a10cc1b84bf2cdf4060766d858c0439d8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, pjt@google.com, alex.shi@intel.com,
        vincent.guittot@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pjt@google.com, peterz@infradead.org, alex.shi@intel.com,
        vincent.guittot@linaro.org, tglx@linutronix.de
In-Reply-To: <1371694737-29336-13-git-send-email-alex.shi@intel.com>
References: <1371694737-29336-13-git-send-email-alex.shi@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/tg: Remove tg.load_weight
Git-Commit-ID: a9cef46a10cc1b84bf2cdf4060766d858c0439d8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 27 Jun 2013 02:03:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a9cef46a10cc1b84bf2cdf4060766d858c0439d8
Gitweb:     http://git.kernel.org/tip/a9cef46a10cc1b84bf2cdf4060766d858c0439d8
Author:     Alex Shi <alex.shi@intel.com>
AuthorDate: Thu, 20 Jun 2013 10:18:56 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Jun 2013 10:07:43 +0200

sched/tg: Remove tg.load_weight

Since no one use it.

Signed-off-by: Alex Shi <alex.shi@intel.com>
Reviewed-by: Paul Turner <pjt@google.com>
Tested-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1371694737-29336-13-git-send-email-alex.shi@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/sched.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 7059919..ef0a7b2 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -148,7 +148,6 @@ struct task_group {
 	struct cfs_rq **cfs_rq;
 	unsigned long shares;
 
-	atomic_t load_weight;
 #ifdef	CONFIG_SMP
 	atomic_long_t load_avg;
 	atomic_t runnable_avg;
