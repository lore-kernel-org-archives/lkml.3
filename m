Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab3IZTdZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 15:33:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:56357 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab3IZTdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 15:33:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,987,1371106800"; 
   d="scan'208";a="384039528"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, Linux PM <linux-pm@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>
Cc: Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] thermal/intel_powerclamp: Add newer CPU models
Date: Thu, 26 Sep 2013 04:33:25 -0700
Message-Id: <1380195205-32646-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will enable intel_powerclamp driver on newer Intel CPUs
including some Ivy Bridge and Haswell processors.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/thermal/intel_powerclamp.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
index b40b37c..6e3b061 100644
--- a/drivers/thermal/intel_powerclamp.c
+++ b/drivers/thermal/intel_powerclamp.c
@@ -675,6 +675,11 @@ static const struct x86_cpu_id intel_powerclamp_ids[] = {
 	{ X86_VENDOR_INTEL, 6, 0x2e},
 	{ X86_VENDOR_INTEL, 6, 0x2f},
 	{ X86_VENDOR_INTEL, 6, 0x3a},
+	{ X86_VENDOR_INTEL, 6, 0x3c},
+	{ X86_VENDOR_INTEL, 6, 0x3e},
+	{ X86_VENDOR_INTEL, 6, 0x3f},
+	{ X86_VENDOR_INTEL, 6, 0x45},
+	{ X86_VENDOR_INTEL, 6, 0x46},
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_powerclamp_ids);
-- 
1.7.9.5

