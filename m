Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934620AbaKLBno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:43:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934578AbaKLBnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:43:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David E. Box" <david.e.box@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Subject: [PATCH 3.14 119/203] x86/platform/intel/iosf: Add Braswell PCI ID
Date: Wed, 12 Nov 2014 10:16:29 +0900
Message-Id: <20141112011548.132991688@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David E. Box" <david.e.box@linux.intel.com>

commit 849f5d894383d25c49132437aa289c9a9c98d5df upstream.

Add Braswell PCI ID to list of supported ID's for the IOSF driver.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: http://lkml.kernel.org/r/1411017231-20807-2-git-send-email-david.e.box@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/iosf_mbi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/iosf_mbi.c
+++ b/arch/x86/kernel/iosf_mbi.c
@@ -26,6 +26,7 @@
 #include <asm/iosf_mbi.h>
 
 #define PCI_DEVICE_ID_BAYTRAIL		0x0F00
+#define PCI_DEVICE_ID_BRASWELL		0x2280
 #define PCI_DEVICE_ID_QUARK_X1000	0x0958
 
 static DEFINE_SPINLOCK(iosf_mbi_lock);
@@ -204,6 +205,7 @@ static int iosf_mbi_probe(struct pci_dev
 
 static DEFINE_PCI_DEVICE_TABLE(iosf_mbi_pci_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_BAYTRAIL) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_BRASWELL) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_QUARK_X1000) },
 	{ 0, },
 };


