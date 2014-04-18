Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbaDRNJa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:09:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38873 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaDRNJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:09:22 -0400
Date: Fri, 18 Apr 2014 06:08:33 -0700
From: "tip-bot for Yan, Zheng" <tipbot@zytor.com>
Message-ID: <tip-8588a2bbddc524325d84d1d6996758e9242e4ffc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        zheng.z.yan@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, zheng.z.yan@intel.com,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1395133004-23205-2-git-send-email-zheng.z.yan@intel.com>
References: <1395133004-23205-2-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] hrtimer: Export __hrtimer_start_range_ns()
Git-Commit-ID: 8588a2bbddc524325d84d1d6996758e9242e4ffc
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

Commit-ID:  8588a2bbddc524325d84d1d6996758e9242e4ffc
Gitweb:     http://git.kernel.org/tip/8588a2bbddc524325d84d1d6996758e9242e4ffc
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Tue, 18 Mar 2014 16:56:42 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 12:54:46 +0200

hrtimer: Export __hrtimer_start_range_ns()

Export __hrtimer_start_range_ns() to allow building perf Intel uncore
driver as a module.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1395133004-23205-2-git-send-email-zheng.z.yan@intel.com
Cc: eranian@google.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/hrtimer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index d55092c..53d2682 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1017,6 +1017,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(__hrtimer_start_range_ns);
 
 /**
  * hrtimer_start_range_ns - (re)start an hrtimer on the current CPU
