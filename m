Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759802AbaEMJFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:05:38 -0400
Received: from mail-by2on0140.outbound.protection.outlook.com ([207.46.100.140]:48260
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759323AbaEMJFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:05:33 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 13/25] microblaze: Add 32 bit time_t and clock_t
Date: Tue, 13 May 2014 17:05:19 +0800
Message-ID: <1399971919-4450-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399971456-3941-1-git-send-email-lftan@altera.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(189002)(199002)(36756003)(84676001)(87286001)(76176999)(33646001)(50986999)(77982001)(83072002)(2009001)(76482001)(87936001)(50466002)(85852003)(48376002)(47776003)(102836001)(92566001)(16796002)(74662001)(79102001)(89996001)(20776003)(46102001)(6806004)(83322001)(19580405001)(31966008)(44976005)(19580395003)(74502001)(80022001)(81342001)(62966002)(92726001)(86362001)(77156001)(50226001)(81542001)(4396001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB050;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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
 arch/microblaze/include/uapi/asm/posix_types.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/microblaze/include/uapi/asm/posix_types.h b/arch/microblaze/include/uapi/asm/posix_types.h
index 0e15039..20e5d98 100644
--- a/arch/microblaze/include/uapi/asm/posix_types.h
+++ b/arch/microblaze/include/uapi/asm/posix_types.h
@@ -4,6 +4,12 @@
 typedef unsigned short	__kernel_mode_t;
 #define __kernel_mode_t __kernel_mode_t
 
+typedef long	__kernel_time_t;
+#define __kernel_time_t __kernel_time_t
+
+typedef long	__kernel_clock_t;
+#define __kernel_clock_t __kernel_clock_t
+
 #include <asm-generic/posix_types.h>
 
 #endif /* _ASM_MICROBLAZE_POSIX_TYPES_H */
-- 
1.8.2.1

