Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab3ILSGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:06:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37983 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955Ab3ILSGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:06:39 -0400
Date: Thu, 12 Sep 2013 11:06:17 -0700
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-7f2ee91f54fb56071f97bde1ef7ba7ba0d58dfe5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel: Clean up EVENT_ATTR_STR() muck
Git-Commit-ID: 7f2ee91f54fb56071f97bde1ef7ba7ba0d58dfe5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 12 Sep 2013 11:06:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7f2ee91f54fb56071f97bde1ef7ba7ba0d58dfe5
Gitweb:     http://git.kernel.org/tip/7f2ee91f54fb56071f97bde1ef7ba7ba0d58dfe5
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Thu, 12 Sep 2013 19:17:00 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 12 Sep 2013 19:17:50 +0200

perf/x86/intel: Clean up EVENT_ATTR_STR() muck

Make the code a bit more readable by removing stray whitespaces et al.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: http://lkml.kernel.org/n/tip-lzEnychz1ylqy8zjenxOmeht@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 35 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index ec70d0c..353b7a3 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -190,9 +190,9 @@ static struct extra_reg intel_snbep_extra_regs[] __read_mostly = {
 	EVENT_EXTRA_END
 };
 
-EVENT_ATTR_STR(mem-loads, mem_ld_nhm, "event=0x0b,umask=0x10,ldlat=3");
-EVENT_ATTR_STR(mem-loads, mem_ld_snb, "event=0xcd,umask=0x1,ldlat=3");
-EVENT_ATTR_STR(mem-stores, mem_st_snb, "event=0xcd,umask=0x2");
+EVENT_ATTR_STR(mem-loads,	mem_ld_nhm,	"event=0x0b,umask=0x10,ldlat=3");
+EVENT_ATTR_STR(mem-loads,	mem_ld_snb,	"event=0xcd,umask=0x1,ldlat=3");
+EVENT_ATTR_STR(mem-stores,	mem_st_snb,	"event=0xcd,umask=0x2");
 
 struct attribute *nhm_events_attrs[] = {
 	EVENT_PTR(mem_ld_nhm),
@@ -2223,23 +2223,22 @@ static __init void intel_nehalem_quirk(void)
 	}
 }
 
-EVENT_ATTR_STR(mem-loads,      mem_ld_hsw,     "event=0xcd,umask=0x1,ldlat=3");
-EVENT_ATTR_STR(mem-stores,     mem_st_hsw,     "event=0xd0,umask=0x82")
+EVENT_ATTR_STR(mem-loads,	mem_ld_hsw,	"event=0xcd,umask=0x1,ldlat=3");
+EVENT_ATTR_STR(mem-stores,	mem_st_hsw,	"event=0xd0,umask=0x82")
 
 /* Haswell special events */
-EVENT_ATTR_STR(tx-start,        tx_start,       "event=0xc9,umask=0x1");
-EVENT_ATTR_STR(tx-commit,       tx_commit,      "event=0xc9,umask=0x2");
-EVENT_ATTR_STR(tx-abort,        tx_abort,	"event=0xc9,umask=0x4");
-EVENT_ATTR_STR(tx-capacity,     tx_capacity,	"event=0x54,umask=0x2");
-EVENT_ATTR_STR(tx-conflict,     tx_conflict,	"event=0x54,umask=0x1");
-EVENT_ATTR_STR(el-start,        el_start,       "event=0xc8,umask=0x1");
-EVENT_ATTR_STR(el-commit,       el_commit,      "event=0xc8,umask=0x2");
-EVENT_ATTR_STR(el-abort,        el_abort,	"event=0xc8,umask=0x4");
-EVENT_ATTR_STR(el-capacity,     el_capacity,    "event=0x54,umask=0x2");
-EVENT_ATTR_STR(el-conflict,     el_conflict,    "event=0x54,umask=0x1");
-EVENT_ATTR_STR(cycles-t,        cycles_t,       "event=0x3c,in_tx=1");
-EVENT_ATTR_STR(cycles-ct,       cycles_ct,
-					"event=0x3c,in_tx=1,in_tx_cp=1");
+EVENT_ATTR_STR(tx-start,	tx_start,	"event=0xc9,umask=0x1");
+EVENT_ATTR_STR(tx-commit,	tx_commit,	"event=0xc9,umask=0x2");
+EVENT_ATTR_STR(tx-abort,	tx_abort,	"event=0xc9,umask=0x4");
+EVENT_ATTR_STR(tx-capacity,	tx_capacity,	"event=0x54,umask=0x2");
+EVENT_ATTR_STR(tx-conflict,	tx_conflict,	"event=0x54,umask=0x1");
+EVENT_ATTR_STR(el-start,	el_start,	"event=0xc8,umask=0x1");
+EVENT_ATTR_STR(el-commit,	el_commit,	"event=0xc8,umask=0x2");
+EVENT_ATTR_STR(el-abort,	el_abort,	"event=0xc8,umask=0x4");
+EVENT_ATTR_STR(el-capacity,	el_capacity,	"event=0x54,umask=0x2");
+EVENT_ATTR_STR(el-conflict,	el_conflict,	"event=0x54,umask=0x1");
+EVENT_ATTR_STR(cycles-t,	cycles_t,	"event=0x3c,in_tx=1");
+EVENT_ATTR_STR(cycles-ct,	cycles_ct,	"event=0x3c,in_tx=1,in_tx_cp=1");
 
 static struct attribute *hsw_events_attrs[] = {
 	EVENT_PTR(tx_start),
