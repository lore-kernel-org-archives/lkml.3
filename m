Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaCGJKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 04:10:16 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:56553 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaCGJJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 04:09:18 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [V5 4/4] perf, documentation: Description for conditional branch filter
Date: Fri,  7 Mar 2014 14:36:25 +0530
Message-Id: <1394183185-6219-5-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1394183185-6219-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1394183185-6219-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030709-9264-0000-0000-00000597E9F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding documentation support for conditional branch filter.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
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
-- 
1.7.11.7

