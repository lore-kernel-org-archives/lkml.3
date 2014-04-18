Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaDRM3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:29:36 -0400
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:52581
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752746AbaDRM3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:29:32 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH 28/28] Documentation: Add documentation for Nios2 architecture
Date: Fri, 18 Apr 2014 20:27:11 +0800
Message-ID: <1397824031-4892-25-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397824031-4892-1-git-send-email-lftan@altera.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(199002)(189002)(76176999)(99396002)(6806004)(50986999)(80022001)(87286001)(93916002)(88136002)(86362001)(50466002)(19580405001)(62966002)(2201001)(92566001)(92726001)(77982001)(2009001)(47776003)(20776003)(80976001)(44976005)(48376002)(83322001)(15975445006)(19580395003)(15202345003)(84676001)(81542001)(97736001)(76482001)(81342001)(77156001)(83072002)(85852003)(42186004)(36756003)(4396001)(87936001)(89996001)(50226001)(46102001)(16796002)(74502001)(31966008)(74662001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB029;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:A8F875D6.AF058619.BD71E8F.9445B66D.201D5;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 018577E36E
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
index 0000000..33eec4d
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
+Altera family of FPGAs. In order to support Linux system, Nios II needs to configure
+with MMU and hardware multiplier enabled.
+
+Nios II ABI
+===========
+Please refer to chapter "Application Binary Interface" in Nios II Processor Reference
+Handbook.
-- 
1.8.3.2

