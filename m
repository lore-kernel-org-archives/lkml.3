Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaCGJJ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:09:26 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:56549 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaCGJJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:09:17 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [V5 2/4] perf, tool: Conditional branch filter 'cond' added to perf record
Date: Fri,  7 Mar 2014 14:36:23 +0530
Message-Id: <1394183185-6219-3-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1394183185-6219-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1394183185-6219-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030709-9264-0000-0000-00000597E9EF
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
index 3c394bf..eb74bcd 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -589,6 +589,7 @@ static const struct branch_mode branch_modes[] = {
 	BRANCH_OPT("abort_tx", PERF_SAMPLE_BRANCH_ABORT_TX),
 	BRANCH_OPT("in_tx", PERF_SAMPLE_BRANCH_IN_TX),
 	BRANCH_OPT("no_tx", PERF_SAMPLE_BRANCH_NO_TX),
+	BRANCH_OPT("cond", PERF_SAMPLE_BRANCH_COND),
 	BRANCH_END
 };
 
-- 
1.7.11.7

