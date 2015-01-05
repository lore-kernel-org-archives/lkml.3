Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbbAEMCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:02:14 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:44500 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbbAEMCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:02:12 -0500
From: nizamhaider786@gmail.com
To: broonie@kernel.org
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nizam Haider <nizamhaider786@gmail.com>
Subject: [PATCH 3/3] spi:spi-gpio: fixed space coding styple issue
Date: Mon,  5 Jan 2015 17:31:03 +0530
Message-Id: <1420459263-2190-1-git-send-email-nizamhaider786@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nizam Haider <nizamhaider786@gmail.com>

fixed a coding style issue

Signed-off-by: Nizam Haider <nizamhaider786@gmail.com>
---
 drivers/spi/spi-gpio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-gpio.c b/drivers/spi/spi-gpio.c
index aee4e75..702b0b8 100644
--- a/drivers/spi/spi-gpio.c
+++ b/drivers/spi/spi-gpio.c
@@ -92,7 +92,7 @@ struct spi_gpio {
 
 /*----------------------------------------------------------------------*/
 
-static inline struct spi_gpio * __pure
+static inline struct spi_gpio *__pure
 spi_to_spi_gpio(const struct spi_device *spi)
 {
 	const struct spi_bitbang	*bang;
@@ -103,7 +103,7 @@ spi_to_spi_gpio(const struct spi_device *spi)
 	return spi_gpio;
 }
 
-static inline struct spi_gpio_platform_data * __pure
+static inline struct spi_gpio_platform_data *__pure
 spi_to_pdata(const struct spi_device *spi)
 {
 	return &spi_to_spi_gpio(spi)->pdata;
-- 
2.1.3

