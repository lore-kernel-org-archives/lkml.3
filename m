Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaFEOkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:40:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48744 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaFEOka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:40:30 -0400
Date: Thu, 5 Jun 2014 07:39:38 -0700
From: tip-bot for Anshuman Khandual <tipbot@zytor.com>
Message-ID: <tip-0fffa5df4cf3e22be4f40f6698ab9e49f3ffd6fa@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        khandual@linux.vnet.ibm.com, acme@kernel.org, ak@linux.intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        khandual@linux.vnet.ibm.com, peterz@infradead.org, acme@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1400743210-32289-2-git-send-email-khandual@linux.vnet.ibm.com>
References: <1400743210-32289-2-git-send-email-khandual@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/tool: Add conditional branch filter 'cond'
  to perf record
Git-Commit-ID: 0fffa5df4cf3e22be4f40f6698ab9e49f3ffd6fa
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

Commit-ID:  0fffa5df4cf3e22be4f40f6698ab9e49f3ffd6fa
Gitweb:     http://git.kernel.org/tip/0fffa5df4cf3e22be4f40f6698ab9e49f3ffd6fa
Author:     Anshuman Khandual <khandual@linux.vnet.ibm.com>
AuthorDate: Thu, 22 May 2014 12:50:08 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 12:30:19 +0200

perf/tool: Add conditional branch filter 'cond' to perf record

Adding perf record support for new branch stack filter criteria
PERF_SAMPLE_BRANCH_COND.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1400743210-32289-2-git-send-email-khandual@linux.vnet.ibm.com
Cc: mpe@ellerman.id.au
Cc: benh@kernel.crashing.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/builtin-record.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ce2cfec..378b85b 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -548,6 +548,7 @@ static const struct branch_mode branch_modes[] = {
 	BRANCH_OPT("abort_tx", PERF_SAMPLE_BRANCH_ABORT_TX),
 	BRANCH_OPT("in_tx", PERF_SAMPLE_BRANCH_IN_TX),
 	BRANCH_OPT("no_tx", PERF_SAMPLE_BRANCH_NO_TX),
+	BRANCH_OPT("cond", PERF_SAMPLE_BRANCH_COND),
 	BRANCH_END
 };
 
