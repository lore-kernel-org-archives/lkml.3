Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455Ab3LERiT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:38:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38418 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956Ab3LERiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:38:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Xiangliang Yu <yuxiangl@marvell.com>, Myron Stowe <myron.stowe@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 76/90] PCI: Define macro for Marvell vendor ID
Date: Thu,  5 Dec 2013 17:35:58 +0000
Message-Id: <1386264972-5399-77-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiangliang Yu <yuxiangl@marvell.com>

commit 8e7ee6f5dfb56a32da760d990be908ed35b1c5bf upstream.

Define PCI_VENDOR_ID_MARVELL_EXT macro for 0x1b4b vendor ID

Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/pci_ids.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index a3f8d6d..5066e76 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1602,6 +1602,7 @@
 #define PCI_SUBDEVICE_ID_KEYSPAN_SX2	0x5334
 
 #define PCI_VENDOR_ID_MARVELL		0x11ab
+#define PCI_VENDOR_ID_MARVELL_EXT	0x1b4b
 #define PCI_DEVICE_ID_MARVELL_GT64111	0x4146
 #define PCI_DEVICE_ID_MARVELL_GT64260	0x6430
 #define PCI_DEVICE_ID_MARVELL_MV64360	0x6460
-- 
1.8.3.2

