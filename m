Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936137Ab3DHUed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:34:33 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:54207 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935836Ab3DHUeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:34:31 -0400
Message-ID: <1365453268.1830.137.camel@x61.thuisdomein>
Subject: [PATCH] [media] soc-camera: remove "config MX3_VIDEO"
From: Paul Bolle <pebolle@tiscali.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 08 Apr 2013 22:34:28 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Apr 2013 20:34:29.0519 (UTC) FILETIME=[781D69F0:01CE3498]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last user of Kconfig symbol MX3_VIDEO was removed in v3.2. Its
Kconfig entry can be removed now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "git grep".

 drivers/media/platform/soc_camera/Kconfig | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
index b139b52..f73057a 100644
--- a/drivers/media/platform/soc_camera/Kconfig
+++ b/drivers/media/platform/soc_camera/Kconfig
@@ -27,14 +27,10 @@ config VIDEO_MX1
 	---help---
 	  This is a v4l2 driver for the i.MX1/i.MXL CMOS Sensor Interface
 
-config MX3_VIDEO
-	bool
-
 config VIDEO_MX3
 	tristate "i.MX3x Camera Sensor Interface driver"
 	depends on VIDEO_DEV && MX3_IPU && SOC_CAMERA
 	select VIDEOBUF2_DMA_CONTIG
-	select MX3_VIDEO
 	---help---
 	  This is a v4l2 driver for the i.MX3x Camera Sensor Interface
 
-- 
1.7.11.7

