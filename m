Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbaIRTj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 15:39:26 -0400
Received: from mail-by2on0113.outbound.protection.outlook.com ([207.46.100.113]:22808
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756525AbaIRTjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 15:39:23 -0400
X-WSS-ID: 0NC43WQ-08-4SG-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>, <tglx@linutronix.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <bp@suse.de>,
        <dan.carpenter@oracle.com>, <dougthompson@xmission.com>,
        <bp@alien8.de>, <m.chehab@samsung.com>, <linux-edac@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH 2/4] x86, amd_nb: Add device IDs to NB tables for F15h M60h
Date: Thu, 18 Sep 2014 14:56:45 -0500
Message-ID: <1411070205-10217-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 2.0.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(99396002)(50986999)(97736003)(101416001)(64706001)(50466002)(84676001)(77096002)(90102001)(89996001)(229853001)(20776003)(76482002)(95666004)(4396001)(106466001)(47776003)(21056001)(50226001)(107046002)(87936001)(31966008)(104166001)(105586002)(93916002)(83322001)(62966002)(92566001)(19580405001)(86362001)(79102003)(81342003)(36756003)(85852003)(77982003)(77156001)(44976005)(87286001)(88136002)(48376002)(74662003)(80022003)(92726001)(2201001)(74502003)(53416004)(68736004)(46102003)(85306004)(81542003)(83072002)(19580395003)(1121002)(921003)(2101003)(83996005);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB205;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Forefront-PRVS: 033857D0BD
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add F3 and F4 PCI device IDs to amd_nb_misc_ids[] and
amd_nb_link_ids[] respectively. We need this to cache the
Northbridges.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 arch/x86/kernel/amd_nb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index f04dbb3..5caed1d 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -21,6 +21,7 @@ const struct pci_device_id amd_nb_misc_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F3) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M60H_NB_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_M30H_NB_F3) },
 	{}
@@ -30,6 +31,7 @@ EXPORT_SYMBOL(amd_nb_misc_ids);
 static const struct pci_device_id amd_nb_link_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F4) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M60H_NB_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_M30H_NB_F4) },
 	{}
-- 
2.0.2

