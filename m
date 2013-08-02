Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583Ab3HBWnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 18:43:16 -0400
Received: from mail-db9lp0249.outbound.messaging.microsoft.com ([213.199.154.249]:28152
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670Ab3HBWnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 18:43:13 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VPS4(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hz70kd2iz1de098h8275bh1de097hz2dh668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1155h)
X-WSS-ID: 0MQXDRS-02-3R7-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <dougthompson@xmission.com>, <bp@alien8.de>, <bhelgaas@google.com>,
        <jbeulich@suse.com>, <linux-kernel@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-pci@vger.kernel.org>
CC: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH 1/3 V2] EDAC, AMD64_EDAC: Add PCI Device ID Functions 3 and 4 for newer F15h models.
Date: Fri, 2 Aug 2013 17:43:02 -0500
Message-ID: <1375483384-2302-2-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375483384-2302-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
References: <1375483384-2302-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding PCI_DEVICE_ID_AMD_15H_NB_M30H_F3 and PCI_DEVICE_ID_AMD_15H_NB_M30H_F4
for F15h model 30h. This is required for the file amd_nb.c

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 3bed2e8..d1fe5d0 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -518,6 +518,8 @@
 #define PCI_DEVICE_ID_AMD_11H_NB_MISC	0x1303
 #define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
 #define PCI_DEVICE_ID_AMD_15H_M10H_F3	0x1403
+#define PCI_DEVICE_ID_AMD_15H_M30H_NB_F3 0x141d
+#define PCI_DEVICE_ID_AMD_15H_M30H_NB_F4 0x141e
 #define PCI_DEVICE_ID_AMD_15H_NB_F0	0x1600
 #define PCI_DEVICE_ID_AMD_15H_NB_F1	0x1601
 #define PCI_DEVICE_ID_AMD_15H_NB_F2	0x1602
-- 
1.7.10.4


