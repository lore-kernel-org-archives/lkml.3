Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725AbaIBKqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:46:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:13744 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbaIBKp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:45:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,448,1406617200"; 
   d="scan'208";a="593283432"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: Josef Ahmad <josef.ahmad@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 2/4] pci_ids: add support for Intel Quark ILB
Date: Tue,  2 Sep 2014 13:45:20 +0300
Message-Id: <1409654722-6570-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409654722-6570-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1409654722-6570-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josef Ahmad <josef.ahmad@intel.com>

This patch adds the PCI id for Intel Quark ILB.
It will be used for GPIO and Multifunction device driver.

Signed-off-by: Josef Ahmad <josef.ahmad@intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 include/linux/pci_ids.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 6ed0bb7..4e82195 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2557,6 +2557,7 @@
 #define PCI_DEVICE_ID_INTEL_MFD_EMMC0	0x0823
 #define PCI_DEVICE_ID_INTEL_MFD_EMMC1	0x0824
 #define PCI_DEVICE_ID_INTEL_MRST_SD2	0x084F
+#define PCI_DEVICE_ID_INTEL_QUARK_X1000_ILB	0x095E
 #define PCI_DEVICE_ID_INTEL_I960	0x0960
 #define PCI_DEVICE_ID_INTEL_I960RM	0x0962
 #define PCI_DEVICE_ID_INTEL_CENTERTON_ILB	0x0c60
-- 
2.1.0

