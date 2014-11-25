Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbaKYLr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:47:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58269 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbaKYKlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:04 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David E. Box" <david.e.box@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 059/254] x86/platform/intel/iosf: Add Braswell PCI ID
Date: Tue, 25 Nov 2014 10:36:49 +0000
Message-Id: <1416912004-5928-60-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David E. Box" <david.e.box@linux.intel.com>

commit 849f5d894383d25c49132437aa289c9a9c98d5df upstream.

Add Braswell PCI ID to list of supported ID's for the IOSF driver.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: http://lkml.kernel.org/r/1411017231-20807-2-git-send-email-david.e.box@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/kernel/iosf_mbi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/iosf_mbi.c b/arch/x86/kernel/iosf_mbi.c
index d30acdc1229d..2e97b3cfa6c7 100644
--- a/arch/x86/kernel/iosf_mbi.c
+++ b/arch/x86/kernel/iosf_mbi.c
@@ -26,6 +26,7 @@
 #include <asm/iosf_mbi.h>
 
 #define PCI_DEVICE_ID_BAYTRAIL		0x0F00
+#define PCI_DEVICE_ID_BRASWELL		0x2280
 #define PCI_DEVICE_ID_QUARK_X1000	0x0958
 
 static DEFINE_SPINLOCK(iosf_mbi_lock);
@@ -204,6 +205,7 @@ static int iosf_mbi_probe(struct pci_dev *pdev,
 
 static DEFINE_PCI_DEVICE_TABLE(iosf_mbi_pci_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_BAYTRAIL) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_BRASWELL) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_QUARK_X1000) },
 	{ 0, },
 };
-- 
2.1.0

