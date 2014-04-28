Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333AbaD1WG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 18:06:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:58602 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933189AbaD1WFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 18:05:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,946,1389772800"; 
   d="scan'208";a="502535812"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Linux PM <linux-pm@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: "David E. Box" <david.e.box@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, Durgadoss R <durgadoss.r@intel.com>,
        Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 2/5] powercap/rapl: add new cpu ids
Date: Mon, 28 Apr 2014 07:04:37 -0700
Message-Id: <1398693880-13428-3-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1398693880-13428-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1398693880-13428-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for Broadwell model 0x3d and HSW model (0x3c)

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/powercap/intel_rapl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/powercap/intel_rapl.c b/drivers/powercap/intel_rapl.c
index 1c987d2..b1cda6f 100644
--- a/drivers/powercap/intel_rapl.c
+++ b/drivers/powercap/intel_rapl.c
@@ -951,7 +951,9 @@ static const struct x86_cpu_id rapl_ids[] = {
 	{ X86_VENDOR_INTEL, 6, 0x2d},/* Sandy Bridge EP */
 	{ X86_VENDOR_INTEL, 6, 0x37},/* Valleyview */
 	{ X86_VENDOR_INTEL, 6, 0x3a},/* Ivy Bridge */
-	{ X86_VENDOR_INTEL, 6, 0x45},/* Haswell */
+	{ X86_VENDOR_INTEL, 6, 0x3c},/* Haswell */
+	{ X86_VENDOR_INTEL, 6, 0x3d},/* Broadwell */
+	{ X86_VENDOR_INTEL, 6, 0x45},/* Haswell ULT */
 	/* TODO: Add more CPU IDs after testing */
 	{}
 };
-- 
1.8.1.2

