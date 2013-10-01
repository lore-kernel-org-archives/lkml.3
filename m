Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab3JAV3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 17:29:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:59926 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab3JAV3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 17:29:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1015,1371106800"; 
   d="scan'208";a="368456719"
From: David Cohen <david.a.cohen@linux.intel.com>
To: alexander.shishkin@linux.intel.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v2 2/2] usb: chipidea: add Intel Clovertrail pci id
Date: Tue,  1 Oct 2013 14:32:58 -0700
Message-Id: <1380663178-24218-2-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380663178-24218-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1380663178-24218-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/chipidea/ci_hdrc_pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/chipidea/ci_hdrc_pci.c b/drivers/usb/chipidea/ci_hdrc_pci.c
index 08a724b..d514332 100644
--- a/drivers/usb/chipidea/ci_hdrc_pci.c
+++ b/drivers/usb/chipidea/ci_hdrc_pci.c
@@ -129,6 +129,11 @@ static DEFINE_PCI_DEVICE_TABLE(ci_hdrc_pci_id_table) = {
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0829),
 		.driver_data = (kernel_ulong_t)&penwell_pci_platdata,
 	},
+	{
+		/* Intel Clovertrail */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe006),
+		.driver_data = (kernel_ulong_t)&penwell_pci_platdata,
+	},
 	{ 0 } /* end: all zeroes */
 };
 MODULE_DEVICE_TABLE(pci, ci_hdrc_pci_id_table);
-- 
1.8.4.rc3

