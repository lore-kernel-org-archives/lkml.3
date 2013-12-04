Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab3LDKgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:36:23 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:56338 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab3LDKdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:33:54 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org, sukadev@linux.vnet.ibm.com,
        eranian@google.com, acme@ghostprotocols.net, ak@linux.intel.com,
        mingo@kernel.org
Subject: [PATCH V4 03/10] perf, tool: Conditional branch filter 'cond' added to perf record
Date: Wed,  4 Dec 2013 16:02:35 +0530
Message-Id: <1386153162-11225-4-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386153162-11225-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1386153162-11225-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120410-5564-0000-0000-00000AF51F7E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding perf record support for new branch stack filter criteria
PERF_SAMPLE_BRANCH_COND.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-record.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 7c8020a..34040f7 100644
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

