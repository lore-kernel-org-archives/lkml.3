Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757AbaEIUrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 16:47:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:19672 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757431AbaEIUq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 16:46:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1020,1389772800"; 
   d="scan'208";a="537854903"
From: "David E. Box" <david.e.box@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: Ong Boon Leong <boon.leong.ong@intel.com>, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com,
        david.e.box@linux.intel.com, jacob.jun.pan@linux.intel.com
Subject: [PATCH v4 3/4] arch: x86: iosf_mbi: add Quark X1000 pci id
Date: Fri,  9 May 2014 13:44:07 -0700
Message-Id: <1399668248-24199-4-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399668248-24199-1-git-send-email-david.e.box@linux.intel.com>
References: <1399668248-24199-1-git-send-email-david.e.box@linux.intel.com>
In-Reply-To: <1399052199-8703-1-git-send-email-david.e.box@linux.intel.com>
References: <1399052199-8703-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ong Boon Leong <boon.leong.ong@intel.com>

Add PCI device ID, i.e. that of the Host Bridge,
for IOSF MBI driver.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
---
 arch/x86/kernel/iosf_mbi.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/iosf_mbi.c b/arch/x86/kernel/iosf_mbi.c
index f4ff978..201a7ab 100644
--- a/arch/x86/kernel/iosf_mbi.c
+++ b/arch/x86/kernel/iosf_mbi.c
@@ -201,6 +201,7 @@ static int iosf_mbi_probe(struct pci_dev *pdev,
 
 static DEFINE_PCI_DEVICE_TABLE(iosf_mbi_pci_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0F00) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0958) },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, iosf_mbi_pci_ids);
-- 
1.7.10.4

