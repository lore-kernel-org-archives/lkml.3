Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbaLWKDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:03:54 -0500
Received: from mail-by2on0101.outbound.protection.outlook.com ([207.46.100.101]:44062
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755446AbaLWJ6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 04:58:30 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <stefan.wahren@i2se.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v4 02/21] of: Add vendor prefix for Himax Technologies Inc.
Date: Tue, 23 Dec 2014 18:02:00 +0800
Message-ID: <1419328939-22758-3-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419328939-22758-1-git-send-email-Ying.Liu@freescale.com>
References: <1419328939-22758-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(21056001)(64706001)(20776003)(68736005)(4396001)(2950100001)(84676001)(50466002)(19580405001)(87936001)(47776003)(48376002)(106466001)(50226001)(105606002)(89996001)(46102003)(36756003)(19580395003)(31966008)(77156002)(2351001)(97736003)(229853001)(107046002)(92566001)(120916001)(76176999)(110136001)(62966003)(85426001)(77096005)(104016003)(99396003)(6806004)(50986999)(86362001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0639;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0639;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0301MB0639;
X-Forefront-PRVS: 04347F8039
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0639;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2014 09:58:20.6827
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR0301MB0639
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
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

