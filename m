Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaAJEgu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 23:36:50 -0500
Received: from mga03.intel.com ([143.182.124.21]:5787 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223AbaAJEgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 23:36:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,636,1384329600"; 
   d="scan'208";a="456503835"
Date: Fri, 10 Jan 2014 12:36:42 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kbuild-all@01.org
Subject: warning: (PPC_PSERIES && ..) selects HOTPLUG_CPU which has unmet
 direct dependencies (SMP && ..))
Message-ID: <20140110043642.GB21058@localhost>
References: <52cebbdf.VOHKy5gPVEgnVPcm%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52cebbdf.VOHKy5gPVEgnVPcm%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   7d1c153ab373a5c07feb97eaf4e4bcad5bfc262e
commit: bb07b00be77fb33274cb44a03bdbf2471e556189 Merge 3.10-rc6 into driver-core-next
date:   7 months ago
config: make ARCH=powerpc mpc86xx_defconfig

All warnings:

warning: (PPC_PSERIES && PM_SLEEP_SMP) selects HOTPLUG_CPU which has unmet direct dependencies (SMP && (PPC_PSERIES || PPC_PMAC || PPC_POWERNV || PPC_85xx && !PPC_E500MC))

---
0-DAY kernel build testing backend              Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
