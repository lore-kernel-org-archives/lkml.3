Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964993Ab3FSSqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:46:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40218 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935128Ab3FSSmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:42:22 -0400
Date: Wed, 19 Jun 2013 11:41:52 -0700
From: "tip-bot for Yan, Zheng" <tipbot@zytor.com>
Message-ID: <tip-b2fa344d0c275ea4436bfc3a97708f2c938ac0eb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, zheng.z.yan@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        zheng.z.yan@intel.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1370421025-10986-1-git-send-email-zheng.z.yan@intel.com>
References: <1370421025-10986-1-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel: Fix sparse warning
Git-Commit-ID: b2fa344d0c275ea4436bfc3a97708f2c938ac0eb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:41:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2fa344d0c275ea4436bfc3a97708f2c938ac0eb
Gitweb:     http://git.kernel.org/tip/b2fa344d0c275ea4436bfc3a97708f2c938ac0eb
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Wed, 5 Jun 2013 16:30:25 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 13:04:55 +0200

perf/x86/intel: Fix sparse warning

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1370421025-10986-1-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index adabe6f..9dd9975 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -536,7 +536,7 @@ __snbep_cbox_get_constraint(struct intel_uncore_box *box, struct perf_event *eve
 	if (!uncore_box_is_fake(box))
 		reg1->alloc |= alloc;
 
-	return 0;
+	return NULL;
 fail:
 	for (; i >= 0; i--) {
 		if (alloc & (0x1 << i))
