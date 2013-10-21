Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab3JUIwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:52:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39662 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753994Ab3JUIv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Cohen" <david.a.cohen@linux.intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.367003786@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 093/149] usb: dwc3: add support for Merrifield
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: David Cohen <david.a.cohen@linux.intel.com>

commit 85601f8cf67c56a561a6dd5e130e65fdc179047d upstream.

Add PCI id for Intel Merrifield

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/dwc3/dwc3-pci.c | 2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -46,6 +46,7 @@
 #define PCI_VENDOR_ID_SYNOPSYS		0x16c3
 #define PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3	0xabcd
 #define PCI_DEVICE_ID_INTEL_BYT		0x0f37
+#define PCI_DEVICE_ID_INTEL_MRFLD	0x119e
 
 #define DWC3_PCI_DEVS_POSSIBLE	32
 
@@ -193,6 +194,7 @@ static DEFINE_PCI_DEVICE_TABLE(dwc3_pci_
 				PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3),
 	},
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_BYT), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRFLD), },
 	{  }	/* Terminating Entry */
 };
 MODULE_DEVICE_TABLE(pci, dwc3_pci_id_table);

