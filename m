Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbaDRMvl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 08:51:41 -0400
Received: from mail-bn1on0130.outbound.protection.outlook.com ([157.56.110.130]:13757
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753030AbaDRMnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:43:06 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH 26/28] Add ELF machine define for Nios2
Date: Fri, 18 Apr 2014 20:27:09 +0800
Message-ID: <1397824031-4892-23-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397824031-4892-1-git-send-email-lftan@altera.com>
References: <1397824031-4892-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(199002)(189002)(36756003)(47776003)(20776003)(74502001)(99396002)(93916002)(575784001)(86362001)(85852003)(83072002)(50986999)(97736001)(16796002)(2009001)(31966008)(74662001)(84676001)(88136002)(87936001)(89996001)(76176999)(87286001)(19580395003)(80022001)(62966002)(2201001)(92566001)(92726001)(80976001)(81342001)(46102001)(50226001)(4396001)(81542001)(6806004)(19580405001)(83322001)(44976005)(77982001)(42186004)(50466002)(77156001)(76482001)(48376002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB065;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:EAD846DF.2BD6948A.E74939D.7EA9A6ED.20108;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 018577E36E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ley Foon Tan <lftan@altera.com>
---
 include/uapi/linux/elf-em.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/elf-em.h b/include/uapi/linux/elf-em.h
index 01529bd..7f06c0d 100644
--- a/include/uapi/linux/elf-em.h
+++ b/include/uapi/linux/elf-em.h
@@ -33,6 +33,7 @@
 #define EM_M32R		88	/* Renesas M32R */
 #define EM_MN10300	89	/* Panasonic/MEI MN10300, AM33 */
 #define EM_BLACKFIN     106     /* ADI Blackfin Processor */
+#define EM_ALTERA_NIOS2	113	/* Altera Nios II soft-core processor */
 #define EM_TI_C6000	140	/* TI C6X DSPs */
 #define EM_AARCH64	183	/* ARM 64 bit */
 #define EM_FRV		0x5441	/* Fujitsu FR-V */
-- 
1.8.3.2

