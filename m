Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab3GPPZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:25:39 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:56315 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932445Ab3GPPZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:25:34 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: linux-pci@vger.kernel.org, linux-serial@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 4/4] pci_ids.h: remove PCI_VENDOR_ID_ADDIDATA_OLD and PCI_DEVICE_ID_ADDIDATA_APCI7800
Date: Tue, 16 Jul 2013 16:14:41 +0100
Message-Id: <1373987681-18245-5-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1373987681-18245-1-git-send-email-abbotti@mev.co.uk>
References: <1373987681-18245-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two defines are no longer used.  They were only used by the PCI
serial driver "8250_pci" to support the original ADDI-DATA APCI-7800
card.  In that driver, PCI_VENDOR_ID_ADDIDATA_OLD has been replaced with
PCI_VENDOR_ID_AMCC which has the same value (0x10e8), and
PCI_DEVICE_ID_ADDIDATA_APCI7800 has been replaced with a local #define
PCI_DEVICE_ID_AMCC_ADDIDATA_APCI7800 with the same value (0x818e).

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 include/linux/pci_ids.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 9d99119..6dec3d6 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2258,12 +2258,10 @@
 /*
  * ADDI-DATA GmbH communication cards <info@addi-data.com>
  */
-#define PCI_VENDOR_ID_ADDIDATA_OLD             0x10E8	/* actually AMCC */
 #define PCI_VENDOR_ID_ADDIDATA                 0x15B8
 #define PCI_DEVICE_ID_ADDIDATA_APCI7500        0x7000
 #define PCI_DEVICE_ID_ADDIDATA_APCI7420        0x7001
 #define PCI_DEVICE_ID_ADDIDATA_APCI7300        0x7002
-#define PCI_DEVICE_ID_ADDIDATA_APCI7800        0x818E
 #define PCI_DEVICE_ID_ADDIDATA_APCI7500_2      0x7009
 #define PCI_DEVICE_ID_ADDIDATA_APCI7420_2      0x700A
 #define PCI_DEVICE_ID_ADDIDATA_APCI7300_2      0x700B
-- 
1.8.2.1

