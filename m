Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbbAZWtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 17:49:15 -0500
Received: from mail-by2on0108.outbound.protection.outlook.com ([207.46.100.108]:17952
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754054AbbAZWtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 17:49:12 -0500
Date: Mon, 26 Jan 2015 16:43:52 -0600
From: Kim Phillips <kim.phillips@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: [PATCH] .mailmap: update Konstantin Khlebnikov's email address
Message-ID: <20150126164352.8b40796d5e3b6caebaca3f28@freescale.com>
Organization: Freescale Semiconductor, Inc.
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=kim.phillips@freescale.com; gmail.com; dkim=none (message not
 signed) header.d=none;gmail.com; dmarc=permerror action=none
 header.from=freescale.com;
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(33646002)(46406003)(19580395003)(6806004)(19580405001)(77096005)(85426001)(86362001)(47776003)(87936001)(46102003)(50226001)(36756003)(104016003)(92566002)(106466001)(23726002)(105606002)(50466002)(229853001)(50986999)(110136001)(2351001)(77156002)(62966003)(100306002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB322;H:tx30smr01.am.freescale.net;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BL2PR03MB322;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2PR03MB322;
X-Forefront-PRVS: 0468FE4A2B
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB322;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2015 22:49:08.4095
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2PR03MB322
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_maintainer.pl returns k.khlebnikov@samsung.com via git history,
for which emails get rejected:

 RCPT TO:<k.khlebnikov@samsung.com>
 550 5.1.1 Recipient address rejected: User unknown

Use his other address that passes vger's mxverify:

 RCPT TO:<koct9i@gmail.com>
 250 2.1.5 OK ir10si13843754pbc.62 - gsmtp

and add his old email address in the wrong email address field.

Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 .mailmap | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.mailmap b/.mailmap
index d357e1b..0d971cf 100644
--- a/.mailmap
+++ b/.mailmap
@@ -73,6 +73,7 @@ Juha Yrjola <juha.yrjola@nokia.com>
 Juha Yrjola <juha.yrjola@solidboot.com>
 Kay Sievers <kay.sievers@vrfy.org>
 Kenneth W Chen <kenneth.w.chen@intel.com>
+Konstantin Khlebnikov <koct9i@gmail.com> <k.khlebnikov@samsung.com>
 Koushik <raghavendra.koushik@neterion.com>
 Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
 Leonid I Ananiev <leonid.i.ananiev@intel.com>
-- 
2.2.2

