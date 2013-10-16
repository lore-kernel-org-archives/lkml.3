Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760164Ab3JPHBC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 03:01:02 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:56233 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759029Ab3JPG6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 02:58:04 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: eranian@google.com, michaele@au1.ibm.com, mikey@neuling.org,
        sukadev@linux.vnet.ibm.com
Subject: [V3 03/10] perf, tool: Conditional branch filter 'cond' added to perf record
Date: Wed, 16 Oct 2013 12:26:50 +0530
Message-Id: <1381906617-11392-4-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1381906617-11392-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1381906617-11392-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101606-2000-0000-0000-00000E20AC84
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
index ecca62e..802d11d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -625,6 +625,7 @@ static const struct branch_mode branch_modes[] = {
 	BRANCH_OPT("any_call", PERF_SAMPLE_BRANCH_ANY_CALL),
 	BRANCH_OPT("any_ret", PERF_SAMPLE_BRANCH_ANY_RETURN),
 	BRANCH_OPT("ind_call", PERF_SAMPLE_BRANCH_IND_CALL),
+	BRANCH_OPT("cond", PERF_SAMPLE_BRANCH_COND),
 	BRANCH_END
 };
 
-- 
1.7.11.7

