Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbbAVTo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:44:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:20761 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbbAVToZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:44:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,450,1418112000"; 
   d="scan'208";a="655077539"
From: "Dugger, Donald D" <donald.d.dugger@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC: "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] PCI: Add Wellsburg (X99) to Intel PCH root port ACS
 quirk
Thread-Topic: [PATCH] PCI: Add Wellsburg (X99) to Intel PCH root port ACS
 quirk
Thread-Index: AQHQNnEOxOUUpyxvgEq2jahlkIAfeZzMio4w
Date: Thu, 22 Jan 2015 19:44:22 +0000
Message-ID: <6AF484C0160C61439DE06F17668F3BCB5348FE8C@ORSMSX114.amr.corp.intel.com>
References: <20150122181524.1586.14496.stgit@gimli.home>
In-Reply-To: <20150122181524.1586.14496.stgit@gimli.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0MJiYKY029206

Ack-by: Don Dugger <donald.d.dugger@intel.com>

--
Don Dugger
"Censeo Toto nos in Kansa esse decisse." - D. Gale
Ph: 303/443-3786

-----Original Message-----
From: Alex Williamson [mailto:alex.williamson@redhat.com] 
Sent: Thursday, January 22, 2015 11:16 AM
To: linux-pci@vger.kernel.org
Cc: bhelgaas@google.com; Dugger, Donald D; linux-kernel@vger.kernel.org
Subject: [PATCH] PCI: Add Wellsburg (X99) to Intel PCH root port ACS quirk

Intel has confirmed that the Wellsburg chipset, while not reporting ACS, does provide the proper isolation through the RCBA/BSPR registers, so the same quirk works for this set of device IDs.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: Don Dugger <donald.d.dugger@intel.com>
---

 drivers/pci/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c index ed6f89b..2cdb789 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3630,6 +3630,9 @@ static const u16 pci_quirk_intel_pch_acs_ids[] = {
 	0x9c98, 0x9c99, 0x9c9a, 0x9c9b,
 	/* Patsburg (X79) PCH */
 	0x1d10, 0x1d12, 0x1d14, 0x1d16, 0x1d18, 0x1d1a, 0x1d1c, 0x1d1e,
+	/* Wellsburg (X99) PCH */
+	0x8d10, 0x8d11, 0x8d12, 0x8d13, 0x8d14, 0x8d15, 0x8d16, 0x8d17,
+	0x8d18, 0x8d19, 0x8d1a, 0x8d1b, 0x8d1c, 0x8d1d, 0x8d1e,
 };
 
 static bool pci_quirk_intel_pch_acs_match(struct pci_dev *dev)

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
