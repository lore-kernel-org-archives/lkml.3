Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab3HTHzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:55:12 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39756 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab3HTHzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:55:09 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-mtd@lists.infradead.org,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Markus Niebel <Markus.Niebel@tqs.de>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 3/3] mtd: m25p80: add support for mr25h10
Date: Tue, 20 Aug 2013 09:54:41 +0200
Message-Id: <1376985281-16293-4-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1376985281-16293-1-git-send-email-s.hauer@pengutronix.de>
References: <1376985281-16293-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Niebel <Markus.Niebel@tqs.de>

This adds support for the Everspin mr25h10 MRAM chip to the m25p80
driver.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/mtd/devices/m25p80.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 6f93d32..a48f152 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -743,6 +743,7 @@ static const struct spi_device_id m25p_ids[] = {
 
 	/* Everspin */
 	{ "mr25h256", CAT25_INFO(  32 * 1024, 1, 256, 2, M25P_NO_ERASE | M25P_NO_FR) },
+	{ "mr25h10", CAT25_INFO(128 * 1024, 1, 256, 3, M25P_NO_ERASE | M25P_NO_FR) },
 
 	/* GigaDevice */
 	{ "gd25q32", INFO(0xc84016, 0, 64 * 1024,  64, SECT_4K) },
-- 
1.8.4.rc3

