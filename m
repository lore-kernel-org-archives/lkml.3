Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730AbaEMJGz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:06:55 -0400
Received: from mail-bn1bon0131.outbound.protection.outlook.com ([157.56.111.131]:59690
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932693AbaEMJGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:06:48 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>, "David S. Miller" <davem@davemloft.net>,
        <sparclinux@vger.kernel.org>
Subject: [PATCH 22/25] sparc: Add 32 bit time_t and clock_t
Date: Tue, 13 May 2014 17:06:37 +0800
Message-ID: <1399971997-4781-1-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399971456-3941-1-git-send-email-lftan@altera.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(189002)(199002)(77982001)(87936001)(84676001)(16796002)(76176999)(74502001)(92566001)(47776003)(20776003)(2009001)(36756003)(76482001)(86362001)(50466002)(87286001)(50986999)(102836001)(79102001)(89996001)(85852003)(77156001)(83072002)(48376002)(44976005)(46102001)(6806004)(83322001)(19580405001)(31966008)(19580395003)(74662001)(62966002)(92726001)(81542001)(33646001)(50226001)(4396001)(80022001)(81342001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB032;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
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
 arch/sparc/include/uapi/asm/posix_types.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/sparc/include/uapi/asm/posix_types.h b/arch/sparc/include/uapi/asm/posix_types.h
index 156220e..c5eaaef 100644
--- a/arch/sparc/include/uapi/asm/posix_types.h
+++ b/arch/sparc/include/uapi/asm/posix_types.h
@@ -42,6 +42,12 @@ typedef long                   __kernel_daddr_t;
 typedef unsigned short	       __kernel_old_dev_t;
 #define __kernel_old_dev_t __kernel_old_dev_t
 
+typedef long	__kernel_time_t;
+#define __kernel_time_t __kernel_time_t
+
+typedef long	__kernel_clock_t;
+#define __kernel_clock_t __kernel_clock_t
+
 #endif /* defined(__sparc__) && defined(__arch64__) */
 
 #include <asm-generic/posix_types.h>
-- 
1.8.2.1

