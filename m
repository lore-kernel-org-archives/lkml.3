Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbaEUKBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 06:01:51 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:34131 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaEUKBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 06:01:50 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mpe@ellerman.id.au, benh@kernel.crashing.org
Subject: [V6 02/11] perf, tool: Conditional branch filter 'cond' added to perf record
Date: Wed, 21 May 2014 15:29:47 +0530
Message-Id: <1400666396-1682-3-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1400666396-1682-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1400666396-1682-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052110-9574-0000-0000-00000DB6C882
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding perf record support for new branch stack filter criteria
PERF_SAMPLE_BRANCH_COND.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/builtin-record.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 8ce62ef..dfe6b9d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -583,6 +583,7 @@ static const struct branch_mode branch_modes[] = {
 	BRANCH_OPT("abort_tx", PERF_SAMPLE_BRANCH_ABORT_TX),
 	BRANCH_OPT("in_tx", PERF_SAMPLE_BRANCH_IN_TX),
 	BRANCH_OPT("no_tx", PERF_SAMPLE_BRANCH_NO_TX),
+	BRANCH_OPT("cond", PERF_SAMPLE_BRANCH_COND),
 	BRANCH_END
 };
 
-- 
1.7.11.7

