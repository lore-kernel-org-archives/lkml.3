Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226AbbA1VTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:19:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762142AbbA1UuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:21 -0500
Date: Wed, 28 Jan 2015 06:29:45 -0800
From: tip-bot for Kan Liang <tipbot@zytor.com>
Message-ID: <tip-ef454caeb740ee4e1b89aeb7f7692d5ddffb6830@git.kernel.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
        torvalds@linux-foundation.org, kan.liang@intel.com,
        peterz@infradead.org, acme@kernel.org, tglx@linutronix.de
Reply-To: acme@kernel.org, tglx@linutronix.de, peterz@infradead.org,
        torvalds@linux-foundation.org, kan.liang@intel.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org
In-Reply-To: <1421913053-99803-1-git-send-email-kan.liang@intel.com>
References: <1421913053-99803-1-git-send-email-kan.liang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/intel: Add model number for Airmont
Git-Commit-ID: ef454caeb740ee4e1b89aeb7f7692d5ddffb6830
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

Commit-ID:  ef454caeb740ee4e1b89aeb7f7692d5ddffb6830
Gitweb:     http://git.kernel.org/tip/ef454caeb740ee4e1b89aeb7f7692d5ddffb6830
Author:     Kan Liang <kan.liang@intel.com>
AuthorDate: Thu, 22 Jan 2015 07:50:53 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 28 Jan 2015 13:17:32 +0100

perf/x86/intel: Add model number for Airmont

Intel Airmont supports the same architectural and non-architectural
performance monitoring events as Silvermont.

Signed-off-by: Kan Liang <kan.liang@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1421913053-99803-1-git-send-email-kan.liang@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 944bf01..498b6d9 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2431,6 +2431,7 @@ __init int intel_pmu_init(void)
 		break;
 
 	case 55: /* 22nm Atom "Silvermont"                */
+	case 76: /* 14nm Atom "Airmont"                   */
 	case 77: /* 22nm Atom "Silvermont Avoton/Rangely" */
 		memcpy(hw_cache_event_ids, slm_hw_cache_event_ids,
 			sizeof(hw_cache_event_ids));
