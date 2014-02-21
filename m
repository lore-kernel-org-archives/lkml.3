Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbaBUVeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:34:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59391 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362AbaBUVeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:34:09 -0500
Date: Fri, 21 Feb 2014 13:33:30 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-02228c930672ec5476cf8ef84e4f3f45ab01b597@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <bcbf88bb25b5423e8d33b3aa0c2e829a23d56c76.1392103744.git.yangds.fnst@cn.fujitsu.com>
References: <bcbf88bb25b5423e8d33b3aa0c2e829a23d56c76.1392103744.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: prio:
  Add spaces before and after operator of '-'.
Git-Commit-ID: 02228c930672ec5476cf8ef84e4f3f45ab01b597
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

Commit-ID:  02228c930672ec5476cf8ef84e4f3f45ab01b597
Gitweb:     http://git.kernel.org/tip/02228c930672ec5476cf8ef84e4f3f45ab01b597
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Tue, 11 Feb 2014 15:34:48 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 21 Feb 2014 21:43:20 +0100

sched: prio: Add spaces before and after operator of '-'.

cc: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/bcbf88bb25b5423e8d33b3aa0c2e829a23d56c76.1392103744.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched/prio.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched/prio.h b/include/linux/sched/prio.h
index ac32258..1bf9935 100644
--- a/include/linux/sched/prio.h
+++ b/include/linux/sched/prio.h
@@ -37,7 +37,7 @@
  * can work with better when scaling various scheduler parameters,
  * it's a [ 0 ... 39 ] range.
  */
-#define USER_PRIO(p)		((p)-MAX_RT_PRIO)
+#define USER_PRIO(p)		((p) - MAX_RT_PRIO)
 #define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
 #define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
 
