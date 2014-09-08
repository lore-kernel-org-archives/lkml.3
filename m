Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbaIHJrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 05:47:06 -0400
Received: from mail-bl2on0061.outbound.protection.outlook.com ([65.55.169.61]:36544
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753781AbaIHJia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 05:38:30 -0400
From: Ley Foon Tan <lftan@altera.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC: Ley Foon Tan <lftan@altera.com>, <lftan.linux@gmail.com>,
        <cltang@codesourcery.com>
Subject: [PATCH v3 15/29] Add ELF machine define for Nios2
Date: Mon, 8 Sep 2014 17:22:26 +0800
Message-ID: <1410168160-3624-16-git-send-email-lftan@altera.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1410168160-3624-1-git-send-email-lftan@altera.com>
References: <1410168160-3624-1-git-send-email-lftan@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.227;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009017)(6009001)(199003)(189002)(81342001)(21056001)(76482001)(79102001)(77156001)(77982001)(85852003)(83072002)(19580395003)(19580405001)(46102001)(2201001)(20776003)(47776003)(102836001)(95666004)(105596002)(106466001)(90102001)(575784001)(97736003)(33646002)(42186005)(86362001)(83322001)(92566001)(93916002)(6806004)(92726001)(88136002)(4396001)(99396002)(76176999)(44976005)(74662001)(89996001)(74502001)(31966008)(50986999)(62966002)(80022001)(50466002)(85306004)(84676001)(107046002)(229853001)(87286001)(87936001)(77096002)(50226001)(48376002)(68736004)(81542001)(36756003)(104166001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB033;H:sj-itexedge03.altera.priv.altera.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
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
1.8.2.1

