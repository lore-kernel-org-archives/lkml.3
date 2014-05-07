Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaEGGnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 02:43:20 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:40039
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751670AbaEGGnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 02:43:18 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <linux-mm@kvack.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] mm, highmem: clean up the comment
Date: Wed, 7 May 2014 13:57:45 +0800
Message-ID: <1399442265-22421-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(189002)(199002)(92726001)(89996001)(77982001)(19580395003)(83322001)(19580405001)(69596002)(4396001)(81342001)(68736004)(62966002)(77096999)(83072002)(85852003)(88136002)(76482001)(97736001)(2009001)(87936001)(81156002)(46102001)(86362001)(93916002)(99396002)(87286001)(92566001)(50986999)(50226001)(79102001)(84676001)(77156001)(74502001)(74662001)(31966008)(20776003)(47776003)(80022001)(64706001)(50466002)(81542001)(44976005)(6806004)(36756003)(48376002)(21056001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB501;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0204F0BDE2
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 mm/highmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/highmem.c b/mm/highmem.c
index b32b70c..d062c89 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -421,4 +421,4 @@ void __init page_address_init(void)
 	}
 }
 
-#endif	/* defined(CONFIG_HIGHMEM) && !defined(WANT_PAGE_VIRTUAL) */
+#endif	/* defined(CONFIG_HIGHMEM) */
-- 
1.8.4

