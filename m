Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbaJHJdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:33:40 -0400
Received: from mail-bn1on0062.outbound.protection.outlook.com ([157.56.110.62]:5888
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755839AbaJHJcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:32:12 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        <lftan.linux@gmail.com>, <cltang@codesourcery.com>
Subject: [PATCH v4 27/29] MAINTAINERS: Add nios2 maintainer
Date: Wed, 8 Oct 2014 17:29:53 +0800
Message-ID: <1412760595-3935-28-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1412760595-3935-1-git-send-email-lftan@altera.com>
References: <1412760595-3935-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(31966008)(76482002)(120916001)(77156001)(36756003)(50986999)(102836001)(44976005)(20776003)(104166001)(6806004)(47776003)(19580405001)(64706001)(85306004)(85852003)(42186005)(99396003)(19580395003)(68736004)(92566001)(33646002)(86362001)(93916002)(92726001)(2201001)(84676001)(77096002)(229853001)(97736003)(48376002)(50466002)(107046002)(88136002)(62966002)(89996001)(21056001)(46102003)(87286001)(87936001)(4396001)(80022003)(95666004)(76176999)(50226001)(105596002)(106466001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB209;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB209;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0358535363
Authentication-Results: spf=softfail (sender IP is 66.35.236.227)
 smtp.mailfrom=lftan@altera.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB211;
X-OriginatorOrg: altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 MAINTAINERS |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a12edf2..580499e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6421,6 +6421,13 @@ S:	Maintained
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
1.7.7.4

