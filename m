Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaIHJjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 05:39:36 -0400
Received: from mail-bn1on0070.outbound.protection.outlook.com ([157.56.110.70]:41568
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753974AbaIHJjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 05:39:32 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH v3 27/29] MAINTAINERS: Add nios2 maintainer
Date: Mon, 8 Sep 2014 17:22:38 +0800
Message-ID: <1410168160-3624-28-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1410168160-3624-1-git-send-email-lftan@altera.com>
References: <1410168160-3624-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009017)(6009001)(199003)(189002)(74502001)(76482001)(74662001)(77096002)(85852003)(33646002)(68736004)(50466002)(93916002)(2201001)(92566001)(77156001)(107046002)(229853001)(92726001)(89996001)(46102001)(31966008)(95666004)(90102001)(88136002)(50986999)(87936001)(85306004)(79102001)(87286001)(86362001)(4396001)(106466001)(104166001)(105596002)(44976005)(77982001)(81542001)(42186005)(47776003)(48376002)(83072002)(80022001)(62966002)(84676001)(20776003)(36756003)(6806004)(50226001)(102836001)(83322001)(76176999)(19580395003)(81342001)(21056001)(99396002)(97736003)(19580405001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN2PR03MB047;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03283976A6
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
index cf24bb5..01a509c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6423,6 +6423,13 @@ S:	Maintained
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
 M:	Jon Mason <jon.mason@intel.com>
 S:	Supported
-- 
1.8.2.1

