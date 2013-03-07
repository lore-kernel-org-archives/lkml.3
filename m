Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab3CGO3K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 09:29:10 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:39262 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758747Ab3CGO3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 09:29:06 -0500
From: yxlraid@gmail.com
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiangliang Yu <yuxiangl@marvell.com>
Subject: [PATCH 1/2] PCI: define macro for marvell vendor ID
Date: Thu,  7 Mar 2013 22:28:43 +0800
Message-Id: <1362666523-9961-1-git-send-email-yxlraid@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiangliang Yu <yuxiangl@marvell.com>

Define PCI_VENDOR_MARVELL_ID_EXT macro for 0x1b4b vendor ID
---
 include/linux/pci_ids.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index f11c1c2..a80f9e6 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1604,6 +1604,7 @@
 #define PCI_SUBDEVICE_ID_KEYSPAN_SX2	0x5334
 
 #define PCI_VENDOR_ID_MARVELL		0x11ab
+#define PCI_VENDOR_ID_MARVELL_EXT	0x1b4b
 #define PCI_DEVICE_ID_MARVELL_GT64111	0x4146
 #define PCI_DEVICE_ID_MARVELL_GT64260	0x6430
 #define PCI_DEVICE_ID_MARVELL_MV64360	0x6460
-- 
1.7.5.4

