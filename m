Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbbACT5t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 14:57:49 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:37202 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbbACT5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 14:57:46 -0500
Date: Sun, 4 Jan 2015 01:27:40 +0530
From: Nizam Haider <nizamhaider786@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 0002-Spi-spi-gpio-fixed-spaces-coding-style-issue.patch
Message-ID: <20150103195740.GB20435@suse.suse>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="XF85m9dhOBO43t/C"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



--XF85m9dhOBO43t/C
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0002-Spi-spi-gpio-fixed-spaces-coding-style-issue.patch"

>From 00454f12a304489125bbdfbc2f50de3c2b9d49d3 Mon Sep 17 00:00:00 2001
From: Nizam Haider <nizamhaider786@gmail.com>
Date: Sun, 4 Jan 2015 00:24:38 +0530
Subject: [PATCH 2/2] Spi: spi-gpio: fixed spaces coding style issue

Fixed a coding style issue.

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
1.8.1.4


--XF85m9dhOBO43t/C--
