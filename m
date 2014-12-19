Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752273AbaLSISc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:18:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:59672 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbaLSISa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:18:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,605,1413270000"; 
   d="scan'208";a="626449255"
Date: Fri, 19 Dec 2014 16:17:56 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: kbuild-all@01.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [vireshk:cpufreq/stats/cleanups 12/14]
 drivers/cpufreq/cpufreq_stats.c:19:1: sparse: symbol 'cpufreq_stats_lock'
 was not declared. Should it be static?
Message-ID: <201412191646.uhe36Ci6%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tree:   https://git.linaro.org/people/vireshk/linux cpufreq/stats/cleanups
head:   f6439741b76da59257758838e8b24472831e850c
commit: 2194c3c381af6cbfe8ab4fda481e07a004446e30 [12/14] cpufreq: stats: replace spinlock with mutex
reproduce:
  # apt-get install sparse
  git checkout 2194c3c381af6cbfe8ab4fda481e07a004446e30
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/cpufreq/cpufreq_stats.c:19:1: sparse: symbol 'cpufreq_stats_lock' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
