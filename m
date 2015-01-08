Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbbAHTjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 14:39:22 -0500
Received: from mga14.intel.com ([192.55.52.115]:52591 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbbAHTjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 14:39:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,724,1413270000"; 
   d="scan'208";a="658911081"
Date: Fri, 9 Jan 2015 03:38:38 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: kbuild-all@01.org, Changman Lee <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs:linux-3.4 31/33] fs/f2fs/trace.c:19:12: sparse: symbol
 'pids_lock' was not declared. Should it be static?
Message-ID: <201501090312.wCG4mLHp%fengguang.wu@intel.com>
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

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs linux-3.4
head:   a725baf7b8472a0b97dc12ed4d1c147cad2f3e8c
commit: 37a78eb5019798c94d4543c48e1d6490a552e1c7 [31/33] f2fs: add spin_lock to cover radix operations in IO tracer
reproduce:
  # apt-get install sparse
  git checkout 37a78eb5019798c94d4543c48e1d6490a552e1c7
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> fs/f2fs/trace.c:19:12: sparse: symbol 'pids_lock' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
