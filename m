Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522AbaDRNJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:09:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38903 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbaDRNJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:09:46 -0400
Date: Fri, 18 Apr 2014 06:08:47 -0700
From: "tip-bot for Yan, Zheng" <tipbot@zytor.com>
Message-ID: <tip-4a3dc121d3c370625575247bf714db3f601d83e9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        zheng.z.yan@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        zheng.z.yan@intel.com, tglx@linutronix.de
In-Reply-To: <1395133004-23205-3-git-send-email-zheng.z.yan@intel.com>
References: <1395133004-23205-3-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Export perf_assign_events()
Git-Commit-ID: 4a3dc121d3c370625575247bf714db3f601d83e9
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

Commit-ID:  4a3dc121d3c370625575247bf714db3f601d83e9
Gitweb:     http://git.kernel.org/tip/4a3dc121d3c370625575247bf714db3f601d83e9
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Tue, 18 Mar 2014 16:56:43 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 Apr 2014 12:54:46 +0200

perf/x86: Export perf_assign_events()

export perf_assign_events to allow building perf Intel uncore driver
as module

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1395133004-23205-3-git-send-email-zheng.z.yan@intel.com
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: eranian@google.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ae407f7..89f3b7c 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -721,6 +721,7 @@ int perf_assign_events(struct perf_event **events, int n,
 
 	return sched.state.unassigned;
 }
+EXPORT_SYMBOL_GPL(perf_assign_events);
 
 int x86_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 {
