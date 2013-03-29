Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab3C2O1y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 10:27:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:58715 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755184Ab3C2O1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 10:27:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,373,1363158000"; 
   d="scan'208";a="309147521"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: amit.daniel@samsung.com, durgadoss.r@intel.com, andi@lisas.de,
        eduardo.valentin@ti.com, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V2 1/3] Thermal: rename thermal_sys.c to thermal_core.c
Date: Fri, 29 Mar 2013 22:26:34 +0800
Message-Id: <1364567196-3560-2-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364567196-3560-1-git-send-email-rui.zhang@intel.com>
References: <1364567196-3560-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this is the preparation work to build all the thermal core framework
source file, like governors, cpu cooling, etc, into one module.

No functional change in this patch.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/thermal/Makefile                          |    1 +
 drivers/thermal/{thermal_sys.c => thermal_core.c} |    0
 2 files changed, 1 insertion(+)
 rename drivers/thermal/{thermal_sys.c => thermal_core.c} (100%)

diff --git a/drivers/thermal/Makefile b/drivers/thermal/Makefile
index d3a2b38..b2009bd 100644
--- a/drivers/thermal/Makefile
+++ b/drivers/thermal/Makefile
@@ -3,6 +3,7 @@
 #
 
 obj-$(CONFIG_THERMAL)		+= thermal_sys.o
+thermal_sys-y			+= thermal_core.o
 
 # governors
 obj-$(CONFIG_THERMAL_GOV_FAIR_SHARE)	+= fair_share.o
diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_core.c
similarity index 100%
rename from drivers/thermal/thermal_sys.c
rename to drivers/thermal/thermal_core.c
-- 
1.7.9.5

