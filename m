Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaKUUIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:08:30 -0500
Received: from mail-bl2on0130.outbound.protection.outlook.com ([65.55.169.130]:55200
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751934AbaKUUI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:08:28 -0500
X-WSS-ID: 0NFENXZ-07-C0T-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: <dri-devel@lists.freedesktop.org>, <jim.epost@gmail.com>
CC: <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <airlied@linux.ie>
Subject: [PATCH] amdkfd: explicitely include io.h in kfd_doorbell.c
Date: Fri, 21 Nov 2014 22:07:59 +0200
Message-ID: <1416600479-5767-1-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(68736004)(50466002)(89996001)(92566001)(101416001)(88136002)(50986999)(84676001)(87936001)(48376002)(19580395003)(31966008)(19580405001)(104166001)(102836001)(44976005)(105586002)(62966003)(64706001)(77096003)(106466001)(77156002)(95666004)(46102003)(97736003)(120916001)(33646002)(229853001)(47776003)(36756003)(53416004)(21056001)(107046002)(99396003)(93916002)(50226001)(87286001)(92726001)(86362001)(4396001)(20776003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB201;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-Forefront-PRVS: 0402872DA1
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR02MB201;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a compilation error when using certain configuration by
including the file io.h in kfd_doorbell.c

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
index 0dcb787..b5791a5 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_doorbell.c
@@ -23,6 +23,7 @@
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/slab.h>
+#include <linux/io.h>
 
 /*
  * This extension supports a kernel level doorbells management for
-- 
2.1.0

