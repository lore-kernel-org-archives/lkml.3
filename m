Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbaIRTix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 15:38:53 -0400
Received: from mail-bn1on0117.outbound.protection.outlook.com ([157.56.110.117]:44573
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756417AbaIRTiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 15:38:50 -0400
X-WSS-ID: 0NC43WK-07-PPL-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>, <tglx@linutronix.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <bp@suse.de>,
        <dan.carpenter@oracle.com>, <dougthompson@xmission.com>,
        <bp@alien8.de>, <m.chehab@samsung.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH 1/4] pci_ids: Add PCI device IDs for F15h M60h
Date: Thu, 18 Sep 2014 14:56:35 -0500
Message-ID: <1411070195-10177-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 2.0.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(21056001)(50986999)(19580405001)(62966002)(88136002)(99396002)(575784001)(87936001)(77096002)(93916002)(101416001)(31966008)(229853001)(20776003)(85852003)(36756003)(97736003)(89996001)(83322001)(83072002)(50226001)(84676001)(95666004)(77156001)(92566001)(74662003)(87286001)(85306004)(44976005)(106466001)(47776003)(107046002)(79102003)(4396001)(86362001)(81342003)(19580395003)(104166001)(105586002)(76482002)(68736004)(92726001)(64706001)(77982003)(2201001)(53416004)(74502003)(48376002)(46102003)(90102001)(80022003)(81542003)(50466002)(1121002)(921003)(83996005)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB199;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033857D0BD
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add F3, F4 device IDs to be used in amd_nb.c and amd64_edac.c

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 include/linux/pci_ids.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index aa0d390..6a2a72a 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -522,6 +522,8 @@
 #define PCI_DEVICE_ID_AMD_15H_M10H_F3	0x1403
 #define PCI_DEVICE_ID_AMD_15H_M30H_NB_F3 0x141d
 #define PCI_DEVICE_ID_AMD_15H_M30H_NB_F4 0x141e
+#define PCI_DEVICE_ID_AMD_15H_M60H_NB_F3 0x1573
+#define PCI_DEVICE_ID_AMD_15H_M60H_NB_F4 0x1574
 #define PCI_DEVICE_ID_AMD_15H_NB_F0	0x1600
 #define PCI_DEVICE_ID_AMD_15H_NB_F1	0x1601
 #define PCI_DEVICE_ID_AMD_15H_NB_F2	0x1602
-- 
2.0.2

