Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab3JCET1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:19:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47209 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab3JCETX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:19:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 37/57] usb: dwc3: pci: add support for BayTrail
Date: Wed,  2 Oct 2013 21:09:03 -0700
Message-Id: <20131003040639.137386748@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

commit b62cd96de3161dfb125a769030eec35a4cab3d3a upstream.

Add PCI id for Intel BayTrail.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/dwc3-pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -48,6 +48,7 @@
 /* FIXME define these in <linux/pci_ids.h> */
 #define PCI_VENDOR_ID_SYNOPSYS		0x16c3
 #define PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3	0xabcd
+#define PCI_DEVICE_ID_INTEL_BYT		0x0f37
 
 struct dwc3_pci {
 	struct device		*dev;
@@ -207,6 +208,7 @@ static DEFINE_PCI_DEVICE_TABLE(dwc3_pci_
 		PCI_DEVICE(PCI_VENDOR_ID_SYNOPSYS,
 				PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3),
 	},
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_BYT), },
 	{  }	/* Terminating Entry */
 };
 MODULE_DEVICE_TABLE(pci, dwc3_pci_id_table);


