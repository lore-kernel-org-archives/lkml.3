Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbaL3DaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 22:30:22 -0500
Received: from mail-bl2on0103.outbound.protection.outlook.com ([65.55.169.103]:52343
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751773AbaL3DaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 22:30:04 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <stefan.wahren@i2se.com>, <a.hajda@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v7 02/21] of: Add vendor prefix for Himax Technologies Inc.
Date: Tue, 30 Dec 2014 11:33:52 +0800
Message-ID: <1419910451-15268-3-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419910451-15268-1-git-send-email-Ying.Liu@freescale.com>
References: <1419910451-15268-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(199003)(50226001)(104016003)(106466001)(229853001)(105606002)(76176999)(19580405001)(84676001)(50986999)(6806004)(2351001)(99396003)(110136001)(87936001)(120916001)(19580395003)(85426001)(68736005)(21056001)(47776003)(20776003)(48376002)(89996001)(77096005)(64706001)(46102003)(2950100001)(62966003)(107046002)(4396001)(31966008)(50466002)(97736003)(86362001)(36756003)(92566001)(77156002)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0631;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0631;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR0301MB0631;
X-Forefront-PRVS: 04410E544A
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0631;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2014 03:30:00.3365
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR0301MB0631
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
v6->v7:
 * None.

v5->v6:
 * None.

v4->v5:
 * None.

v3->v4:
 * Fix an ordering issue to address Stefan Wahren's comment.

v2->v3:
 * None.

v1->v2:
 * None.

 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 78efebb..f46adb2 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -67,6 +67,7 @@ gumstix	Gumstix, Inc.
 gw	Gateworks Corporation
 hannstar	HannStar Display Corporation
 haoyu	Haoyu Microelectronic Co. Ltd.
+himax	Himax Technologies, Inc.
 hisilicon	Hisilicon Limited.
 hit	Hitachi Ltd.
 honeywell	Honeywell
-- 
2.1.0

