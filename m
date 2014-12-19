Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaLSISt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:18:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:17603 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbaLSISb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:18:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="431101806"
Date: Fri, 19 Dec 2014 16:17:56 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: kbuild-all@01.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH vireshk] cpufreq: stats: cpufreq_stats_lock can be static
Message-ID: <20141219081756.GA56678@lkp-sb04>
References: <201412191646.uhe36Ci6%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201412191646.uhe36Ci6%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/cpufreq/cpufreq_stats.c:19:1: sparse: symbol 'cpufreq_stats_lock' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 cpufreq_stats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index d333659..de55ca8 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -16,7 +16,7 @@
 #include <linux/slab.h>
 #include <linux/cputime.h>
 
-DEFINE_MUTEX(cpufreq_stats_lock);
+static DEFINE_MUTEX(cpufreq_stats_lock);
 
 struct cpufreq_stats {
 	unsigned int total_trans;
