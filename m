Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaGJVdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:33:35 -0400
Received: from mail-bn1blp0190.outbound.protection.outlook.com ([207.46.163.190]:32554
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751343AbaGJVde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:33:34 -0400
X-WSS-ID: 0N8IMJS-07-IUH-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <herrmann.der.user@googlemail.com>, <jdelvare@suse.de>,
        <linux@roeck-us.net>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
CC: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH] hwmon, fam15h_power: Remove needless pci dev id
Date: Thu, 10 Jul 2014 17:16:00 -0500
Message-ID: <1405030560-2128-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(101416001)(50986999)(46102001)(92566001)(77156001)(62966002)(105586002)(19580405001)(68736004)(77096002)(44976005)(74662001)(80022001)(99396002)(74502001)(85852003)(102836001)(36756003)(76482001)(31966008)(48376002)(87936001)(89996001)(81342001)(88136002)(81542001)(21056001)(64706001)(4396001)(79102001)(97736001)(53416004)(50226001)(2201001)(92726001)(86362001)(229853001)(93916002)(107046002)(104166001)(77982001)(20776003)(83322001)(95666004)(50466002)(84676001)(85306003)(47776003)(106466001)(83072002)(19580395003)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB037;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0268246AE7
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI_DEVICE_ID_AMD_16H_NB_F4 can be obtained from it's
definition in pci_ids.h. So we don't have to define it
again here.

Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 drivers/hwmon/fam15h_power.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
index 6040121..d442000 100644
--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -31,9 +31,6 @@ MODULE_DESCRIPTION("AMD Family 15h CPU processor power monitor");
 MODULE_AUTHOR("Andreas Herrmann <herrmann.der.user@googlemail.com>");
 MODULE_LICENSE("GPL");
 
-/* Family 16h Northbridge's function 4 PCI ID */
-#define PCI_DEVICE_ID_AMD_16H_NB_F4	0x1534
-
 /* D18F3 */
 #define REG_NORTHBRIDGE_CAP		0xe8
 
-- 
1.8.1.2

