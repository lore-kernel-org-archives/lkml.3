Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbbATUVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 15:21:21 -0500
Received: from mail-bn1bon0147.outbound.protection.outlook.com ([157.56.111.147]:19520
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751152AbbATUVT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 15:21:19 -0500
X-Greylist: delayed 838 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jan 2015 15:21:19 EST
Date: Tue, 20 Jan 2015 14:01:42 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH 1/2] mm/slub: fix typo
Message-ID: <20150120140142.cd2e32d83d66459562bd1717@freescale.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Kim.Phillips@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(106466001)(46102003)(105606002)(97736003)(229853001)(36756003)(50986999)(46406003)(19580405001)(62966003)(50226001)(33646002)(19580395003)(6806004)(23726002)(50466002)(104016003)(100306002)(47776003)(85426001)(87936001)(92566002)(86362001)(64706001)(77096005)(77156002)(68736005);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB322;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BL2PR03MB322;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2PR03MB322;
X-Forefront-PRVS: 0462918D61
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB322;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2015 20:07:07.9015
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2PR03MB322
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 mm/slub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index fe376fe..a64cc1b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2512,7 +2512,7 @@ EXPORT_SYMBOL(kmem_cache_alloc_node_trace);
 #endif
 
 /*
- * Slow patch handling. This may still be called frequently since objects
+ * Slow path handling. This may still be called frequently since objects
  * have a longer lifetime than the cpu slabs in most processing loads.
  *
  * So we still attempt to reduce cache line usage. Just take the slab
-- 
2.2.2

