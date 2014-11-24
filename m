Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbaKXL6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 06:58:35 -0500
Received: from mail-bn1on0140.outbound.protection.outlook.com ([157.56.110.140]:12608
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752852AbaKXL6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 06:58:32 -0500
X-WSS-ID: 0NFJL9B-08-96O-02
X-M-MSG: 
From: Huang Rui <ray.huang@amd.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>
CC: <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Huang Rui <ray.huang@amd.com>
Subject: [PATCH] ACPI: Fixed a typo comment
Date: Mon, 24 Nov 2014 19:56:38 +0800
Message-ID: <1416830198-2414-1-git-send-email-ray.huang@amd.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Ray.Huang@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(36756003)(33646002)(229853001)(21056001)(89996001)(48376002)(99396003)(104166001)(105586002)(95666004)(62966003)(77096003)(77156002)(106466001)(107046002)(46102003)(50466002)(87936001)(19580405001)(19580395003)(86362001)(53416004)(97736003)(101416001)(87286001)(50986999)(84676001)(50226001)(31966008)(4396001)(92566001)(92726001)(88136002)(47776003)(120916001)(20776003)(64706001)(44976005)(68736004);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB208;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-Forefront-PRVS: 040513D301
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CO1PR02MB208;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Huang Rui <ray.huang@amd.com>
---
 drivers/acpi/device_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
index 7db1931..076af81 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -201,7 +201,7 @@ int acpi_device_set_power(struct acpi_device *device, int state)
 	 * Transition Power
 	 * ----------------
 	 * In accordance with the ACPI specification first apply power (via
-	 * power resources) and then evalute _PSx.
+	 * power resources) and then evaluate _PSx.
 	 */
 	if (device->power.flags.power_resources) {
 		result = acpi_power_transition(device, state);
-- 
1.7.9.6

