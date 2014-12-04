Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778AbaLDRSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:18:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:27375 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254AbaLDRSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:18:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,516,1413270000"; 
   d="scan'208";a="648351164"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, Linux PM <linux-pm@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Zhang Rui <rui.zhang@intel.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] thermal/powerclamp: add id for braswell cpu
Date: Thu,  4 Dec 2014 09:17:46 -0800
Message-Id: <1417713466-1058-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/thermal/intel_powerclamp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
index 95cb7fc..b46c706 100644
--- a/drivers/thermal/intel_powerclamp.c
+++ b/drivers/thermal/intel_powerclamp.c
@@ -689,6 +689,7 @@ static const struct x86_cpu_id intel_powerclamp_ids[] = {
 	{ X86_VENDOR_INTEL, 6, 0x3f},
 	{ X86_VENDOR_INTEL, 6, 0x45},
 	{ X86_VENDOR_INTEL, 6, 0x46},
+	{ X86_VENDOR_INTEL, 6, 0x4c},
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_powerclamp_ids);
-- 
1.9.1

