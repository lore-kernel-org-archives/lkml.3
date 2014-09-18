Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbaIRFRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 01:17:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:14198 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbaIRFQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 01:16:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,544,1406617200"; 
   d="scan'208";a="604607010"
From: "David E. Box" <david.e.box@linux.intel.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 1/3] x86: iosf: Add Braswell PCI ID
Date: Wed, 17 Sep 2014 22:13:49 -0700
Message-Id: <1411017231-20807-2-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411017231-20807-1-git-send-email-david.e.box@linux.intel.com>
References: <1411017231-20807-1-git-send-email-david.e.box@linux.intel.com>
In-Reply-To: <1410924386-16977-1-git-send-email-david.e.box@linux.intel.com>
References: <1410924386-16977-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Braswell PCI ID to list of supported ID's for iosf driver.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
---
 arch/x86/kernel/iosf_mbi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/iosf_mbi.c b/arch/x86/kernel/iosf_mbi.c
index 0a2faa3..e01f741 100644
--- a/arch/x86/kernel/iosf_mbi.c
+++ b/arch/x86/kernel/iosf_mbi.c
@@ -28,6 +28,7 @@
 #include <asm/iosf_mbi.h>
 
 #define PCI_DEVICE_ID_BAYTRAIL		0x0F00
+#define PCI_DEVICE_ID_BRASWELL		0x2280
 #define PCI_DEVICE_ID_QUARK_X1000	0x0958
 
 static DEFINE_SPINLOCK(iosf_mbi_lock);
@@ -275,6 +276,7 @@ static int iosf_mbi_probe(struct pci_dev *pdev,
 
 static const struct pci_device_id iosf_mbi_pci_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_BAYTRAIL) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_BRASWELL) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_QUARK_X1000) },
 	{ 0, },
 };
-- 
1.9.1

