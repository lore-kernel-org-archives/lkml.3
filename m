Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbaKPMdh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:33:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35547 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbaKPMde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:33:34 -0500
Date: Sun, 16 Nov 2014 04:33:02 -0800
From: "tip-bot for pang.xunlei" <tipbot@zytor.com>
Message-ID: <tip-74e6942fbc7f52320c2fc900a9a6b0a315927915@git.kernel.org>
Cc: rostedt@goodmis.org, juri.lelli@gmail.com, pang.xunlei@linaro.org,
        tglx@linutronix.de, mingo@kernel.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, peterz@infradead.org
Reply-To: rostedt@goodmis.org, juri.lelli@gmail.com, pang.xunlei@linaro.org,
        tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org
In-Reply-To: <1415260327-30465-1-git-send-email-pang.xunlei@linaro.org>
References: <1415260327-30465-1-git-send-email-pang.xunlei@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/cpupri:
  Remove unnecessary definitions in cpupri.h
Git-Commit-ID: 74e6942fbc7f52320c2fc900a9a6b0a315927915
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

Commit-ID:  74e6942fbc7f52320c2fc900a9a6b0a315927915
Gitweb:     http://git.kernel.org/tip/74e6942fbc7f52320c2fc900a9a6b0a315927915
Author:     pang.xunlei <pang.xunlei@linaro.org>
AuthorDate: Thu, 6 Nov 2014 15:52:01 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 10:58:59 +0100

sched/cpupri: Remove unnecessary definitions in cpupri.h

Actually, cpupri_set() and cpupri_init() can never be used without
CONFIG_SMP.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: "pang.xunlei" <pang.xunlei@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1415260327-30465-1-git-send-email-pang.xunlei@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/cpupri.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/kernel/sched/cpupri.h b/kernel/sched/cpupri.h
index 6b03334..63cbb9c 100644
--- a/kernel/sched/cpupri.h
+++ b/kernel/sched/cpupri.h
@@ -26,9 +26,6 @@ int  cpupri_find(struct cpupri *cp,
 void cpupri_set(struct cpupri *cp, int cpu, int pri);
 int cpupri_init(struct cpupri *cp);
 void cpupri_cleanup(struct cpupri *cp);
-#else
-#define cpupri_set(cp, cpu, pri) do { } while (0)
-#define cpupri_init() do { } while (0)
 #endif
 
 #endif /* _LINUX_CPUPRI_H */
