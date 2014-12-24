Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaLXIhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 03:37:18 -0500
Received: from mail-by2on0146.outbound.protection.outlook.com ([207.46.100.146]:64800
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752012AbaLXIhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 03:37:12 -0500
From: Liu Ying <Ying.Liu@freescale.com>
To: <dri-devel@lists.freedesktop.org>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>,
        <p.zabel@pengutronix.de>, <thierry.reding@gmail.com>,
        <shawn.guo@linaro.org>, <mturquette@linaro.org>, <airlied@linux.ie>,
        <andyshrk@gmail.com>, <stefan.wahren@i2se.com>, <a.hajda@samsung.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v5 19/21] ARM: imx_v6_v7_defconfig: Cleanup for imx drm being moved out of staging
Date: Wed, 24 Dec 2014 16:39:41 +0800
Message-ID: <1419410383-6359-20-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419410383-6359-1-git-send-email-Ying.Liu@freescale.com>
References: <1419410383-6359-1-git-send-email-Ying.Liu@freescale.com>
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Ying.Liu@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(199003)(87936001)(6806004)(104016003)(229853001)(105606002)(106466001)(84676001)(85426001)(107046002)(20776003)(2950100001)(47776003)(62966003)(64706001)(77156002)(50466002)(19580395003)(77096005)(50226001)(36756003)(46102003)(19580405001)(92566001)(86362001)(575784001)(31966008)(76176999)(48376002)(4396001)(120916001)(110136001)(68736005)(50986999)(97736003)(2351001)(89996001)(99396003)(21056001)(217873001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0628;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0628;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR0301MB0628;
X-Forefront-PRVS: 04359FAD81
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0628;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2014 08:37:08.2850
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0628
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new imx_v6_v7_defconfig is generated in this way:
* make ARCH=arm imx_v6_v7_defconfig
* make ARCH=arm savedefconfig
* cp defconfig arch/arm/configs/imx_v6_v7_defconfig

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
v4->v5:
 * None.

v3->v4:
 * None.

v2->v3:
 * None.

v1->v2:
 * None.

 arch/arm/configs/imx_v6_v7_defconfig | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/arm/configs/imx_v6_v7_defconfig b/arch/arm/configs/imx_v6_v7_defconfig
index 6790f1b..0dbd0c3 100644
--- a/arch/arm/configs/imx_v6_v7_defconfig
+++ b/arch/arm/configs/imx_v6_v7_defconfig
@@ -192,7 +192,13 @@ CONFIG_SOC_CAMERA_OV2640=y
 CONFIG_IMX_IPUV3_CORE=y
 CONFIG_DRM=y
 CONFIG_DRM_PANEL_SIMPLE=y
-CONFIG_BACKLIGHT_LCD_SUPPORT=y
+CONFIG_DRM_IMX=y
+CONFIG_DRM_IMX_FB_HELPER=y
+CONFIG_DRM_IMX_PARALLEL_DISPLAY=y
+CONFIG_DRM_IMX_TVE=y
+CONFIG_DRM_IMX_LDB=y
+CONFIG_DRM_IMX_IPUV3=y
+CONFIG_DRM_IMX_HDMI=y
 CONFIG_LCD_CLASS_DEVICE=y
 CONFIG_LCD_L4F00242T03=y
 CONFIG_LCD_PLATFORM=y
@@ -249,13 +255,6 @@ CONFIG_IMX_SDMA=y
 CONFIG_MXS_DMA=y
 CONFIG_FSL_EDMA=y
 CONFIG_STAGING=y
-CONFIG_DRM_IMX=y
-CONFIG_DRM_IMX_FB_HELPER=y
-CONFIG_DRM_IMX_PARALLEL_DISPLAY=y
-CONFIG_DRM_IMX_TVE=y
-CONFIG_DRM_IMX_LDB=y
-CONFIG_DRM_IMX_IPUV3=y
-CONFIG_DRM_IMX_HDMI=y
 # CONFIG_IOMMU_SUPPORT is not set
 CONFIG_PWM=y
 CONFIG_PWM_IMX=y
-- 
2.1.0

