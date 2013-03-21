Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab3CUEmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 00:42:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab3CUEmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 00:42:23 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 1/3] PCI: Define macro for Marvell vendor ID
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, yuxiangl@marvell.com, yxlraid@gmail.com,
        greg@kroah.com, alex.williamson@redhat.com, kay@vrfy.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 22:34:56 -0600
Message-ID: <20130321043456.7229.40987.stgit@amt.stowe>
In-Reply-To: <20130321043449.7229.81056.stgit@amt.stowe>
References: <20130321043449.7229.81056.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiangliang Yu <yuxiangl@marvell.com>

Define PCI_VENDOR_ID_MARVELL_EXT macro for 0x1b4b vendor ID

Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
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

