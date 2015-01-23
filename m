Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbbAWMN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 07:13:26 -0500
Received: from mga03.intel.com ([134.134.136.65]:11431 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755129AbbAWMNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 07:13:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,453,1418112000"; 
   d="scan'208";a="674750104"
Date: Fri, 23 Jan 2015 20:12:06 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org
Subject: [tip:timers/core 2/2] kernel/time/hrtimer.c:444:9: sparse: symbol
 '__hrtimer_get_next_event' was not declared. Should it be static?
Message-ID: <201501232056.e6Qrox8m%fengguang.wu@intel.com>
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

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
head:   9bc7491906b4113b4c5ae442157c7dfc4e10cd14
commit: 9bc7491906b4113b4c5ae442157c7dfc4e10cd14 [2/2] hrtimer: Prevent stale expiry time in hrtimer_interrupt()
reproduce:
  # apt-get install sparse
  git checkout 9bc7491906b4113b4c5ae442157c7dfc4e10cd14
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   kernel/time/hrtimer.c:67:1: sparse: symbol '__pcpu_scope_hrtimer_bases' was not declared. Should it be static?
>> kernel/time/hrtimer.c:444:9: sparse: symbol '__hrtimer_get_next_event' was not declared. Should it be static?
   kernel/time/hrtimer.c:152:27: sparse: context imbalance in 'lock_hrtimer_base' - wrong count at exit
   kernel/time/hrtimer.c:994:25: sparse: context imbalance in '__hrtimer_start_range_ns' - unexpected unlock
   kernel/time/hrtimer.c:793:9: sparse: context imbalance in 'hrtimer_try_to_cancel' - unexpected unlock
   kernel/time/hrtimer.c:1099:9: sparse: context imbalance in 'hrtimer_get_remaining' - unexpected unlock

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
