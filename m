Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab3IWNh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 09:37:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43200 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab3IWNhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 09:37:55 -0400
Date: Mon, 23 Sep 2013 06:37:30 -0700
From: "tip-bot for Yan, Zheng" <tipbot@zytor.com>
Message-ID: <tip-cf3b425dd8d99e01214515a6754f9e69ecc6dce8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        zheng.z.yan@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        zheng.z.yan@intel.com, tglx@linutronix.de
In-Reply-To: <1379837953-17755-1-git-send-email-zheng.z.yan@intel.com>
References: <1379837953-17755-1-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/intel:
  Add model number for Avoton Silvermont
Git-Commit-ID: cf3b425dd8d99e01214515a6754f9e69ecc6dce8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 23 Sep 2013 06:37:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf3b425dd8d99e01214515a6754f9e69ecc6dce8
Gitweb:     http://git.kernel.org/tip/cf3b425dd8d99e01214515a6754f9e69ecc6dce8
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Sun, 22 Sep 2013 16:19:13 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 23 Sep 2013 10:22:00 +0200

perf/x86/intel: Add model number for Avoton Silvermont

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Cc: a.p.zijlstra@chello.nl
Cc: eranian@google.com
Cc: ak@linux.intel.com
Link: http://lkml.kernel.org/r/1379837953-17755-1-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 9db76c3..f31a165 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2325,6 +2325,7 @@ __init int intel_pmu_init(void)
 		break;
 
 	case 55: /* Atom 22nm "Silvermont" */
+	case 77: /* Avoton "Silvermont" */
 		memcpy(hw_cache_event_ids, slm_hw_cache_event_ids,
 			sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, slm_hw_cache_extra_regs,
