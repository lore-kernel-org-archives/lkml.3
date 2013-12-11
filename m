Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab3LKJPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 04:15:48 -0500
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:16108
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751133Ab3LKJPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 04:15:40 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2fh95h839hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh2327h2336h906i1155h)
From: Jagannadha Sutradharudu Teki 
	<jagannadha.sutradharudu-teki@xilinx.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Rob Landley <rob@landley.net>, <linux-pci@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jagannadha Sutradharudu Teki <jaganna@xilinx.com>
Subject: [PATCH 1/2] Documentation: pci: Minor cleanup
Date: Wed, 11 Dec 2013 14:45:18 +0530
X-Mailer: git-send-email 1.8.3
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <4148f6b8-824a-4edc-9b71-fab1e210b7d2@CO1EHSMHS019.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Used small letters for file names
- Renamed few pcie txt files
- Re-arranged file names in 00-INDEX
- Removed PCI-DMA-mapping.txt from 00-INDEX

Signed-off-by: Jagannadha Sutradharudu Teki <jaganna@xilinx.com>
---
 Documentation/PCI/00-INDEX                         | 22 +++++++++++-----------
 .../PCI/{pcieaer-howto.txt => pcie-aer-howto.txt}  |  0
 .../PCI/{pci-iov-howto.txt => pcie-iov-howto.txt}  |  0
 .../{PCIEBUS-HOWTO.txt => pcie-portbus-howto.txt}  |  0
 4 files changed, 11 insertions(+), 11 deletions(-)
 rename Documentation/PCI/{pcieaer-howto.txt => pcie-aer-howto.txt} (100%)
 rename Documentation/PCI/{pci-iov-howto.txt => pcie-iov-howto.txt} (100%)
 rename Documentation/PCI/{PCIEBUS-HOWTO.txt => pcie-portbus-howto.txt} (100%)

diff --git a/Documentation/PCI/00-INDEX b/Documentation/PCI/00-INDEX
index 812b17f..b8b7721 100644
--- a/Documentation/PCI/00-INDEX
+++ b/Documentation/PCI/00-INDEX
@@ -1,14 +1,14 @@
 00-INDEX
 	- this file
-MSI-HOWTO.txt
-	- the Message Signaled Interrupts (MSI) Driver Guide HOWTO and FAQ.
-PCI-DMA-mapping.txt
-	- info for PCI drivers using DMA portably across all platforms
-PCIEBUS-HOWTO.txt
-	- a guide describing the PCI Express Port Bus driver
-pci-error-recovery.txt
-	- info on PCI error recovery
 pci.txt
-	- info on the PCI subsystem for device driver authors
-pcieaer-howto.txt
-	- the PCI Express Advanced Error Reporting Driver Guide HOWTO
+	- Info on the PCI subsystem for device driver authors
+pci-error-recovery.txt
+	- Info on PCI error recovery
+MSI-HOWTO.txt
+	- The Message Signaled Interrupts (MSI) Driver Guide HOWTO and FAQ
+pcie-portbus-howto.txt
+	- A guide describing the PCI Express Port Bus driver
+pcie-aer-howto.txt
+	- The PCI Express Advanced Error Reporting Driver Guide HOWTO
+pcie-iov-howto.txt
+	- Info on PCI Express I/O Virtualization
diff --git a/Documentation/PCI/pcieaer-howto.txt b/Documentation/PCI/pcie-aer-howto.txt
similarity index 100%
rename from Documentation/PCI/pcieaer-howto.txt
rename to Documentation/PCI/pcie-aer-howto.txt
diff --git a/Documentation/PCI/pci-iov-howto.txt b/Documentation/PCI/pcie-iov-howto.txt
similarity index 100%
rename from Documentation/PCI/pci-iov-howto.txt
rename to Documentation/PCI/pcie-iov-howto.txt
diff --git a/Documentation/PCI/PCIEBUS-HOWTO.txt b/Documentation/PCI/pcie-portbus-howto.txt
similarity index 100%
rename from Documentation/PCI/PCIEBUS-HOWTO.txt
rename to Documentation/PCI/pcie-portbus-howto.txt
-- 
1.8.3


