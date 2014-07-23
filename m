Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530AbaGWCjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:39:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:55360 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508AbaGWCjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:39:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="565813254"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, paulus@samba.org,
        benh@kernel.crashing.org, tony.luck@intel.com, hpa@zytor.com,
        jkosina@suse.cz, rafael.j.wysocki@intel.com, bp@alien8.de,
        linux@arm.linux.org.uk, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        davem@davemloft.net, viro@zeniv.linux.org.uk, fweisbec@gmail.com,
        cl@linux.com, akpm@linux-foundation.org, axboe@kernel.dk,
        JBottomley@parallels.com, neilb@suse.de, christoffer.dall@linaro.org,
        rostedt@goodmis.org, rric@kernel.org, gregkh@linuxfoundation.org,
        mhocko@suse.cz, david@fromorbit.com,
        "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [RFC PATCH v1 70/70] cpu: Eliminate _FROZEN flags thoroughly
Date: Tue, 22 Jul 2014 21:59:46 -0400
Message-Id: <1406080786-3938-71-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
References: <1406080786-3938-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By now all usages of XXX_FROZEN have been removed. It can
be deleted safely.

Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
---
 include/linux/cpu.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 95978ad..9de61cc 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -97,15 +97,6 @@ enum {
  */
 #define CPU_TASKS_FROZEN	0x0010
 
-#define CPU_ONLINE_FROZEN	(CPU_ONLINE | CPU_TASKS_FROZEN)
-#define CPU_UP_PREPARE_FROZEN	(CPU_UP_PREPARE | CPU_TASKS_FROZEN)
-#define CPU_UP_CANCELED_FROZEN	(CPU_UP_CANCELED | CPU_TASKS_FROZEN)
-#define CPU_DOWN_PREPARE_FROZEN	(CPU_DOWN_PREPARE | CPU_TASKS_FROZEN)
-#define CPU_DOWN_FAILED_FROZEN	(CPU_DOWN_FAILED | CPU_TASKS_FROZEN)
-#define CPU_DEAD_FROZEN		(CPU_DEAD | CPU_TASKS_FROZEN)
-#define CPU_DYING_FROZEN	(CPU_DYING | CPU_TASKS_FROZEN)
-#define CPU_STARTING_FROZEN	(CPU_STARTING | CPU_TASKS_FROZEN)
-
 
 #ifdef CONFIG_SMP
 /* Need to know about CPUs going up/down? */
-- 
2.0.0.rc2

