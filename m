Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607AbaGOIto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 04:49:44 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:22397
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932461AbaGOItA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:49:00 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH v2 27/29] MAINTAINERS: Add nios2 maintainer
Date: Tue, 15 Jul 2014 16:45:54 +0800
Message-ID: <1405413956-2772-28-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405413956-2772-1-git-send-email-lftan@altera.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(31966008)(64706001)(79102001)(102836001)(229853001)(83322001)(21056001)(87286001)(44976005)(99396002)(89996001)(50986999)(76176999)(20776003)(19580395003)(106466001)(104166001)(105596002)(74502001)(46102001)(33646002)(77982001)(85306003)(2201001)(95666004)(84676001)(85852003)(107046002)(77096002)(81342001)(42186005)(97736001)(19580405001)(81542001)(93916002)(92726001)(4396001)(50226001)(36756003)(62966002)(92566001)(87936001)(77156001)(76482001)(47776003)(86362001)(74662001)(6806004)(88136002)(68736004)(80022001)(48376002)(83072002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB309;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027367F73D
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
index e31c874..db2bdf1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6350,6 +6350,13 @@ S:	Maintained
 F:	Documentation/scsi/NinjaSCSI.txt
 F:	drivers/scsi/nsp32*
 
+NIOS2 ARCHITECTURE
+M:	Ley Foon Tan <lftan@altera.com>
+L:	nios2-dev@lists.rocketboards.org (moderated for non-subscribers)
+T:	git://git.rocketboards.org/linux-socfpga.git
+S:	Maintained
+F:	arch/nios2/
+
 NTB DRIVER
 M:	Jon Mason <jon.mason@intel.com>
 S:	Supported
-- 
1.8.2.1

