Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011AbaHVKGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 06:06:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:31327 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbaHVKGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 06:06:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,379,1406617200"; 
   d="scan'208";a="471554511"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cpufreq: intel_pstate: Add CPU ID for Braswell processor
Date: Fri, 22 Aug 2014 13:05:44 +0300
Message-Id: <1408701944-14734-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is pretty much the same as Intel Baytrail, only the CPU ID is
different. Add the new ID to the supported CPU list.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/intel_pstate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index c5eac949760d..a3cf8994160b 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -660,6 +660,7 @@ static const struct x86_cpu_id intel_pstate_cpu_ids[] = {
 	ICPU(0x3f, core_params),
 	ICPU(0x45, core_params),
 	ICPU(0x46, core_params),
+	ICPU(0x4c, byt_params),
 	ICPU(0x4f, core_params),
 	ICPU(0x56, core_params),
 	{}
-- 
2.1.0

