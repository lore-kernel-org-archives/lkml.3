Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab3H2Mfe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 08:35:34 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49733 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab3H2Mfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 08:35:32 -0400
From: Marek Belisko <marek@goldelico.com>
To: tomi.valkeinen@ti.com, plagnioj@jcrosoft.com
Cc: linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marek Belisko <marek@goldelico.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>
Subject: [PATCH] omap2: panel-generic: Added panel parameters for ortus-com37h3m05dtc/99dtc and sharp-lq070y3dg3b.
Date: Thu, 29 Aug 2013 14:35:24 +0200
Message-Id: <1377779724-30648-1-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 drivers/video/omap2/displays/panel-generic-dpi.c | 53 ++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/video/omap2/displays/panel-generic-dpi.c b/drivers/video/omap2/displays/panel-generic-dpi.c
index bebebd4..d573291 100644
--- a/drivers/video/omap2/displays/panel-generic-dpi.c
+++ b/drivers/video/omap2/displays/panel-generic-dpi.c
@@ -107,6 +107,33 @@ static struct panel_config generic_dpi_panels[] = {
 		.name			= "sharp_ls",
 	},
 
+	/* Sharp LQ070Y3DG3B */
+	{
+		{
+			.x_res		= 800,
+			.y_res		= 480,
+
+			.pixel_clock	= 33260,
+
+			.hsw		= 128,
+			.hfp		= 64,
+			.hbp		= 64,
+
+			.vsw		= 2,
+			.vfp		= 8,
+			.vbp		= 35,
+
+			.vsync_level	= OMAPDSS_SIG_ACTIVE_LOW,
+			.hsync_level	= OMAPDSS_SIG_ACTIVE_LOW,
+			.data_pclk_edge	= OMAPDSS_DRIVE_SIG_RISING_EDGE,
+			.de_level	= OMAPDSS_SIG_ACTIVE_HIGH,
+			.sync_pclk_edge	= OMAPDSS_DRIVE_SIG_RISING_EDGE,
+		},
+		.power_on_delay		= 50,
+		.power_off_delay	= 100,
+		.name			= "sharp_lq070y3dg3b",
+	},
+
 	/* Toppoly TDO35S */
 	{
 		{
@@ -369,6 +396,32 @@ static struct panel_config generic_dpi_panels[] = {
 		.name			= "ortustech_com43h4m10xtc",
 	},
 
+	/* OrtusTech COM37H3M05DTC and COM37H3M99DTC */
+	{
+		{
+			.x_res		= 480,
+			.y_res		= 640,
+			
+			/* pixel clock could be lowered to reduce noise */
+			.pixel_clock	= 22153,
+			
+			.hsw		= 10,
+			.hfp		= 8,
+			.hbp		= 10,
+
+			.vsw		= 3,
+			.vfp		= 4,
+			.vbp		= 4,
+
+			.vsync_level	= OMAPDSS_SIG_ACTIVE_LOW,
+			.hsync_level	= OMAPDSS_SIG_ACTIVE_LOW,
+			.data_pclk_edge	= OMAPDSS_DRIVE_SIG_RISING_EDGE,
+			.de_level	= OMAPDSS_SIG_ACTIVE_HIGH,
+			.sync_pclk_edge	= OMAPDSS_DRIVE_SIG_RISING_EDGE,
+		},
+		.name			= "ortustech_com37h3m05dtc",
+	},
+
 	/* Innolux AT080TN52 */
 	{
 		{
-- 
1.8.1.2

