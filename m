Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaDCOt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 10:49:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:33265 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbaDCOtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 10:49:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,787,1389772800"; 
   d="scan'208";a="486566048"
From: "Dugger, Donald D" <donald.d.dugger@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] PCI: Add Patsburg (X79) to Intel PCH root port ACS quirk
Thread-Topic: [PATCH] PCI: Add Patsburg (X79) to Intel PCH root port ACS
 quirk
Thread-Index: AQHPTQ4Yp1TC9gVPMkGAkjmrold1gJr//DsQ
Date: Thu, 3 Apr 2014 14:45:20 +0000
Message-ID: <6AF484C0160C61439DE06F17668F3BCB528CD050@ORSMSX102.amr.corp.intel.com>
References: <20140331182113.23398.38246.stgit@bling.home>
In-Reply-To: <20140331182113.23398.38246.stgit@bling.home>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s33EnbRE018129

Acked-by: Don Dugger <donald.d.dugger@intel.com>


-----Original Message-----
From: Alex Williamson [mailto:alex.williamson@redhat.com] 
Sent: Monday, March 31, 2014 12:22 PM
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org; Dugger, Donald D
Subject: [PATCH] PCI: Add Patsburg (X79) to Intel PCH root port ACS quirk

Intel has updated Red Hat bz1037684 to note that X79 PCH root ports also provide isolation and the same ACS quirks apply.  Some sources indicate additional device IDs for X79, but this patch includes only the ones specifically identified by Intel:
https://bugzilla.redhat.com/show_bug.cgi?id=1037684#c11

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: Don Dugger <donald.d.dugger@intel.com>
---
 drivers/pci/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c index e729206..5e4ac63 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3453,6 +3453,8 @@ static const u16 pci_quirk_intel_pch_acs_ids[] = {
 	/* Wildcat PCH */
 	0x9c90, 0x9c91, 0x9c92, 0x9c93, 0x9c94, 0x9c95, 0x9c96, 0x9c97,
 	0x9c98, 0x9c99, 0x9c9a, 0x9c9b,
+	/* Patsburg (X79) PCH */
+	0x1d10, 0x1d12, 0x1d14, 0x1d16, 0x1d18, 0x1d1a, 0x1d1c, 0x1d1e,
 };
 
 static bool pci_quirk_intel_pch_acs_match(struct pci_dev *dev)

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
