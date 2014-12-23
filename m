Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbaLWDm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 22:42:59 -0500
Received: from mail-bn1on0111.outbound.protection.outlook.com ([157.56.110.111]:3365
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754640AbaLWDm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 22:42:56 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v3 02/18] of: Add vendor prefix for Himax Technologies Inc.
Date: Tue, 23 Dec 2014 11:46:23 +0800
Message-ID: <1419306399-9387-3-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419306399-9387-1-git-send-email-Ying.Liu@freescale.com>
References: <1419306399-9387-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(199003)(19580405001)(19580395003)(46102003)(50226001)(120916001)(50466002)(84676001)(47776003)(20776003)(48376002)(104016003)(64706001)(6806004)(92566001)(76176999)(77096005)(68736005)(2950100001)(21056001)(36756003)(85426001)(31966008)(87936001)(89996001)(107046002)(99396003)(2351001)(229853001)(106466001)(77156002)(4396001)(97736003)(62966003)(110136001)(50986999)(86362001)(105606002)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0625;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0625;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR0301MB0625;
X-Forefront-PRVS: 04347F8039
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0625;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2014 03:42:46.2193
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0625
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
v2->v3:
 * None.

v1->v2:
 * None.

 Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 78efebb..3cee528 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -69,6 +69,7 @@ hannstar	HannStar Display Corporation
 haoyu	Haoyu Microelectronic Co. Ltd.
 hisilicon	Hisilicon Limited.
 hit	Hitachi Ltd.
+himax	Himax Technologies, Inc.
 honeywell	Honeywell
 hp	Hewlett Packard
 i2se	I2SE GmbH
-- 
2.1.0

