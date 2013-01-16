Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab3APRpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:45:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:35733 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171Ab3APRpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:45:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,480,1355126400"; 
   d="scan'208";a="272870996"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Cc: Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [Update] [PATCH v6 3/3] PM: Introduce Intel PowerClamp Driver
Date: Wed, 16 Jan 2013 01:45:28 -0800
Message-Id: <1358329528-1286-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>

---
Need to include the proper nmi.h file such that
local_touch_nmi is always declared.


 drivers/thermal/intel_powerclamp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
index 314b6fc..81ebf87 100644
--- a/drivers/thermal/intel_powerclamp.c
+++ b/drivers/thermal/intel_powerclamp.c
@@ -50,8 +50,8 @@
 #include <linux/tick.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
-#include <linux/nmi.h>
 
+#include <asm/nmi.h>
 #include <asm/msr.h>
 #include <asm/mwait.h>
 #include <asm/cpu_device_id.h>
-- 
1.7.9.5

