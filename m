Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaKFSXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:23:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:25820 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaKFSXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:23:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,327,1413270000"; 
   d="scan'208";a="603639358"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>
Cc: Len Brown <len.brown@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Noor U Mubeen <noor.u.mubeen@intel.com>,
        Ajay Thomas <ajay.thomas.david.rajamanickam@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 3/3] powercap/rapl: add new model ids
Date: Thu,  6 Nov 2014 10:22:37 -0800
Message-Id: <1415298157-7615-4-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415298157-7615-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1415298157-7615-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/powercap/intel_rapl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/powercap/intel_rapl.c b/drivers/powercap/intel_rapl.c
index bcbfa95..3fecbbf 100644
--- a/drivers/powercap/intel_rapl.c
+++ b/drivers/powercap/intel_rapl.c
@@ -1039,6 +1039,9 @@ static const struct x86_cpu_id rapl_ids[] = {
 	RAPL_CPU(0x3d, rapl_defaults_core),/* Broadwell */
 	RAPL_CPU(0x3f, rapl_defaults_core),/* Haswell */
 	RAPL_CPU(0x45, rapl_defaults_core),/* Haswell ULT */
+	RAPL_CPU(0x4C, rapl_defaults_atom),/* Braswell */
+	RAPL_CPU(0x4A, rapl_defaults_atom),/* Tangier */
+	RAPL_CPU(0x5A, rapl_defaults_atom),/* Annidale */
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, rapl_ids);
-- 
1.9.1

