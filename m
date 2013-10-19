Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab3JSV4r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 17:56:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43130 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab3JSV4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 17:56:46 -0400
Message-ID: <5263001C.1060109@infradead.org>
Date: Sat, 19 Oct 2013 14:56:44 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] sched/fair.c: remove kernel-doc warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Remove @balance parameter that is no longer used in the function to
remove a kernel-doc warning.

Warning(kernel/sched/fair.c:4704): Excess function parameter 'balance' description in 'update_sd_lb_stats'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 kernel/sched/fair.c |    1 -
 1 file changed, 1 deletion(-)

--- lnx-312-rc6.orig/kernel/sched/fair.c
+++ lnx-312-rc6/kernel/sched/fair.c
@@ -4696,7 +4696,6 @@ static bool update_sd_pick_busiest(struc
 /**
  * update_sd_lb_stats - Update sched_domain's statistics for load balancing.
  * @env: The load balancing environment.
- * @balance: Should we balance.
  * @sds: variable to hold the statistics for this sched_domain.
  */
 static inline void update_sd_lb_stats(struct lb_env *env,
