Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab3GZJMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 05:12:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:35350 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab3GZJML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 05:12:11 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Felipe Balbi <balbi@ti.com>
Cc: Bin Liu <binmlist@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, george.cherian@ti.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 06/16 => 1/2] usb: musb: dsps: rename ti81xx_driver_data to am33xx_driver_data
Date: Fri, 26 Jul 2013 11:11:37 +0200
Message-Id: <1374829898-3635-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130725161120.GC31835@radagast>
References: <20130725161120.GC31835@radagast>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ti81xx platform is not fully supported right now. This patch renames
the date structure to a am33xx prefix which is actually used.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/musb/musb_dsps.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 21838ba..28ed497 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -742,7 +742,7 @@ static int dsps_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(dsps_pm_ops, dsps_suspend, dsps_resume);
 
-static const struct dsps_musb_wrapper ti81xx_driver_data = {
+static const struct dsps_musb_wrapper am33xx_driver_data = {
 	.revision		= 0x00,
 	.control		= 0x14,
 	.status			= 0x18,
@@ -774,7 +774,7 @@ static const struct dsps_musb_wrapper ti81xx_driver_data = {
 
 static const struct of_device_id musb_dsps_of_match[] = {
 	{ .compatible = "ti,musb-am33xx",
-		.data = (void *) &ti81xx_driver_data, },
+		.data = (void *) &am33xx_driver_data, },
 	{  },
 };
 MODULE_DEVICE_TABLE(of, musb_dsps_of_match);
-- 
1.8.3.2

