Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbaIXPAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:00:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59829 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055AbaIXPAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:00:14 -0400
Date: Wed, 24 Sep 2014 07:59:13 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-d86c8eaf95700d932bdfa8a4f7b4e6d28949fd84@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1409683455-29168-2-git-send-email-andi@firstfloor.org>
References: <1409683455-29168-2-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel: Document all Haswell models
Git-Commit-ID: d86c8eaf95700d932bdfa8a4f7b4e6d28949fd84
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

Commit-ID:  d86c8eaf95700d932bdfa8a4f7b4e6d28949fd84
Gitweb:     http://git.kernel.org/tip/d86c8eaf95700d932bdfa8a4f7b4e6d28949fd84
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Tue, 2 Sep 2014 11:44:12 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 14:48:16 +0200

perf/x86/intel: Document all Haswell models

Add names for each Haswell model as requested by Peter.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: eranian@google.com
Link: http://lkml.kernel.org/r/1409683455-29168-2-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index f962e26..7c9f78e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2540,10 +2540,10 @@ __init int intel_pmu_init(void)
 		break;
 
 
-	case 60: /* 22nm Haswell */
-	case 63:
-	case 69:
-	case 70:
+	case 60: /* 22nm Haswell Core */
+	case 63: /* 22nm Haswell Server */
+	case 69: /* 22nm Haswell ULT */
+	case 70: /* 22nm Haswell + GT3e (Intel Iris Pro graphics) */
 		x86_pmu.late_ack = true;
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids, sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
