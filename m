Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884AbaEMJNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:13:52 -0400
Received: from mail-by2on0125.outbound.protection.outlook.com ([207.46.100.125]:29627
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759732AbaEMJDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:03:32 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>, David Howells <dhowells@redhat.com>
Subject: [PATCH 08/25] frv: Add 32 bit time_t and clock_t
Date: Tue, 13 May 2014 17:03:07 +0800
Message-ID: <1399971787-4263-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399971456-3941-1-git-send-email-lftan@altera.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(199002)(189002)(62966002)(74662001)(6806004)(46102001)(44976005)(19580395003)(81342001)(19580405001)(83322001)(31966008)(50226001)(4396001)(80022001)(74502001)(81542001)(102836001)(77156001)(92726001)(33646001)(20776003)(36756003)(47776003)(50466002)(86362001)(76482001)(87936001)(50986999)(79102001)(92566001)(83072002)(89996001)(2009001)(48376002)(87286001)(84676001)(77982001)(76176999)(85852003)(16796002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB030;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0210479ED8
Authentication-Results: spf=softfail (sender IP is 66.35.236.232)
 smtp.mailfrom=lftan@altera.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Override time_t and clock_t in include/uapi/asm-generic.

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 arch/frv/include/uapi/asm/posix_types.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/frv/include/uapi/asm/posix_types.h b/arch/frv/include/uapi/asm/posix_types.h
index fe512af..0a837e6 100644
--- a/arch/frv/include/uapi/asm/posix_types.h
+++ b/arch/frv/include/uapi/asm/posix_types.h
@@ -20,6 +20,12 @@ typedef unsigned short	__kernel_gid_t;
 typedef unsigned short	__kernel_old_dev_t;
 #define __kernel_old_dev_t __kernel_old_dev_t
 
+typedef long	__kernel_time_t;
+#define __kernel_time_t __kernel_time_t
+
+typedef long	__kernel_clock_t;
+#define __kernel_clock_t __kernel_clock_t
+
 #include <asm-generic/posix_types.h>
 
 #endif
-- 
1.8.2.1

