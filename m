Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab3HVHtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 03:49:35 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:55632 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab3HVHte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 03:49:34 -0400
Message-ID: <5215C286.8020501@linux.vnet.ibm.com>
Date: Thu, 22 Aug 2013 15:49:26 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: open list <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 01/11] sched/cleanup: remove the extra line in init_sched_fair_class()
References: <5215C233.9060907@linux.vnet.ibm.com>
In-Reply-To: <5215C233.9060907@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082207-2000-0000-0000-00000D69FDBE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the extra line.

CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index aaaed57..a925e17 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6277,5 +6277,4 @@ __init void init_sched_fair_class(void)
 	cpu_notifier(sched_ilb_notifier, 0);
 #endif
 #endif /* SMP */
-
 }
-- 
1.7.9.5

