Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab3G2HiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 03:38:13 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:63467 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab3G2HiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 03:38:11 -0400
From: Niels de Vos <ndevos@redhat.com>
To: devicetree@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Niels de Vos <ndevos@redhat.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH] spi-imx: expose module alias for loading from device-tree
Date: Mon, 29 Jul 2013 09:38:05 +0200
Message-Id: <1375083485-14785-1-git-send-email-ndevos@redhat.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable auto loading by udev when spi-imx is compiled as a module.

Signed-off-by: Niels de Vos <ndevos@redhat.com>
Cc: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/spi/spi-imx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 7db4f43..ebfd20e 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -619,6 +619,7 @@ static const struct of_device_id spi_imx_dt_ids[] = {
 	{ .compatible = "fsl,imx51-ecspi", .data = &imx51_ecspi_devtype_data, },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, spi_imx_dt_ids);
 
 static void spi_imx_chipselect(struct spi_device *spi, int is_active)
 {
-- 
1.7.11.7

