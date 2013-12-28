Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3L1MgW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 07:36:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:36732 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313Ab3L1MgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 07:36:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,566,1384329600"; 
   d="scan'208";a="431007496"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: davem@davemloft.net
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        gospo@redhat.com, sassmann@redhat.com, <linux-kernel@vger.kernel.org>
Subject: [net-next] pci_regs.h: Add PCI bus link speed and width defines
Date: Sat, 28 Dec 2013 04:36:13 -0800
Message-Id: <1388234173-31654-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing PCI bus link speed 8.0 GT/s and bus link widths of
x1, x2, x4 and x8.

CC: <linux-kernel@vger.kernel.org>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 include/uapi/linux/pci_regs.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index 4a98e85..c870c2a 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -489,7 +489,12 @@
 #define  PCI_EXP_LNKSTA_CLS	0x000f	/* Current Link Speed */
 #define  PCI_EXP_LNKSTA_CLS_2_5GB 0x0001 /* Current Link Speed 2.5GT/s */
 #define  PCI_EXP_LNKSTA_CLS_5_0GB 0x0002 /* Current Link Speed 5.0GT/s */
+#define  PCI_EXP_LNKSTA_CLS_8_0GB 0x0003 /* Current Link Speed 8.0GT/s */
 #define  PCI_EXP_LNKSTA_NLW	0x03f0	/* Negotiated Link Width */
+#define  PCI_EXP_LNKSTA_NLW_X1	0x0010	/* Current Link Width x1 */
+#define  PCI_EXP_LNKSTA_NLW_X2	0x0020	/* Current Link Width x2 */
+#define  PCI_EXP_LNKSTA_NLW_X4	0x0040	/* Current Link Width x4 */
+#define  PCI_EXP_LNKSTA_NLW_X8	0x0080	/* Current Link Width x8 */
 #define  PCI_EXP_LNKSTA_NLW_SHIFT 4	/* start of NLW mask in link status */
 #define  PCI_EXP_LNKSTA_LT	0x0800	/* Link Training */
 #define  PCI_EXP_LNKSTA_SLC	0x1000	/* Slot Clock Configuration */
-- 
1.8.3.1

