Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab3AQKaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:30:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:17434 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759518Ab3AQKaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:30:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,484,1355126400"; 
   d="scan'208";a="274899490"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Jean Delvare <khali@linux-fr.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        dirk.brandewie@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] i2c-designware: add missing MODULE_LICENSE
Date: Thu, 17 Jan 2013 12:31:04 +0200
Message-Id: <1358418667-4533-2-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358418667-4533-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1358418667-4533-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver can also be built as a module so add MODULE_LICENSE for it. In
addition add MODULE_DESCRIPTION as well.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/i2c/busses/i2c-designware-core.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index cbba7db..f5258c2 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -34,6 +34,7 @@
 #include <linux/io.h>
 #include <linux/pm_runtime.h>
 #include <linux/delay.h>
+#include <linux/module.h>
 #include "i2c-designware-core.h"
 
 /*
@@ -725,3 +726,6 @@ u32 i2c_dw_read_comp_param(struct dw_i2c_dev *dev)
 	return dw_readl(dev, DW_IC_COMP_PARAM_1);
 }
 EXPORT_SYMBOL_GPL(i2c_dw_read_comp_param);
+
+MODULE_DESCRIPTION("Synopsys DesignWare I2C bus adapter core");
+MODULE_LICENSE("GPL");
-- 
1.7.10.4

