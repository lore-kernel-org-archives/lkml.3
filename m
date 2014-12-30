Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaL3Daa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 22:30:30 -0500
Received: from mail-bn1on0132.outbound.protection.outlook.com ([157.56.110.132]:64522
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751967AbaL3DaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 22:30:12 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <stefan.wahren@i2se.com>, <a.hajda@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v7 04/21] ARM: imx6q: Add GPR3 MIPI muxing control register field shift bits definition
Date: Tue, 30 Dec 2014 11:33:54 +0800
Message-ID: <1419910451-15268-5-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419910451-15268-1-git-send-email-Ying.Liu@freescale.com>
References: <1419910451-15268-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(199003)(36756003)(110136001)(48376002)(2351001)(104016003)(87936001)(106466001)(89996001)(2950100001)(77096005)(68736005)(575784001)(76176999)(4396001)(86362001)(50226001)(20776003)(46102003)(50466002)(107046002)(64706001)(84676001)(50986999)(229853001)(120916001)(77156002)(21056001)(99396003)(47776003)(105606002)(92566001)(62966003)(85426001)(31966008)(19580395003)(6806004)(19580405001)(97736003)(32563001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR03MB1015;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB1015;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY2PR03MB1015;
X-Forefront-PRVS: 04410E544A
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB1015;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2014 03:30:08.6417
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY2PR03MB1015
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a macro to define the GPR3 MIPI muxing control register field
shift bits.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
v6->v7:
 * None.

v5->v6:
 * None.

v4->v5:
 * None.

v3->v4:
 * None.

v2->v3:
 * None.

v1->v2:
 * None.

 include/linux/mfd/syscon/imx6q-iomuxc-gpr.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/mfd/syscon/imx6q-iomuxc-gpr.h b/include/linux/mfd/syscon/imx6q-iomuxc-gpr.h
index ff44374..3b0bed4 100644
--- a/include/linux/mfd/syscon/imx6q-iomuxc-gpr.h
+++ b/include/linux/mfd/syscon/imx6q-iomuxc-gpr.h
@@ -207,6 +207,7 @@
 #define IMX6Q_GPR3_LVDS0_MUX_CTL_IPU1_DI1	(0x1 << 6)
 #define IMX6Q_GPR3_LVDS0_MUX_CTL_IPU2_DI0	(0x2 << 6)
 #define IMX6Q_GPR3_LVDS0_MUX_CTL_IPU2_DI1	(0x3 << 6)
+#define IMX6Q_GPR3_MIPI_MUX_CTL_SHIFT		4
 #define IMX6Q_GPR3_MIPI_MUX_CTL_MASK		(0x3 << 4)
 #define IMX6Q_GPR3_MIPI_MUX_CTL_IPU1_DI0	(0x0 << 4)
 #define IMX6Q_GPR3_MIPI_MUX_CTL_IPU1_DI1	(0x1 << 4)
-- 
2.1.0

