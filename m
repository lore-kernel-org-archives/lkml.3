Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524Ab3HUL1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 07:27:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:21602 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab3HUL1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 07:27:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,927,1367996400"; 
   d="scan'208";a="366114204"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rob Landley <rob@landley.net>
Subject: [PATCH 1/2] acpi-dma, doc: append managed function to the list
Date: Wed, 21 Aug 2013 14:27:05 +0300
Message-Id: <1377084426-11179-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI DMA provides managed function to register the slave DMA controller in the
internal container. This patch anounces that function in the corresponding
documentation file.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rob Landley <rob@landley.net>
---
 Documentation/driver-model/devres.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
index fb57d85..fcb34a5 100644
--- a/Documentation/driver-model/devres.txt
+++ b/Documentation/driver-model/devres.txt
@@ -299,3 +299,6 @@ PWM
 PHY
   devm_usb_get_phy()
   devm_usb_put_phy()
+
+SLAVE DMA ENGINE
+  devm_acpi_dma_controller_register()
-- 
1.8.4.rc2

