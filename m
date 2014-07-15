Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530AbaGOIsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 04:48:55 -0400
Received: from mail-by2lp0239.outbound.protection.outlook.com ([207.46.163.239]:16394
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932452AbaGOIsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:48:46 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH v2 28/29] Documentation: Add documentation for Nios2 architecture
Date: Tue, 15 Jul 2014 16:45:55 +0800
Message-ID: <1405413956-2772-29-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405413956-2772-1-git-send-email-lftan@altera.com>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(106466001)(84676001)(93916002)(79102001)(99396002)(64706001)(229853001)(15975445006)(105596002)(62966002)(95666004)(104166001)(85306003)(19580395003)(86362001)(2201001)(47776003)(15202345003)(97736001)(107046002)(21056001)(36756003)(77156001)(76482001)(76176999)(50986999)(80022001)(77982001)(19580405001)(74662001)(85852003)(46102001)(88136002)(92726001)(68736004)(42186005)(48376002)(81342001)(83322001)(81542001)(50226001)(77096002)(4396001)(102836001)(87936001)(89996001)(87286001)(20776003)(44976005)(83072002)(92566001)(31966008)(74502001)(6806004)(33646002)(19627235001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB307;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
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
 Documentation/nios2/README | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 Documentation/nios2/README

diff --git a/Documentation/nios2/README b/Documentation/nios2/README
new file mode 100644
index 0000000..054a67d
--- /dev/null
+++ b/Documentation/nios2/README
@@ -0,0 +1,23 @@
+Linux on the Nios II architecture
+=================================
+
+This is a port of Linux to Nios II (nios2) processor.
+
+In order to compile for Nios II, you need a version of GCC with support for the generic
+system call ABI. Please see this link for more information on how compiling and booting
+software for the Nios II platform:
+http://www.rocketboards.org/foswiki/Documentation/NiosIILinuxUserManual
+
+For reference, please see the following link:
+http://www.altera.com/literature/lit-nio2.jsp
+
+What is Nios II?
+================
+Nios II is a 32-bit embedded-processor architecture designed specifically for the
+Altera family of FPGAs. In order to support Linux, Nios II needs to be configured
+with MMU and hardware multiplier enabled.
+
+Nios II ABI
+===========
+Please refer to chapter "Application Binary Interface" in Nios II Processor Reference
+Handbook.
-- 
1.8.2.1

