Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbaIHJki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 05:40:38 -0400
Received: from mail-by2on0082.outbound.protection.outlook.com ([207.46.100.82]:58068
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754281AbaIHJkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 05:40:31 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH v3 28/29] Documentation: Add documentation for Nios2 architecture
Date: Mon, 8 Sep 2014 17:22:39 +0800
Message-ID: <1410168160-3624-29-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1410168160-3624-1-git-send-email-lftan@altera.com>
References: <1410168160-3624-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009017)(6009001)(189002)(199003)(6806004)(81342001)(89996001)(85306004)(4396001)(99396002)(87286001)(86362001)(95666004)(33646002)(80022001)(44976005)(19580405001)(68736004)(83322001)(19580395003)(90102001)(42186005)(36756003)(20776003)(47776003)(77096002)(92726001)(92566001)(79102001)(2201001)(62966002)(77156001)(87936001)(50226001)(88136002)(77982001)(93916002)(46102001)(31966008)(74662001)(81542001)(74502001)(84676001)(76482001)(50986999)(104166001)(76176999)(15975445006)(48376002)(15202345003)(102836001)(83072002)(85852003)(107046002)(229853001)(21056001)(105596002)(50466002)(106466001)(97736003)(19627235001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB035;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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

