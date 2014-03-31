Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbaCaNYM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:24:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35665 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbaCaNYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:24:07 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Cohen <david.a.cohen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 32/71] usb: dwc3: add support for Merrifield
Date: Mon, 31 Mar 2014 14:22:38 +0100
Message-Id: <1396272197-13394-33-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Cohen <david.a.cohen@linux.intel.com>

commit 85601f8cf67c56a561a6dd5e130e65fdc179047d upstream.

Add PCI id for Intel Merrifield

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/dwc3/dwc3-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 5699bc4..4f31fcb 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -48,6 +48,7 @@
 #define PCI_VENDOR_ID_SYNOPSYS		0x16c3
 #define PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3	0xabcd
 #define PCI_DEVICE_ID_INTEL_BYT		0x0f37
+#define PCI_DEVICE_ID_INTEL_MRFLD	0x119e
 
 struct dwc3_pci {
 	struct device		*dev;
@@ -157,6 +158,7 @@ static DEFINE_PCI_DEVICE_TABLE(dwc3_pci_id_table) = {
 				PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3),
 	},
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_BYT), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRFLD), },
 	{  }	/* Terminating Entry */
 };
 MODULE_DEVICE_TABLE(pci, dwc3_pci_id_table);
-- 
1.9.1

