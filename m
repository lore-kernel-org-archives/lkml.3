Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaKUUkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:40:39 -0500
Received: from mail-by2on0114.outbound.protection.outlook.com ([207.46.100.114]:13760
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751911AbaKUUki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:40:38 -0500
X-WSS-ID: 0NFEPFI-08-0SG-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: <dri-devel@lists.freedesktop.org>
CC: <bp@alien8.de>, <pebolle@tiscali.nl>, <linux-kernel@vger.kernel.org>,
        <airlied@linux.ie>, <alexander.deucher@amd.com>, <j.glisse@gmail.com>,
        <John.Bridgman@amd.com>
Subject: [PATCH] amdkfd: Remove DRM_AMDGPU dependency from Kconfig
Date: Fri, 21 Nov 2014 22:40:17 +0200
Message-ID: <1416602417-7337-1-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(189002)(99396003)(120916001)(97736003)(50986999)(19580395003)(46102003)(68736004)(92566001)(92726001)(4396001)(50226001)(50466002)(47776003)(87936001)(101416001)(48376002)(53416004)(87286001)(44976005)(31966008)(20776003)(19580405001)(89996001)(84676001)(102836001)(110136001)(104166001)(64706001)(33646002)(77156002)(86362001)(105586002)(88136002)(229853001)(62966003)(106466001)(2351001)(107046002)(21056001)(93916002)(77096003)(95666004)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB198;H:atltwp02.amd.com;FPR:;SPF:None;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB198;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB198;
X-Forefront-PRVS: 0402872DA1
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB198;
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/amd/amdkfd/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/Kconfig b/drivers/gpu/drm/amd/amdkfd/Kconfig
index e13c67c..8dfac37 100644
--- a/drivers/gpu/drm/amd/amdkfd/Kconfig
+++ b/drivers/gpu/drm/amd/amdkfd/Kconfig
@@ -4,6 +4,6 @@
 
 config HSA_AMD
 	tristate "HSA kernel driver for AMD GPU devices"
-	depends on (DRM_RADEON || DRM_AMDGPU) && AMD_IOMMU_V2 && X86_64
+	depends on DRM_RADEON && AMD_IOMMU_V2 && X86_64
 	help
 	  Enable this if you want to use HSA features on AMD GPU devices.
-- 
2.1.0

