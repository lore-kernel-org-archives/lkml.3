Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbaDRMvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:51:14 -0400
Received: from mail-bn1bon0132.outbound.protection.outlook.com ([157.56.111.132]:7334
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753123AbaDRMnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:43:15 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH 27/28] MAINTAINERS: Add nios2 maintainer
Date: Fri, 18 Apr 2014 20:27:10 +0800
Message-ID: <1397824031-4892-24-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397824031-4892-1-git-send-email-lftan@altera.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(189002)(199002)(83072002)(76482001)(74502001)(85852003)(20776003)(47776003)(42186004)(77156001)(84676001)(99396002)(2009001)(87286001)(88136002)(16796002)(31966008)(74662001)(89996001)(19580395003)(44976005)(36756003)(6806004)(2201001)(87936001)(77982001)(92566001)(19580405001)(83322001)(92726001)(4396001)(46102001)(50466002)(80022001)(97736001)(86362001)(93916002)(50226001)(81342001)(50986999)(48376002)(81542001)(76176999)(80976001)(62966002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB032;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:2BFE1066.824AA8C.4FD7B7EB.8BC59A80.2012D;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 018577E36E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 80399ff..389f3d5315b69660060f34617df402e27323c543 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6247,6 +6247,13 @@ S:	Maintained
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
1.8.3.2

