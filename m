Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab3HLKpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:45:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48428 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3HLKpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:45:51 -0400
Date: Mon, 12 Aug 2013 03:45:33 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-0499bd867bd17c0a88963551a1583b8efc7b03d7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1376007983-31616-1-git-send-email-andi@firstfloor.org>
References: <1376007983-31616-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86:
  Add Haswell ULT model number used in Macbook Air and other systems
Git-Commit-ID: 0499bd867bd17c0a88963551a1583b8efc7b03d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:45:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0499bd867bd17c0a88963551a1583b8efc7b03d7
Gitweb:     http://git.kernel.org/tip/0499bd867bd17c0a88963551a1583b8efc7b03d7
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Thu, 8 Aug 2013 17:26:23 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 12 Aug 2013 12:19:58 +0200

perf/x86: Add Haswell ULT model number used in Macbook Air and other systems

This one was missed earlier.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1376007983-31616-1-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index fbc9210..a45d8d4 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2270,6 +2270,7 @@ __init int intel_pmu_init(void)
 	case 70:
 	case 71:
 	case 63:
+	case 69:
 		x86_pmu.late_ack = true;
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids, sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
