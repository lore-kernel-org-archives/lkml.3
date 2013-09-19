Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab3ISQAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 12:00:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:60050 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab3ISQA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 12:00:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,937,1371106800"; 
   d="scan'208";a="380631642"
From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, gregkh@linuxfoundation.org, len.brown@intel.com,
        rjw@sisk.pl, arjan@linux.intel.com, jacob.jun.pan@linux.intel.com,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Subject: [PATCH v1 3/6] PowerCap: Added to drivers build
Date: Thu, 19 Sep 2013 09:00:32 -0700
Message-Id: <1379606435-15871-4-git-send-email-srinivas.pandruvada@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379606435-15871-1-git-send-email-srinivas.pandruvada@linux.intel.com>
References: <1379606435-15871-1-git-send-email-srinivas.pandruvada@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added changes to Makefile and Kconfig to include in driver build.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/Kconfig  | 2 ++
 drivers/Makefile | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/Kconfig b/drivers/Kconfig
index aa43b91..969e987 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -166,4 +166,6 @@ source "drivers/reset/Kconfig"
 
 source "drivers/fmc/Kconfig"
 
+source "drivers/powercap/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index ab93de8..34c1d55 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -152,3 +152,4 @@ obj-$(CONFIG_VME_BUS)		+= vme/
 obj-$(CONFIG_IPACK_BUS)		+= ipack/
 obj-$(CONFIG_NTB)		+= ntb/
 obj-$(CONFIG_FMC)		+= fmc/
+obj-$(CONFIG_POWERCAP)		+= powercap/
-- 
1.8.3.1

