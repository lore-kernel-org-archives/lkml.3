Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbaISLtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:49:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56350 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049AbaISLtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:49:35 -0400
Date: Fri, 19 Sep 2014 04:49:24 -0700
From: "tip-bot for David E. Box" <tipbot@zytor.com>
Message-ID: <tip-849f5d894383d25c49132437aa289c9a9c98d5df@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.e.box@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.e.box@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1411017231-20807-2-git-send-email-david.e.box@linux.intel.com>
References: <1411017231-20807-2-git-send-email-david.e.box@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/platform/intel/iosf: Add Braswell PCI ID
Git-Commit-ID: 849f5d894383d25c49132437aa289c9a9c98d5df
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  849f5d894383d25c49132437aa289c9a9c98d5df
Gitweb:     http://git.kernel.org/tip/849f5d894383d25c49132437aa289c9a9c98d5df
Author:     David E. Box <david.e.box@linux.intel.com>
AuthorDate: Wed, 17 Sep 2014 22:13:49 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 19 Sep 2014 13:08:42 +0200

x86/platform/intel/iosf: Add Braswell PCI ID

Add Braswell PCI ID to list of supported ID's for the IOSF driver.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: http://lkml.kernel.org/r/1411017231-20807-2-git-send-email-david.e.box@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
