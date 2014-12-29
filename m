Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaL2GgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 01:36:00 -0500
Received: from mail-bn1bon0141.outbound.protection.outlook.com ([157.56.111.141]:24416
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751982AbaL2Gfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 01:35:53 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <stefan.wahren@i2se.com>, <a.hajda@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v6 04/21] ARM: imx6q: Add GPR3 MIPI muxing control register field shift bits definition
Date: Mon, 29 Dec 2014 14:39:11 +0800
Message-ID: <1419835168-9034-5-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419835168-9034-1-git-send-email-Ying.Liu@freescale.com>
References: <1419835168-9034-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(199003)(189002)(77156002)(62966003)(575784001)(84676001)(120916001)(50466002)(68736005)(76176999)(87936001)(86362001)(48376002)(99396003)(2950100001)(89996001)(50986999)(77096005)(105606002)(4396001)(104016003)(19580405001)(107046002)(6806004)(36756003)(85426001)(20776003)(97736003)(21056001)(64706001)(110136001)(50226001)(19580395003)(2351001)(229853001)(47776003)(106466001)(46102003)(32563001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB214;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB214;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BLUPR03MB214;
X-Forefront-PRVS: 0440AC9990
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB214;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2014 06:35:50.6818
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLUPR03MB214
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a macro to define the GPR3 MIPI muxing control register field
shift bits.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
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

