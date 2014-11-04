Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292AbaKDRcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 12:32:55 -0500
Received: from mail-by2on0106.outbound.protection.outlook.com ([207.46.100.106]:40856
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750985AbaKDRcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 12:32:53 -0500
X-WSS-ID: 0NEIZEM-07-CW5-02
X-M-MSG: 
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
To: <herrmann.der.user@googlemail.com>, <jdelvare@suse.de>,
        <linux@roeck-us.net>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
CC: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Subject: [PATCH] hwmon, fam15h_power: Fix NB device ID for F16h M30h
Date: Tue, 4 Nov 2014 11:49:02 -0600
Message-ID: <1415123342-11368-1-git-send-email-aravind.gopalakrishnan@amd.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(53416004)(89996001)(68736004)(120916001)(93916002)(19580395003)(19580405001)(101416001)(97736003)(33646002)(105586002)(106466001)(95666004)(88136002)(4396001)(50226001)(77096003)(77156002)(62966003)(64706001)(50466002)(46102003)(102836001)(107046002)(86362001)(36756003)(20776003)(92566001)(48376002)(50986999)(84676001)(104166001)(44976005)(21056001)(47776003)(229853001)(92726001)(2201001)(31966008)(87286001)(99396003)(87936001)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB205;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB205;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 03853D523D
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

F3 device ID is wrongly included in fam15h_power_id_table
for F16h M30h. It should be F4 device ID. Fix this.

Signed-off-by: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
---
 drivers/hwmon/fam15h_power.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
index fcdbde4..3057dfc 100644
--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -234,7 +234,7 @@ static const struct pci_device_id fam15h_power_id_table[] = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F4) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
-	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_M30H_NB_F3) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_M30H_NB_F4) },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, fam15h_power_id_table);
-- 
2.1.0

