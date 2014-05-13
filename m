Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710AbaEMJGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:06:44 -0400
Received: from mail-bn1bon0133.outbound.protection.outlook.com ([157.56.111.133]:49011
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932693AbaEMJGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:06:41 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>, <linux-sh@vger.kernel.org>
Subject: [PATCH 21/25] sh: Add 32 bit time_t and clock_t
Date: Tue, 13 May 2014 17:06:30 +0800
Message-ID: <1399971990-4744-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399971456-3941-1-git-send-email-lftan@altera.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(199002)(189002)(81342001)(62966002)(50226001)(46102001)(6806004)(44976005)(19580395003)(83322001)(19580405001)(31966008)(77156001)(80022001)(4396001)(102836001)(74662001)(81542001)(36756003)(20776003)(47776003)(48376002)(575784001)(86362001)(50466002)(76482001)(79102001)(92726001)(89996001)(76176999)(85852003)(92566001)(74502001)(50986999)(16796002)(33646001)(87286001)(87936001)(84676001)(77982001)(83072002)(2009001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB016;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
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
 arch/sh/include/uapi/asm/posix_types_32.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/sh/include/uapi/asm/posix_types_32.h b/arch/sh/include/uapi/asm/posix_types_32.h
index ba0bdc4..cfc4331 100644
--- a/arch/sh/include/uapi/asm/posix_types_32.h
+++ b/arch/sh/include/uapi/asm/posix_types_32.h
@@ -17,6 +17,12 @@ typedef unsigned short	__kernel_old_gid_t;
 typedef unsigned short	__kernel_old_dev_t;
 #define __kernel_old_dev_t __kernel_old_dev_t
 
+typedef long	__kernel_time_t;
+#define __kernel_time_t __kernel_time_t
+
+typedef long	__kernel_clock_t;
+#define __kernel_clock_t __kernel_clock_t
+
 #include <asm-generic/posix_types.h>
 
 #endif /* __ASM_SH_POSIX_TYPES_32_H */
-- 
1.8.2.1

