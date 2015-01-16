Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbbAPGzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 01:55:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:7877 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbbAPGzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 01:55:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,409,1418112000"; 
   d="scan'208";a="662793308"
Date: Fri, 16 Jan 2015 14:55:19 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: kbuild-all@01.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [vireshk:cpufreq/core/locking 57/60]
 drivers/cpufreq/cpufreq.c:512:5: sparse: symbol '__cpufreq_boost_supported'
 was not declared. Should it be static?
Message-ID: <201501161410.qF6rUO8n%fengguang.wu@intel.com>
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

tree:   https://git.linaro.org/people/vireshk/linux cpufreq/core/locking
head:   12d5339e685739289c2f629c943b8bfad4c64f1e
commit: fbce49b78afdaeeaee3017cfbd968e44ddba8496 [57/60] cpufreq: Drop forward declaration of __cpufreq_boost_trigger_state()
reproduce:
  # apt-get install sparse
  git checkout fbce49b78afdaeeaee3017cfbd968e44ddba8496
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/cpufreq/cpufreq.c:512:5: sparse: symbol '__cpufreq_boost_supported' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
