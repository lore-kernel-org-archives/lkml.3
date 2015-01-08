Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbbAHTjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 14:39:14 -0500
Received: from mga01.intel.com ([192.55.52.88]:32577 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbbAHTjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 14:39:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="438154264"
Date: Fri, 9 Jan 2015 03:38:38 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: kbuild-all@01.org, Changman Lee <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH f2fs] f2fs: pids_lock can be static
Message-ID: <20150108193838.GA28080@snb>
References: <201501090312.wCG4mLHp%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201501090312.wCG4mLHp%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/f2fs/trace.c:19:12: sparse: symbol 'pids_lock' was not declared. Should it be static?

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/trace.c b/fs/f2fs/trace.c
index 92fa38a..517dfe5 100644
--- a/fs/f2fs/trace.c
+++ b/fs/f2fs/trace.c
@@ -16,7 +16,7 @@
 #include "trace.h"
 
 RADIX_TREE(pids, GFP_ATOMIC);
-spinlock_t pids_lock;
+static spinlock_t pids_lock;
 struct last_io_info last_io;
 
 static inline void __print_last_io(void)
