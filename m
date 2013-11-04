Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab3KDRah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:30:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:32204 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab3KDRaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:30:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="429611368"
From: James Ralston <james.d.ralston@intel.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-doc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Seth Heasley <seth.heasley@intel.com>,
        James Ralston <james.d.ralston@intel.com>
Subject: [PATCH 3/4] i2c-i801: Add Device IDs for Intel Wildcat Point-LP PCH
Date: Mon,  4 Nov 2013 09:29:48 -0800
Message-Id: <1383586188-4717-1-git-send-email-james.d.ralston@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the SMBus Device IDs for the Intel Wildcat Point-LP PCH.

Signed-off-by: James Ralston <james.d.ralston@intel.com>
---
 Documentation/i2c/busses/i2c-i801 | 1 +
 drivers/i2c/busses/Kconfig        | 1 +
 drivers/i2c/busses/i2c-i801.c     | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/Documentation/i2c/busses/i2c-i801 b/Documentation/i2c/busses/i2c-i801
index d29dea0..7b0dcdb 100644
--- a/Documentation/i2c/busses/i2c-i801
+++ b/Documentation/i2c/busses/i2c-i801
@@ -25,6 +25,7 @@ Supported adapters:
   * Intel Avoton (SOC)
   * Intel Wellsburg (PCH)
   * Intel Coleto Creek (PCH)
+  * Intel Wildcat Point-LP (PCH)
    Datasheets: Publicly available at the Intel website
 
 On Intel Patsburg and later chipsets, both the normal host SMBus controller
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index cdcbd83..a83ef0f 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -109,6 +109,7 @@ config I2C_I801
 	    Avoton (SOC)
 	    Wellsburg (PCH)
 	    Coleto Creek (PCH)
+	    Wildcat Point-LP (PCH)
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 4296d17..737e298 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -59,6 +59,7 @@
   Wellsburg (PCH) MS    0x8d7e     32     hard     yes     yes     yes
   Wellsburg (PCH) MS    0x8d7f     32     hard     yes     yes     yes
   Coleto Creek (PCH)    0x23b0     32     hard     yes     yes     yes
+  Wildcat Point-LP (PCH)   0x9ca2     32     hard     yes     yes     yes
 
   Features supported by this driver:
   Software PEC                     no
@@ -177,6 +178,7 @@
 #define PCI_DEVICE_ID_INTEL_WELLSBURG_SMBUS_MS1	0x8d7e
 #define PCI_DEVICE_ID_INTEL_WELLSBURG_SMBUS_MS2	0x8d7f
 #define PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_SMBUS	0x9c22
+#define PCI_DEVICE_ID_INTEL_WILDCATPOINT_LP_SMBUS	0x9ca2
 
 struct i801_mux_config {
 	char *gpio_chip;
@@ -819,6 +821,7 @@ static DEFINE_PCI_DEVICE_TABLE(i801_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_WELLSBURG_SMBUS_MS1) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_WELLSBURG_SMBUS_MS2) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_COLETOCREEK_SMBUS) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_WILDCATPOINT_LP_SMBUS) },
 	{ 0, }
 };
 
-- 
1.8.3.1

