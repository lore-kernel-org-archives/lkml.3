Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab3IRKS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 06:18:58 -0400
Received: from outm2.farsite.co.uk ([82.108.209.243]:18225 "EHLO m.farsite.eu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752184Ab3IRKRN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 06:17:13 -0400
From: Kevin Curtis <Kevin.Curtis@farsite.com>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Dermot Smith <dermot.smith@farsite.com>
Date: Wed, 18 Sep 2013 11:11:41 +0100
Subject: [PATCH 001/007] WAN Drivers: Update farsync driver and introduce
 fsflex driver
Thread-Topic: [PATCH 001/007] WAN Drivers: Update farsync driver and
 introduce fsflex driver
Thread-Index: Ac60V3hVc6oxdW12Rly1AWmCp/5YnQ==
Message-ID: <E603DC592C92B54A89CEF6B0919A0B1CAAAA787DA0@SOLO.hq.farsitecommunications.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-GB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Farsite Communications FarSync driver update

Patch 1 of 7

Add new FarSite PCI ID's to the pci_ids.h file


Signed-off-by: Kevin Curtis <kevin.curtis@farsite.com>

---

diff -uprN -X linux-3.10.1/Documentation/dontdiff linux-3.10.1/include/linux/pci_ids.h linux-3.10.1_new/include/linux/pci_ids.h
--- linux-3.10.1/include/linux/pci_ids.h	2013-07-13 19:42:41.000000000 +0100
+++ linux-3.10.1_new/include/linux/pci_ids.h	2013-07-26 11:18:39.821065185 +0100
@@ -2284,6 +2284,14 @@
 #define PCI_DEVICE_ID_FARSITE_T4U       0x0640
 #define PCI_DEVICE_ID_FARSITE_TE1       0x1610
 #define PCI_DEVICE_ID_FARSITE_TE1C      0x1612
+#define PCI_DEVICE_ID_FARSITE_DSL_S1    0x2610
+#define PCI_DEVICE_ID_FARSITE_T4E       0x3640
+#define PCI_DEVICE_ID_FARSITE_T4UE      0x4640
+#define PCI_DEVICE_ID_FARSITE_T2UE      0x4620
+#define PCI_DEVICE_ID_FARSITE_T2U_PMC   0x6620
+#define PCI_DEVICE_ID_FARSITE_T2Ee      0x5621
+#define PCI_DEVICE_ID_FARSITE_T4Ee      0x5641
+
 
 #define PCI_VENDOR_ID_ARIMA		0x161f

