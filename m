Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054Ab3BUVd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 16:33:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:47799 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004Ab3BUVdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 16:33:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,711,1355126400"; 
   d="scan'208";a="288985538"
From: Seth Heasley <seth.heasley@intel.com>
To: Neil Horman <nhorman@tuxdriver.com>, Wolfram Sang <wsa@the-dreams.de>,
        linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Seth Heasley <seth.heasley@intel.com>,
        James Ralston <james.d.ralston@intel.com>
Subject: [PATCH 1/1] i2c: iSMT SMBus patch for Intel Avoton DeviceIDs
Date: Thu, 21 Feb 2013 14:30:43 -0800
Message-Id: <1361485843-13560-1-git-send-email-seth.heasley@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the iSMT SMBus Controller DeviceIDs for the Intel Avoton SOC.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
---
 drivers/i2c/busses/i2c-ismt.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-ismt.c b/drivers/i2c/busses/i2c-ismt.c
index 3f7a9cb..45bccf1 100644
--- a/drivers/i2c/busses/i2c-ismt.c
+++ b/drivers/i2c/busses/i2c-ismt.c
@@ -80,6 +80,7 @@
 /* PCI DIDs for the Intel SMBus Message Transport (SMT) Devices */
 #define PCI_DEVICE_ID_INTEL_S1200_SMT0	0x0c59
 #define PCI_DEVICE_ID_INTEL_S1200_SMT1	0x0c5a
+#define PCI_DEVICE_ID_INTEL_AVOTON_SMT	0x1f15
 
 #define ISMT_DESC_ENTRIES	32	/* number of descriptor entries */
 #define ISMT_MAX_RETRIES	3	/* number of SMBus retries to attempt */
@@ -185,6 +186,7 @@ struct ismt_priv {
 static const DEFINE_PCI_DEVICE_TABLE(ismt_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_S1200_SMT0) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_S1200_SMT1) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_AVOTON_SMT) },
 	{ 0, }
 };
 
-- 
1.7.4.4

