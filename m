Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaKDQIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:08:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59356 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbaKDQII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:08:08 -0500
Date: Tue, 4 Nov 2014 08:07:18 -0800
From: "tip-bot for Peter Zijlstra (Intel)" <tipbot@zytor.com>
Message-ID: <tip-be0bftjh8yfm4uvmvtf3yi87@git.kernel.org>
Cc: peterz@infradead.org, torvalds@linux-foundation.org, tglx@linutronix.de,
        ak@linux.intel.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Reply-To: mingo@kernel.org, peterz@infradead.org,
        torvalds@linux-foundation.org, tglx@linutronix.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86: Fix embarrasing typo
Git-Commit-ID: ce5686d4ed12158599d2042a6c8659254ed263ce
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

Commit-ID:  ce5686d4ed12158599d2042a6c8659254ed263ce
Gitweb:     http://git.kernel.org/tip/ce5686d4ed12158599d2042a6c8659254ed263ce
Author:     Peter Zijlstra (Intel) <peterz@infradead.org>
AuthorDate: Wed, 29 Oct 2014 11:17:04 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 4 Nov 2014 07:06:58 +0100

perf/x86: Fix embarrasing typo

Because we're all human and typing sucks..

Fixes: 7fb0f1de49fc ("perf/x86: Fix compile warnings for intel_uncore")
Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/n/tip-be0bftjh8yfm4uvmvtf3yi87@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ded8a67..41a503c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -144,7 +144,7 @@ config INSTRUCTION_DECODER
 
 config PERF_EVENTS_INTEL_UNCORE
 	def_bool y
-	depends on PERF_EVENTS && SUP_SUP_INTEL && PCI
+	depends on PERF_EVENTS && CPU_SUP_INTEL && PCI
 
 config OUTPUT_FORMAT
 	string
