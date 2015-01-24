Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558AbbAXCpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 21:45:39 -0500
Received: from mga03.intel.com ([134.134.136.65]:6575 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965AbbAXCpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 21:45:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,457,1418112000"; 
   d="scan'208";a="666802478"
Date: Sat, 24 Jan 2015 10:44:57 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: kbuild-all@01.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH clk] sched: __pcpu_scope_sd_pack_buddy can be static
Message-ID: <20150124024457.GA23470@snb>
References: <201501241041.Cc4XnwuN%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201501241041.Cc4XnwuN%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/sched/fair.c:199:1: sparse: symbol '__pcpu_scope_sd_pack_buddy' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d48d07c..7d8d5c4 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -196,7 +196,7 @@ struct sd_pack {
  * Save per_cpu information about the optimal CPUs that should be used to pack
  * tasks.
  */
-DEFINE_PER_CPU(struct sd_pack, sd_pack_buddy)  = {
+static DEFINE_PER_CPU(struct sd_pack, sd_pack_buddy)  = {
 	.packing = true,
 };
 
