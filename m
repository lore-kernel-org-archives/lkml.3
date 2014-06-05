Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaFEOlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:41:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48788 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaFEOlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:41:03 -0400
Date: Thu, 5 Jun 2014 07:40:02 -0700
From: tip-bot for Anshuman Khandual <tipbot@zytor.com>
Message-ID: <tip-3e39db4ae2a92ae9e338e8066411b694b0edcb31@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        khandual@linux.vnet.ibm.com, acme@kernel.org, jolsa@redhat.com,
        ak@linux.intel.com, adrian.hunter@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        khandual@linux.vnet.ibm.com, peterz@infradead.org, acme@kernel.org,
        jolsa@redhat.com, adrian.hunter@intel.com, ak@linux.intel.com,
        tglx@linutronix.de
In-Reply-To: <1400743210-32289-4-git-send-email-khandual@linux.vnet.ibm.com>
References: <1400743210-32289-4-git-send-email-khandual@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/documentation:
  Add description for conditional branch filter
Git-Commit-ID: 3e39db4ae2a92ae9e338e8066411b694b0edcb31
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

Commit-ID:  3e39db4ae2a92ae9e338e8066411b694b0edcb31
Gitweb:     http://git.kernel.org/tip/3e39db4ae2a92ae9e338e8066411b694b0edcb31
Author:     Anshuman Khandual <khandual@linux.vnet.ibm.com>
AuthorDate: Thu, 22 May 2014 12:50:10 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 12:30:27 +0200

perf/documentation: Add description for conditional branch filter

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: mpe@ellerman.id.au
Cc: benh@kernel.crashing.org
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1400743210-32289-4-git-send-email-khandual@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/Documentation/perf-record.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index c71b0f3..d460049 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -184,9 +184,10 @@ following filters are defined:
 	- in_tx: only when the target is in a hardware transaction
 	- no_tx: only when the target is not in a hardware transaction
 	- abort_tx: only when the target is a hardware transaction abort
+	- cond: conditional branches
 
 +
-The option requires at least one branch type among any, any_call, any_ret, ind_call.
+The option requires at least one branch type among any, any_call, any_ret, ind_call, cond.
 The privilege levels may be omitted, in which case, the privilege levels of the associated
 event are applied to the branch filter. Both kernel (k) and hypervisor (hv) privilege
 levels are subject to permissions.  When sampling on multiple events, branch stack sampling
