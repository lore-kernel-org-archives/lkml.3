Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbbAWFgz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:36:55 -0500
Received: from mga03.intel.com ([134.134.136.65]:18485 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbbAWFgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:36:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="444042556"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <trivial@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: [Resend Patch v4 16/16] smp, trivial: Remove unused function prototype from smp_boot.h
Date: Fri, 23 Jan 2015 13:36:55 +0800
Message-Id: <1421991416-20297-17-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function smpboot_thread_schedule() is neither used nor defined,
so kill it.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 include/linux/smpboot.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/smpboot.h b/include/linux/smpboot.h
index 13e929679550..d600afb21926 100644
--- a/include/linux/smpboot.h
+++ b/include/linux/smpboot.h
@@ -47,6 +47,5 @@ struct smp_hotplug_thread {
 
 int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread);
 void smpboot_unregister_percpu_thread(struct smp_hotplug_thread *plug_thread);
-int smpboot_thread_schedule(void);
 
 #endif
-- 
1.7.10.4

