Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaKCKzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:55:24 -0500
Received: from mail-by2on0068.outbound.protection.outlook.com ([207.46.100.68]:45504
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752590AbaKCKzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:55:18 -0500
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v6 27/29] MAINTAINERS: Add nios2 maintainer
Date: Mon, 3 Nov 2014 18:52:23 +0800
Message-ID: <1415011945-3297-28-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415011945-3297-1-git-send-email-lftan@altera.com>
References: <1415011945-3297-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(86362001)(68736004)(104166001)(31966008)(93916002)(50466002)(2201001)(84676001)(92566001)(92726001)(33646002)(48376002)(97736003)(89996001)(99396003)(50226001)(4396001)(62966003)(120916001)(88136002)(44976005)(42186005)(87286001)(87936001)(76176999)(64706001)(47776003)(107046002)(46102003)(229853001)(20776003)(95666004)(6806004)(19580405001)(21056001)(102836001)(50986999)(36756003)(19580395003)(77096003)(106466001)(77156002)(105596002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB210;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB210;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0384275935
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3c64271..023ab87 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6544,6 +6544,13 @@ S:	Maintained
 F:	Documentation/scsi/NinjaSCSI.txt
 F:	drivers/scsi/nsp32*
 
+NIOS2 ARCHITECTURE
+M:	Ley Foon Tan <lftan@altera.com>
+L:	nios2-dev@lists.rocketboards.org (moderated for non-subscribers)
+T:	git git://git.rocketboards.org/linux-socfpga.git
+S:	Maintained
+F:	arch/nios2/
+
 NTB DRIVER
 M:	Jon Mason <jdmason@kudzu.us>
 M:	Dave Jiang <dave.jiang@intel.com>
-- 
1.8.2.1

