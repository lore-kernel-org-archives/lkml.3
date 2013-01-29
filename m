Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab3A2Jmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 04:42:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52381 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517Ab3A2Jmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 04:42:40 -0500
Date: Tue, 29 Jan 2013 01:42:24 -0800
From: tip-bot for Fengguang Wu <fengguang.wu@intel.com>
Message-ID: <tip-a4a607086d86d1315c4e2d9496bbe502e645bdd1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, fengguang.wu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        fengguang.wu@intel.com
In-Reply-To: <20130128234620.GA8524@localhost>
References: <20130128234620.GA8524@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/x86] perf/x86: Mark nhm_events_attrsas static
Git-Commit-ID: a4a607086d86d1315c4e2d9496bbe502e645bdd1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 01:42:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a4a607086d86d1315c4e2d9496bbe502e645bdd1
Gitweb:     http://git.kernel.org/tip/a4a607086d86d1315c4e2d9496bbe502e645bdd1
Author:     Fengguang Wu <fengguang.wu@intel.com>
AuthorDate: Tue, 29 Jan 2013 07:46:20 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 29 Jan 2013 08:51:46 +0100

perf/x86: Mark nhm_events_attrsas static

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Acked-by: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/20130128234620.GA8524@localhost
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 9d0d036..bb910bd 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -140,12 +140,12 @@ EVENT_ATTR_STR(mem-loads, mem_ld_nhm, "event=0x0b,umask=0x10,ldlat=3");
 EVENT_ATTR_STR(mem-loads, mem_ld_snb, "event=0xcd,umask=0x1,ldlat=3");
 EVENT_ATTR_STR(mem-stores, mem_st_snb, "event=0xcd,umask=0x2");
 
-struct attribute *nhm_events_attrs[] = {
+static struct attribute *nhm_events_attrs[] = {
 	EVENT_PTR(mem_ld_nhm),
 	NULL,
 };
 
-struct attribute *snb_events_attrs[] = {
+static struct attribute *snb_events_attrs[] = {
 	EVENT_PTR(mem_ld_snb),
 	EVENT_PTR(mem_st_snb),
 	NULL,
