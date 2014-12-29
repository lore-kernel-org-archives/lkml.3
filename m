Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbaL2GhY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 01:37:24 -0500
Received: from mail-by2on0147.outbound.protection.outlook.com ([207.46.100.147]:47909
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752259AbaL2GhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 01:37:07 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <stefan.wahren@i2se.com>, <a.hajda@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v6 21/21] ARM: imx_v6_v7_defconfig: Add support for Himax HX8369A panel
Date: Mon, 29 Dec 2014 14:39:28 +0800
Message-ID: <1419835168-9034-22-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419835168-9034-1-git-send-email-Ying.Liu@freescale.com>
References: <1419835168-9034-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(199003)(64706001)(99396003)(2950100001)(105606002)(62966003)(77156002)(77096005)(21056001)(36756003)(87936001)(229853001)(2351001)(106466001)(107046002)(50466002)(85426001)(68736005)(48376002)(46102003)(6806004)(104016003)(47776003)(110136001)(89996001)(84676001)(50226001)(120916001)(4396001)(76176999)(19580405001)(20776003)(97736003)(575784001)(86362001)(19580395003)(50986999)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0637;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0637;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0301MB0637;
X-Forefront-PRVS: 0440AC9990
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0637;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2014 06:37:05.5523
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR0301MB0637
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for Himax HX8369A panel.

The new imx_v6_v7_defconfig is generated in this way:
* make ARCH=arm imx_v6_v7_defconfig
* make ARCH=arm menuconfig and manually choose to build in
  the Himax HX8369A panel driver
* make ARCH=arm savedefconfig
* cp defconfig arch/arm/configs/imx_v6_v7_defconfig

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
 * Add the HIMAX prefix in the Kconfig name.

 arch/arm/configs/imx_v6_v7_defconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6_v7_defconfig
index 3e0e589..27db91b 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -192,6 +192,7 @@ CONFIG_SOC_CAMERA_OV2640=y
 CONFIG_IMX_IPUV3_CORE=y
 CONFIG_DRM=y
 CONFIG_DRM_PANEL_SIMPLE=y
+CONFIG_DRM_PANEL_HIMAX_HX8369A=y
 CONFIG_DRM_IMX=y
 CONFIG_DRM_IMX_FB_HELPER=y
 CONFIG_DRM_IMX_PARALLEL_DISPLAY=y
-- 
2.1.0

