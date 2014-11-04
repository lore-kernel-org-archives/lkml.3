Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaKDK2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:28:47 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48871 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbaKDK2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:28:43 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: David Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] MAINTAINERS: add maintainer for IPUv3 core driver
Date: Tue,  4 Nov 2014 11:28:40 +0100
Message-Id: <1415096920-1800-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 2.1.1
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add myself as maintainer for the IPUv3 core driver.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 34d3671..1c48287 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3917,6 +3917,13 @@ S:	Maintained
 F:	include/linux/platform_data/video-imxfb.h
 F:	drivers/video/fbdev/imxfb.c
 
+FREESCALE IMX IPUv3 CORE DRIVER
+M:	Philipp Zabel <p.zabel@pengutronix.de>
+L:	dri-devel@lists.freedesktop.org
+S:	Maintained
+F:	drivers/gpu/ipu-v3/
+F:	include/video/imx-ipu-v3.h
+
 FREESCALE SOC FS_ENET DRIVER
 M:	Pantelis Antoniou <pantelis.antoniou@gmail.com>
 M:	Vitaly Bordug <vbordug@ru.mvista.com>
-- 
2.1.1

