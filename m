Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbbAPGzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 01:55:35 -0500
Received: from mga02.intel.com ([134.134.136.20]:51300 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbbAPGzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 01:55:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,409,1418112000"; 
   d="scan'208";a="670897898"
Date: Fri, 16 Jan 2015 14:55:19 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: kbuild-all@01.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH vireshk] cpufreq: __cpufreq_boost_supported() can be static
Message-ID: <20150116065519.GA30921@lkp-sb04>
References: <201501161410.qF6rUO8n%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201501161410.qF6rUO8n%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/cpufreq/cpufreq.c:512:5: sparse: symbol '__cpufreq_boost_supported' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index c151f4b..4e3d42f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -509,7 +509,7 @@ unlock:
 	return ret;
 }
 
-int __cpufreq_boost_supported(void)
+static int __cpufreq_boost_supported(void)
 {
 	if (likely(cpufreq_driver))
 		return cpufreq_driver->boost_supported;
